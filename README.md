# Managing edge k3s devices with Azure Arc
Connect k3s clusters in order to:
- Manage deployed applications with GitOps
- Monitor cluster, workloads and containers
- Gather logs and telemetry
- Set security policy

# Simulate devices using Azure VMs

```bash
cd infra

# Use Service Principal with permissions to onboard to Arc
# export TF_VAR_client_id=<identityUsedToEnrollToArc>
# export TF_VAR_client_secret=<identitySecretUsedToEnrollToArc>
# export TF_VAR_tenant_id=<tenantId>

. .secrets

terraform apply -auto-approve
```

# Onboard devices for GitOps

```bash
az extension add --name k8sconfiguration --upgrade
# Onboard to common state
az k8sconfiguration create -g edge-rg \
    --cluster-name k3s-0 \
    --cluster-type connectedClusters \
    --name common \
    --operator-instance-name common  \
    --operator-namespace default \
    --operator-type flux \
    --operator-params "'--git-readonly --git-path gitops/common'" \
    --repository-url https://github.com/tkubica12/edge-k3s-arc \
    --enable-helm-operator  \
    --helm-operator-version 1.2.0 \
    --scope namespace \
    --helm-operator-params '--set helm.versions=v3'
az k8sconfiguration create -g edge-rg \
    --cluster-name k3s-1 \
    --cluster-type connectedClusters \
    --name common \
    --operator-instance-name common  \
    --operator-namespace default \
    --operator-type flux \
    --operator-params "'--git-readonly --git-path gitops/common'" \
    --repository-url https://github.com/tkubica12/edge-k3s-arc \
    --enable-helm-operator  \
    --helm-operator-version 1.2.0 \
    --scope namespace \
    --helm-operator-params '--set helm.versions=v3'
az k8sconfiguration create -g edge-rg \
    --cluster-name k3s-2 \
    --cluster-type connectedClusters \
    --name common \
    --operator-instance-name common  \
    --operator-namespace default \
    --operator-type flux \
    --operator-params "'--git-readonly --git-path gitops/common'" \
    --repository-url https://github.com/tkubica12/edge-k3s-arc \
    --enable-helm-operator  \
    --helm-operator-version 1.2.0 \
    --scope namespace \
    --helm-operator-params '--set helm.versions=v3'
az k8sconfiguration create -g edge-rg \
    --cluster-name k3s-3 \
    --cluster-type connectedClusters \
    --name common \
    --operator-instance-name common  \
    --operator-namespace default \
    --operator-type flux \
    --operator-params "'--git-readonly --git-path gitops/common'" \
    --repository-url https://github.com/tkubica12/edge-k3s-arc \
    --enable-helm-operator  \
    --helm-operator-version 1.2.0 \
    --scope namespace \
    --helm-operator-params '--set helm.versions=v3'
az k8sconfiguration create -g edge-rg \
    --cluster-name k3s-4 \
    --cluster-type connectedClusters \
    --name common \
    --operator-instance-name common  \
    --operator-namespace default \
    --operator-type flux \
    --operator-params "'--git-readonly --git-path gitops/common'" \
    --repository-url https://github.com/tkubica12/edge-k3s-arc \
    --enable-helm-operator  \
    --helm-operator-version 1.2.0 \
    --scope namespace \
    --helm-operator-params '--set helm.versions=v3'


# Onboard to device-specific state
```

# Destroy

```bash
terraform destroy -auto-approve
```