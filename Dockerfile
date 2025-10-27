# Image PHP/Apache MoodleHQ
FROM moodlehq/moodle-php-apache:8.4


RUN apt-get update && apt-get install -y libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt các extension PHP
RUN docker-php-ext-install pdo_pgsql pgsql

# ARG instruction pass variable build-time
ARG DEBIAN_FRONTEND=noninteractive

COPY ./moodle /var/www/html


RUN chown -R www-data:www-data /var/www/html