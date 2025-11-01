# Image PHP/Apache MoodleHQ
FROM moodlehq/moodle-php-apache:8.3

# ARG instruction pass variable build-time
ARG DEBIAN_FRONTEND=noninteractive

COPY ./moodle /var/www/html


RUN chown -R www-data:www-data /var/www/html