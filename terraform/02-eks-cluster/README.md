# Commands

```bash
export AWS_PROFILE=workshop

export TF_VAR_aws_account_number=<ACCOUNT_NUMBER>
```

```bash
terraform init -backend-config=backend.conf
```

```bash
aws eks update-kubeconfig --region us-east-1 --name workshop-eks-cluster

kubectl config current-context
kubectl get nodes
```
