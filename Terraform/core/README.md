# Core Infrastructure - Route53

Este módulo gestiona la infraestructura core de DNS usando AWS Route53.

## Recursos Creados

- **Route53 Hosted Zone**: Zona alojada para el dominio principal
- **Registro A (dominio principal)**: Apunta a CloudFront usando alias
- **Registro A (subdominio www)**: Apunta a CloudFront usando alias
- **Registro CNAME**: Para validación del certificado ACM

## Variables

| Variable | Descripción | Tipo | Default | Requerido |
|----------|-------------|------|---------|-----------|
| domain_name | Dominio principal | string | - | Sí |
| zone_comment | Comentario para la zona | string | - | Sí |
| cloudfront_domain_name | Domain name de CloudFront | string | - | Sí |
| evaluate_target_health | Evaluar salud del destino | bool | false | No |
| acm_validation_prefix | Prefijo de validación ACM | string | - | Sí |
| acm_validation_target | Target de validación ACM | string | - | Sí |
| www_subdomain | Nombre del subdominio www | string | "www" | No |
| create_www_record | Crear registro www | bool | true | No |

## Outputs

- `route53_zone_id`: ID de la zona Route53
- `route53_zone_name_servers`: Name servers de la zona
- `main_domain_fqdn`: FQDN del dominio principal
- `www_domain_fqdn`: FQDN del subdominio www
- `dns_records_summary`: Resumen de registros DNS

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

## Buenas Prácticas Implementadas

- ✅ Uso de variables para flexibilidad
- ✅ Valores por defecto sensatos
- ✅ Registros ALIAS en lugar de CNAME para dominios raíz
- ✅ Conditional resource creation (www)
- ✅ Outputs descriptivos
- ✅ Comentarios claros en el código
- ✅ Zone ID de CloudFront hardcoded (es global y no cambia)

## Notas

- El Zone ID `Z2FDTNDATAQYW2` es el ID global de CloudFront y nunca cambia
- Los registros A usan ALIAS para mejor rendimiento y sin costo
- El subdominio www es opcional y se puede desactivar con `create_www_record = false`
