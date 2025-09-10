FROM hashicorp/terraform:1.6.0

# Install required packages: bash, curl, git, python3/pip
RUN apk add --no-cache bash curl git python3 py3-pip

# Install yamllint for YAML compliance checks
RUN pip install yamllint

# Copy in compliance scripts from your repo into the image
COPY scripts/ /usr/local/bin/jverse-scripts/
RUN chmod +x /usr/local/bin/jverse-scripts/*.sh

# Set working directory (Cloud Build will override dir: but good default)
WORKDIR /workspace

# Default entrypoint: terraform
ENTRYPOINT ["terraform"]
