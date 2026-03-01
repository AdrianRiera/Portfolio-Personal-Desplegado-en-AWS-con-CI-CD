# Terraform Infrastructure - Portfolio Adrian Riera

Infrastructure as code for the personal portfolio using AWS.

## 📁 Project Structure

```
Terraform/
├── core/                           # Core infrastructure (DNS)
│   ├── route53_zone.tf            # Route53 zone and DNS records
│   ├── providers.tf               # Provider configuration
│   ├── variables.tf               # Module variables
│   ├── terraform.tfvars           # Variable values
│   ├── outputs.tf                 # Module outputs
│   └── README.md                  # Module documentation
│
└── portfolio-frontend/            # Portfolio frontend
    ├── s3.tf                      # S3 Bucket
    ├── cloudfront.tf              # CloudFront Distribution
    ├── providers.tf               # Provider configuration
    ├── variables.tf               # Module variables
    ├── terraform.tfvars           # Variable values
    ├── outputs.tf                 # Module outputs
    └── README.md                  # Module documentation
```

## 🏗️ Architecture

### Core Infrastructure
- **Route53**: DNS management
  - Main domain: `portfolio-adrianriera.com`
  - WWW subdomain: `www.portfolio-adrianriera.com`
  - ACM certificate validation

### Portfolio Frontend
- **S3**: Static file storage
- **CloudFront**: Global CDN with HTTPS
- **OAC**: Bucket-to-CloudFront security

```
User → Route53 → CloudFront → S3 Bucket
       (DNS)     (CDN/SSL)    (Storage)
```

## 🚀 Getting Started

### Prerequisites

- Configured AWS CLI
- Terraform >= 1.0
- AWS credentials with necessary permissions

### Installation

1. **Clone or navigate to the repository**
   ```bash
   git clone <your-repository-url>
   cd Terraform
   ```

2. **Deploy Core Infrastructure (Route53)**
   ```bash
   cd core
   terraform init
   terraform plan
   terraform apply
   ```

3. **Deploy Portfolio Frontend (S3 + CloudFront)**
   ```bash
   cd ../portfolio-frontend
   terraform init
   terraform plan
   terraform apply
   ```

## 📋 Modules

### 1. Core (Route53)

Manages DNS and required records.

**Resources:**
- Route53 Hosted Zone
- A record for main domain → CloudFront
- A record for www → CloudFront
- CNAME record for ACM validation

See [core/README.md](core/README.md) for more details.

### 2. Portfolio Frontend (S3 + CloudFront)

Infrastructure to serve the static website.

**Resources:**
- S3 Bucket (private, encrypted)
- CloudFront Distribution (global CDN)
- Origin Access Control (OAC)
- Security policies

See [portfolio-frontend/README.md](portfolio-frontend/README.md) for more details.

## 🔧 Configuration

### Main Variables

#### Core (Route53)
```hcl
domain_name            = "portfolio-adrianriera.com"
cloudfront_domain_name = "dx7ht7zr0hi5k.cloudfront.net."
www_subdomain          = "www"
create_www_record      = true
```

#### Portfolio Frontend
```hcl
bucket_name        = "portfolio-adrian-prod"
domain_aliases     = ["portfolio-adrianriera.com", "www.portfolio-adrianriera.com"]
acm_certificate_arn = "arn:aws:acm:us-east-1:..."
```

## 📦 Content Deployment

After creating the infrastructure, deploy your site:

```bash
# Upload files
aws s3 sync ./dist s3://portfolio-adrian-prod --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation \
  --distribution-id EA81JWYSFP9LI \
  --paths "/*"
```

## 🔒 Security

- ✅ Private S3 bucket (not public)
- ✅ Access only via CloudFront (OAC)
- ✅ Forced HTTPS
- ✅ Minimum TLS 1.2+
- ✅ AES256 encryption in S3
- ✅ Restrictive IAM policies

## 🌐 Domains

- **Main**: https://portfolio-adrianriera.com
- **WWW**: https://www.portfolio-adrianriera.com

Both point to the same CloudFront distribution.

## 📊 Outputs

Each module provides useful outputs:

```bash
# View core outputs
cd core && terraform output

# View frontend outputs
cd portfolio-frontend && terraform output
```

## 🛠️ Maintenance

### Update infrastructure

```bash
# In the corresponding module
terraform plan
terraform apply
```

### Delete resources

```bash
# ⚠️ WARNING: This will delete all resources
terraform destroy
```

### View current state

```bash
terraform show
terraform state list
```

## 📝 Implemented Best Practices

1. **Modularization**: Separation of core vs applications
2. **Variables**: Everything parameterized
3. **Outputs**: Useful information exposed
4. **Documentation**: README in each module
5. **Security**: Principle of least privilege
6. **Versioning**: State control (terraform.tfstate)
7. **Sensible defaults**: Variables with default values
8. **Comments**: Well-documented code
9. **Conditional resources**: Optional resources (www)
10. **AWS Best Practices**: OAC, ALIAS records, cache policies

## 🐛 Troubleshooting

### Error: Resource already exists
Si los recursos ya existen en AWS:
```bash
terraform import <resource_type>.<name> <aws_id>
```

### CloudFront tarda en actualizar
Las actualizaciones de CloudFront pueden tardar 15-20 minutos.

### Certificado SSL no válido
- Verificar que el certificado esté en **us-east-1** (requerido por CloudFront)
- Verificar que los dominios en el certificado coincidan con los aliases

### DNS no resuelve
- Verificar que los Name Servers de Route53 estén configurados en el registrador
- Esperar propagación DNS (hasta 48h, típicamente <1h)

## 📞 Soporte

Para más información sobre Terraform AWS:
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [AWS Route53 Documentation](https://docs.aws.amazon.com/route53/)

---

**Última actualización**: Marzo 2026  
**Autor**: Adrian Riera  
**Región Principal**: eu-south-2 (Europa - España)
