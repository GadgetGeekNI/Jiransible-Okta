FROM python:slim

# Build Arguments
ARG ANSIBLE_USER=admin
ARG ANSIBLE_PATH=/opt/ansible

COPY requirements.txt requirements.txt

RUN echo "==> Installing Pip packages..."  && \
    pip install -r requirements.txt && \
    \
    echo "==> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible /ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts 

# Jira API token taken from environment variable
ENV JIRA_API_TOKEN ${JIRA_API_TOKEN}
# Okta API token taken from environment variable
ENV OKTA_API_TOKEN ${OKTA_API_TOKEN}
# Slack APi token taken from environment variable
ENV SLACK_API_TOKEN ${SLACK_API_TOKEN}

# Ansible configs
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH ${ANSIBLE_PATH}/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_SSH_USER ${ANSIBLE_USER}
ENV ANSIBLE_REMOTE_USER ${ANSIBLE_USER}
ENV ANSIBLE_INVENTORY ${ANSIBLE_PATH}/inventory/jira.yml
ENV ANSIBLE_PYTHON_INTERPRETER /usr/local/bin/python

# Change to our working directory
WORKDIR ${ANSIBLE_PATH}

# Look at .dockerignore for files that don't get copied
COPY . .

ENTRYPOINT ["ansible-playbook", "isum_main.yml"]
