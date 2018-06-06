#!/bin/sh
set -e

# Disabling nginx daemon mode
export KONG_NGINX_DAEMON="off"
export KONG_PG_HOST=$PG_HOST
export KONG_PG_PORT=$PG_PORT
export KONG_PG_USER=$PG_USER
export KONG_PG_PASSWORD=$PG_PASSWORD
export KONG_PG_DATABASE=$PG_DATABASE

# Setting default prefix (override any existing variable)
export KONG_PREFIX="/usr/local/kong"


# Prepare Kong prefix
if [ "$1" = "/usr/local/openresty/nginx/sbin/nginx" ]; then
	kong prepare -p "/usr/local/kong"
	
	# Run the migrations
	kong migrations up
fi

exec "$@"