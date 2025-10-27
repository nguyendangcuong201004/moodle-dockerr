#!/bin/bash

echo "Setting up Moodle..."

# --- Install direnv ---
if ! command -v direnv &> /dev/null
then
    sudo apt update && sudo apt install -y direnv
    # Add direnv hook to .bashrc if not already present
    if ! grep -q 'direnv hook bash' ~/.bashrc; then
      echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
      echo "   - Added direnv hook to ~/.bashrc. You MUST restart your terminal after this script."
    fi
else
    echo "   - direnv is already installed."
fi

# 1. Copy config.php if it doesn't exist
if [ ! -f "moodle/config.php" ]; then
  echo "   - Copying config.php template..."
  cp config.docker-template.php moodle/config.php
fi

# 2. Create data directories
echo "   - Creating data directories ..."
mkdir -p moodledata
mkdir -p moodle-db-data

# 3. Set execute permissions for bin scripts
echo "   - Setting execute permissions..."
chmod +x bin/*

# Manually export variables here as direnv is not assumed
export MOODLE_DOCKER_WWWROOT=./moodle
export MOODLE_DOCKER_DB=pgsql

bin/moodle-docker-compose up -d

# 5. Wait for Database
echo "   - Waiting for database..."
bin/moodle-docker-wait-for-db

# 6. Set File Permissions
echo "   - Setting file permissions..."
bin/moodle-docker-compose exec -T -u root webserver chown www-data:www-data /var/www/html/config.php
bin/moodle-docker-compose exec -T -u root webserver chown -R www-data:www-data /var/www/moodledata
sudo chown 999:999 moodle-db-data # Required for PostgreSQL bind mount

echo "Setup complete! Go to http://localhost:8000"