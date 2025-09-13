steps:
  # Step 1: Terraform Init (with upgrade)
  - id: terraform-init
    name: hashicorp/terraform:1.6.0
    entrypoint: sh
    args:
      - -c
      - |
        set -eu
        cd modules/jallybean_compliance
        terraform init -upgrade -input=false -no-color

  # Step 2: Terraform Plan (inject project_id and persist tfplan.json)
  - id: terraform-plan
    name: hashicorp/terraform:1.6.0
    entrypoint: sh
    env:
      - PROJECT_ID=ivory-mountain-470414-k1
    args:
      - -c
      - |
        set -eu
        cd modules/jallybean_compliance
        terraform plan -out=tfplan -var="project_id=$PROJECT_ID"
        terraform show -json tfplan > tfplan.json || (echo "Failed to generate tfplan.json" && exit 1)
        cp tfplan.json ../../tfplan.json

  # Step 3: YAML/CEL policy enforcement
  - id: conftest-yaml
    name: openpolicyagent/conftest:latest
    entrypoint: sh
    args:
      - -c
      - |
        echo "Running CEL/YAML policy tests..."
        conftest test -p policy/yaml ./workflows || exit 1
