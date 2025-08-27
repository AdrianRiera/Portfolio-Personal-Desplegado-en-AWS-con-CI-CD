# Portfolio-Personal-Desplegado-en-AWS-con-CI-CD

Este proyecto se basa en mi portfolio personal desplegado en AWS, con hosting seguro y automatización completa de despliegue mediante GitHub Actions.

## Arquitectura

La infraestructura de AWS utilizada incluye:

- **Amazon Route 53**: Registro del dominio `portfolio-adrianriera.com` y gestión de DNS.  
- **Amazon S3**: Almacenamiento de los archivos estáticos del portfolio, con políticas que restringen el acceso al público y que solo CloudFront puede servir el contenido.  
- **Amazon CloudFront**: CDN que distribuye el contenido globalmente, buscando baja latencia y alta disponibilidad.  
- **AWS Certificate Manager (ACM)**: Certificado TLS para habilitar HTTPS y asegurar la comunicación segura.  
- **AWS Shield Standard**: Aprovechando AWS Shield Standard que nos da una protección básica contra ataques DDoS ya que se integra automaticamente con Route 53.  

La arquitectura completa sigue este flujo:

Un detalle del portfolio, es que se detecta la Edge Location de CloudFront a la que está conectado el usuario. Como muestro en el ejemplo me conecto a través de una VPN a un servidor localizado en Paises Bajos. Cloudfront al detectarlo, me busca el Edge Location con menor latencia para distribuirme el contenido (En este caso ha sido una Edge Location en London):
(images/captura-edge-location.png)
(images/localizacion.png)


## Seguridad

- Cifrado TLS mediante ACM.  
- Acceso al bucket S3 restringido únicamente a CloudFront.  
- Política de menor privilegio para el usuario de despliegue de GitHub Actions (`gh-actions-portfolio`). Aquí es donde sacamos (`AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY`).

## Automatización con GitHub Actions

Cada push a la rama `main` dispara automáticamente el workflow de despliegue que:

1. Sincroniza los archivos del proyecto con el bucket S3 (`portfolio-adrian-prod`).  
2. Invalida la caché de la distribución CloudFront para asegurar que los usuarios reciban la versión más reciente.  
3. Usa secretos de GitHub (`AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY`) para autenticar con AWS de forma segura.

La política IAM asociada al usuario de despliegue permite únicamente:

- Operaciones `s3:PutObject` y `s3:DeleteObject` sobre el bucket específico.  
- Creación de invalidaciones en la distribución de CloudFront.

## Despliegue

El link para acceder al portfolio: [https://portfolio-adrianriera.com](https://portfolio-adrianriera.com)
