# Terraform Infrastructure - Portfolio Adrian Riera

Infraestructura como código para el portfolio personal usando AWS.

## 📁 Estructura del Proyecto

```
Terraform/
├── core/                           # Infraestructura core (DNS)
│   ├── route53_zone.tf            # Zona Route53 y registros DNS
│   ├── providers.tf               # Configuración de providers
│   ├── variables.tf               # Variables del módulo
│   ├── terraform.tfvars           # Valores de las variables
│   ├── outputs.tf                 # Outputs del módulo
│   └── README.md                  # Documentación del módulo
│
└── aplicaciones/
    └── portfolio-frontend/        # Frontend del portfolio
        ├── s3.tf                  # Bucket S3
        ├── cloudfront.tf          # Distribución CloudFront
        ├── providers.tf           # Configuración de providers
        ├── variables.tf           # Variables del módulo
        ├── terraform.tfvars       # Valores de las variables
        ├── outputs.tf             # Outputs del módulo
        └── README.md              # Documentación del módulo
```

## 🏗️ Arquitectura

### Core Infrastructure
- **Route53**: Gestión de DNS
  - Dominio principal: `portfolio-adrianriera.com`
  - Subdominio www: `www.portfolio-adrianriera.com`
  - Validación de certificado ACM

### Portfolio Frontend
- **S3**: Almacenamiento de archivos estáticos
- **CloudFront**: CDN global con HTTPS
- **OAC**: Seguridad bucket-to-CloudFront

```
Usuario → Route53 → CloudFront → S3 Bucket
         (DNS)      (CDN/SSL)    (Storage)
```

## 🚀 Getting Started

### Prerequisitos

- AWS CLI configurado
- Terraform >= 1.0
- Credenciales AWS con permisos necesarios

### Instalación

1. **Clonar o navegar al repositorio**
   ```bash
   cd c:\Users\reala\Desktop\wallet\Terraform
   ```

2. **Desplegar Core Infrastructure (Route53)**
   ```bash
   cd core
   terraform init
   terraform plan
   terraform apply
   ```

3. **Desplegar Portfolio Frontend (S3 + CloudFront)**
   ```bash
   cd ../aplicaciones/portfolio-frontend
   terraform init
   terraform plan
   terraform apply
   ```

## 📋 Módulos

### 1. Core (Route53)

Gestiona el DNS y los registros necesarios.

**Recursos:**
- Hosted Zone Route53
- Registro A para dominio principal → CloudFront
- Registro A para www → CloudFront
- Registro CNAME para validación ACM

Ver [core/README.md](core/README.md) para más detalles.

### 2. Portfolio Frontend (S3 + CloudFront)

Infraestructura para servir el sitio web estático.

**Recursos:**
- S3 Bucket (privado, encriptado)
- CloudFront Distribution (CDN global)
- Origin Access Control (OAC)
- Políticas de seguridad

Ver [aplicaciones/portfolio-frontend/README.md](aplicaciones/portfolio-frontend/README.md) para más detalles.

## 🔧 Configuración

### Variables Principales

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

## 📦 Despliegue de Contenido

Después de crear la infraestructura, despliega tu sitio:

```bash
# Subir archivos
aws s3 sync ./dist s3://portfolio-adrian-prod --delete

# Invalidar caché CloudFront
aws cloudfront create-invalidation \
  --distribution-id EA81JWYSFP9LI \
  --paths "/*"
```

## 🔒 Seguridad

- ✅ Bucket S3 privado (no público)
- ✅ Acceso solo vía CloudFront (OAC)
- ✅ HTTPS forzado
- ✅ TLS 1.2+ mínimo
- ✅ Encriptación AES256 en S3
- ✅ Políticas IAM restrictivas

## 🌐 Dominios

- **Principal**: https://portfolio-adrianriera.com
- **WWW**: https://www.portfolio-adrianriera.com

Ambos apuntan a la misma distribución CloudFront.

## 📊 Outputs

Cada módulo proporciona outputs útiles:

```bash
# Ver outputs del core
cd core && terraform output

# Ver outputs del frontend
cd aplicaciones/portfolio-frontend && terraform output
```

## 🛠️ Mantenimiento

### Actualizar infraestructura

```bash
# En el módulo correspondiente
terraform plan
terraform apply
```

### Eliminar recursos

```bash
# ⚠️ CUIDADO: Esto eliminará todos los recursos
terraform destroy
```

### Ver estado actual

```bash
terraform show
terraform state list
```

## 📝 Buenas Prácticas Implementadas

1. **Modularización**: Separación core vs aplicaciones
2. **Variables**: Todo parametrizado
3. **Outputs**: Información útil expuesta
4. **Documentación**: README en cada módulo
5. **Seguridad**: Principio de menor privilegio
6. **Versionado**: Control de estado (terraform.tfstate)
7. **Defaults sensatos**: Variables con valores por defecto
8. **Comentarios**: Código bien documentado
9. **Conditional resources**: Recursos opcionales (www)
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
