#!/usr/bin/with-contenv bashio

# Uprade
apt-get dist-upgrade &>/dev/null

# Fix mate software center
if [ -f /usr/lib/dbus-1.0/dbus-daemon-launch-helper ]; then
chmod u+s /usr/lib/dbus-1.0/dbus-daemon-launch-helper
service dbus restart
fi

# Install specific apps
if bashio::config.has_value 'additional_apps'; then
    bashio::log.info "Installing additional apps :" 
    apt-get update &>/dev/null
    # Install apps
            for APP in $(echo "$(bashio::config 'additional_apps')" | tr "," " "); do
              bashio::log.green "... $APP"
              # Test install with both apt-get and snap
              apt-get install -yqq $APP &>/dev/null || snap install $APP \
              && bashio::log.green "... done" \
              || bashio::log.red "... not successful"
            done
fi
