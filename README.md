# Ansible template

A setup script to generate my favorite Ansible template.

**Dependencies:** Bash, Python, Git

The following command will generate a new project directory based on the template:

```bash
bash <(curl -s https://raw.githubusercontent.com/davnpsh/ansible-template/main/setup.sh)
```

Once that is done, execute this inside the project directory to create new roles:

```bash
bash create_role.sh
```

To execute the playbook, enable the virtual environment:

```bash
source .venv/bin/activate # Or .venv/bin/activate.fish, in case of fish
```

And run with:

```bash
ansible-playbook --ask-become-pass setup.yml
```