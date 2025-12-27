#!/bin/bash

CREATE_ROLE_SCRIPT_URL="https://raw.githubusercontent.com/davnpsh/ansible-template/main/create_role.sh"

read -rp "Project name > " PROJECT_NAME

if [ -d "$PROJECT_NAME" ]; then
    echo "Directory $PROJECT_NAME already exists." >&2
    exit 1
fi

echo "Creating directories and files..."

mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

# files
touch ansible.cfg hosts secrets.yml secrets.example.yml setup.yml

# dirs
mkdir roles

# populate files
echo "# Your secrets go here" >secrets.yml
echo -e "[defaults]\ninventory = hosts" >ansible.cfg
echo -e "[main]\n" >hosts
echo -e "- hosts: main

  vars_files:
    - secrets.yml

  roles:" >setup.yml

echo "> Created basic project structure!"

# fetch role creator script
echo "Downloading role creator script..."

wget "$CREATE_ROLE_SCRIPT_URL" -O create_role.sh >/dev/null 2>&1
chmod +x create_role.sh

echo "> Downloaded role creator script!"

# ask if venv
read -rp "Create virtual environment? [y/N]: " response

response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

if [ "$response" = "y" ]; then
    PYTHON_BIN=$(which python3 || which python)

    if [ -z "$PYTHON_BIN" ]; then
        echo "No Python binary detected." >&2
        exit 1
    fi

    $PYTHON_BIN -m venv .venv >/dev/null 2>&1

    echo "> Created virtual environment with Python!"

    # activate
    source .venv/bin/activate

    pip install ansible >/dev/null 2>&1

    if pip show ansible >/dev/null 2>&1; then
        :
    else
        echo "Failed to install Ansible." >&2
        exit 1
    fi
fi

# ask if git
read -rp "Initialize git? [y/N]: " response

response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

if [ "$response" = "y" ]; then
    git init >/dev/null 2>&1

    echo ".venv" >.gitignore

    echo "> Git initialized!"
fi

echo -e "\nDO NOT FORGET to fill the hosts file!\nEach line should contain a hostname and should be accessible by simply doing 'ssh [host]'"
