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
```