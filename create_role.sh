#!/bin/bash

read -rp "Role name > " ROLE_NAME

mkdir -p "roles/$ROLE_NAME/{tasks,handlers,files}"

read -rp "Become super-user? [y/N]: " USE_BECOME

USE_BECOME=$(echo "$USE_BECOME" | tr '[:upper:]' '[:lower:]')

read -rp "Enter tags (separate by commas; leave blank for none) > " TAGS

BECOME_LINE=""
if [ "$USE_BECOME" = "yes" ]; then
    BECOME_LINE="      become: yes"
fi

echo -e "    - role: $ROLE_NAME$BECOME_LINE" >>setup.yml

if [[ -n "$TAGS" ]]; then
    echo -e "      tags:" >>setup.yml
    # Prepare the tags line
    TAGS_LINE="        - ${TAGS//,/\\n        - }"
    echo -e "$TAGS_LINE" >>setup.yml
fi

echo "> Role '$ROLE_NAME' created!"
