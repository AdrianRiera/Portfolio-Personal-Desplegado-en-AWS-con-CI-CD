# Portfolio Frontend Infrastructure

Este módulo gestiona la infraestructura para el portfolio frontend usando S3 y CloudFront.

## Recursos Creados

- **S3 Bucket**: Almacenamiento para archivos estáticos
- **S3 Bucket Encryption**: Encriptación AES256
- **S3 Bucket Policy**: Permite acceso solo desde CloudFront
- **CloudFront OAC**: Origin Access Control para seguridad
- **CloudFront Distribution**: CDN para distribución global

## Variables

| Variable | Descripción | Tipo | Default | Requerido |
|----------|-------------|------|---------|-----------|
| bucket_name | Nombre del bucket S3 | string | - | Sí |
| cloudfront_distribution_id | ID de la distribución CloudFront | string | - | Sí |
| acm_certificate_arn | ARN del certificado SSL | string | - | Sí |
| oac_name | Nombre del Origin Access Control | string | - | Sí |
| domain_aliases | Lista de dominios personalizados | list(string) | - | Sí |
| origin_id | Origin ID de CloudFront | string | - | Sí |
| cache_policy_id | ID de la política de caché | string | CachingOptimized | No |
| price_class | Clase de precio CloudFront | string | PriceClass_All | No |
| default_root_object | Objeto raíz por defecto | string | index.html | No |
| distribution_comment | Comentario de la distribución | string | - | Sí |
| minimum_protocol_version | Versión mínima TLS | string | TLSv1.2_2021 | No |
| cloudfront_tag_name | Tag Name para CloudFront | string | - | Sí |

## Outputs

- `s3_bucket_name`: Nombre del bucket S3
- `s3_bucket_arn`: ARN del bucket S3
- `cloudfront_distribution_id`: ID de CloudFront
- `cloudfront_distribution_arn`: ARN de CloudFront
- `cloudfront_domain_name`: Domain name de CloudFront
- `cloudfront_status`: Estado de la distribución
- `cloudfront_aliases`: Aliases configurados
- `infrastructure_summary`: Resumen completo

## Uso

1. Configurar variables en `terraform.tfvars`
2. Inicializar Terraform:
   ```bash
   terraform init
   ```
3. Revisar los cambios:
   ```bash
   terraform plan
   ```
4. Aplicar los cambios:
   ```bash
   terraform apply
   ```

## Despliegue de Archivos

Después de crear la infraestructura, puedes subir archivos al bucket:

```bash
aws s3 sync ./dist s3://portfolio-adrian-prod --delete
```

Luego invalida el caché de CloudFront:

```bash
aws cloudfront create-invalidation --distribution-id EA81JWYSFP9LI --paths "/*"
```

## Buenas Prácticas Implementadas

- ✅ Origin Access Control (OAC) en lugar de OAI (legacy)
- ✅ HTTPS forzado (redirect-to-https)
- ✅ Compresión habilitada
- ✅ Encriptación S3 en reposo
- ✅ Política S3 restrictiva (solo CloudFront)
- ✅ Certificado SSL/TLS personalizado
- ✅ HTTP/2 habilitado
- ✅ Variables parametrizadas
- ✅ Cache Policy de AWS (optimizada)
- ✅ Outputs informativos

## Seguridad

- El bucket S3 NO es público
- Solo CloudFront puede acceder al bucket (usando OAC)
- Tráfico HTTPS forzado
- TLS 1.2+ mínimo
- Encriptación AES256 en S3

## Notas Importantes

- El OAC name y origin_id deben coincidir con los valores en AWS si importas recursos existentes
- La Cache Policy ID `658327ea-f89d-4fab-a63d-7e88639e58f6` es la política "CachingOptimized" de AWS
- Los aliases deben estar configurados también en Route53
- El certificado ACM debe estar en us-east-1 (requerido por CloudFront)
