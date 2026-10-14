# EC2 Public IP Toggle Demo

## Objective

Demonstrate:

1. Create EC2 with Private IP only
2. Add Public IP later
3. Remove Public IP later
4. EC2 Instance ID never changes

---

# Step 0 - Verify Terraform Files

```bash
ls
```

Expected:

```text
data.tf
eip.tf
main.tf
outputs.tf
providers.tf
security-group.tf
terraform.tfvars
variables.tf
```

---

# Step 1 - Deploy Private EC2

Open:

```bash
vi terraform.tfvars
```

Ensure:

```hcl
enable_public_ip = false
```

Deploy:

```bash
terraform init

terraform apply
```

Type:

```text
yes
```

---

# Step 2 - Save Instance ID

```bash
export INSTANCE_ID=$(terraform output -raw instance_id)

echo $INSTANCE_ID
```

Example:

```text
i-0123456789abcdef0
```

---

# Step 3 - Verify Private Only

```bash
aws ec2 describe-instances \
--instance-ids $INSTANCE_ID \
--query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,PublicIpAddress]' \
--output table
```

Expected:

```text
----------------------------------------------------
| i-0123456789abcdef0 | 10.0.1.15 | None          |
----------------------------------------------------
```

Screenshot #1

---

# Step 4 - Enable Public IP

Edit:

```bash
vi terraform.tfvars
```

Change:

```hcl
enable_public_ip = false
```

To:

```hcl
enable_public_ip = true
```

---

# Step 5 - Review Terraform Plan

```bash
terraform plan
```

Expected:

```text
+ aws_eip.demo
+ aws_eip_association.demo
```

Make sure you DO NOT see:

```text
aws_instance.demo must be replaced
```

---

# Step 6 - Apply

```bash
terraform apply
```

Type:

```text
yes
```

---

# Step 7 - Verify Public IP Added

```bash
echo $INSTANCE_ID
```

Should still be:

```text
i-0123456789abcdef0
```

Check instance:

```bash
aws ec2 describe-instances \
--instance-ids $INSTANCE_ID \
--query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,PublicIpAddress]' \
--output table
```

Expected:

```text
---------------------------------------------------------
| i-0123456789abcdef0 | 10.0.1.15 | 54.xxx.xxx.xxx      |
---------------------------------------------------------
```

Screenshot #2

Key point:

```text
Same Instance ID
Public IP Added
```

---

# Step 8 - Disable Public IP

Edit:

```bash
vi terraform.tfvars
```

Change:

```hcl
enable_public_ip = true
```

To:

```hcl
enable_public_ip = false
```

---

# Step 9 - Review Terraform Plan

```bash
terraform plan
```

Expected:

```text
- aws_eip_association.demo
- aws_eip.demo
```

Make sure you DO NOT see:

```text
aws_instance.demo must be replaced
```

---

# Step 10 - Apply

```bash
terraform apply
```

Type:

```text
yes
```

---

# Step 11 - Verify Public IP Removed

```bash
echo $INSTANCE_ID
```

Expected:

```text
i-0123456789abcdef0
```

Verify:

```bash
aws ec2 describe-instances \
--instance-ids $INSTANCE_ID \
--query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,PublicIpAddress]' \
--output table
```

Expected:

```text
----------------------------------------------------
| i-0123456789abcdef0 | 10.0.1.15 | None          |
----------------------------------------------------
```

Screenshot #3

Key point:

```text
Same Instance ID
Public IP Removed
```

---

# Demo Success

| Step | Instance ID | Public IP |
|--------|--------|--------|
| Initial | Same | No |
| Enable | Same | Yes |
| Disable | Same | No |

Success criteria:

```text
EC2 Instance ID never changes.
```

Terraform only creates/removes:

- Elastic IP
- Elastic IP Association

Terraform never recreates:

```text
aws_instance.demo
```


This version is optimized for actually standing in front of an audience and typing commands rather than reading Terraform explanations.
