# Infraestructura AWS - VetAgenda

## 1. Descripción del proyecto

Este directorio contiene la configuración de infraestructura como código (IaC) para el proyecto VetAgenda, utilizando Terraform y servicios de Amazon Web Services (AWS).

El objetivo es preparar una infraestructura que permita implementar medidas de seguridad, monitoreo, registro de eventos y validaciones automatizadas, facilitando la administración y el mantenimiento de los recursos en la nube.

## 2. Tecnologías utilizadas

- **Terraform:** herramienta para definir y administrar infraestructura como código.
- **Amazon EC2:** servicio de cómputo para alojar la infraestructura de VetAgenda.
- **AWS IAM:** administración de roles y permisos.
- **Amazon CloudWatch:** monitoreo de métricas y almacenamiento de registros.
- **AWS CloudTrail:** auditoría de eventos y actividades de la cuenta AWS.
- **Amazon S3:** almacenamiento de registros de auditoría.
- **GitHub Actions:** automatización de validaciones y pruebas.

## 3. Estructura de archivos

| **Archivo** | **Descripción** |
|---|---|
| `main.tf` | Define la versión requerida de Terraform y el proveedor AWS. |
| `provider.tf` | Configura el proveedor AWS, la región y las etiquetas predeterminadas. |
| `variables.tf` | Define las variables del proyecto, región y entorno. |
| `outputs.tf` | Expone información general de la configuración. |
| `compute.tf` | Define la instancia EC2, su almacenamiento y la instalación del agente de CloudWatch. |
| `security.tf` | Define el rol IAM, sus permisos y el perfil asociado a EC2. |
| `monitoring.tf` | Configura el grupo de registros y una alarma de uso de CPU en CloudWatch. |
| `cloudtrail.tf` | Configura el almacenamiento privado en S3 y la auditoría mediante CloudTrail. |
| `tests.tf` | Incorpora validaciones de los parámetros de configuración. |
| `infrastructure.tftest.hcl` | Contiene las pruebas automatizadas de Terraform mediante un proveedor AWS simulado. |

## 4. Seguridad

Se implementa un rol IAM destinado a la instancia EC2 de VetAgenda.

Este rol contempla permisos limitados para enviar registros a CloudWatch, consultar flujos de registros y publicar métricas personalizadas, aplicando el principio de mínimo privilegio.

Además, se configura un bucket S3 con bloqueo de acceso público y cifrado AES-256 para almacenar los registros de auditoría de CloudTrail.

La instancia EC2 también utiliza un volumen de almacenamiento cifrado para proteger la información almacenada.

## 5. Monitoreo y auditoría

Se utiliza Amazon CloudWatch para:

- Crear un grupo de registros para VetAgenda.
- Establecer una retención de registros de 7 días.
- Instalar y configurar CloudWatch Agent en la instancia EC2.
- Recopilar registros del sistema.
- Monitorear métricas de memoria y uso de disco.
- Configurar una alarma que detecte un uso promedio de CPU superior al 80%, durante dos períodos de evaluación de cinco minutos.

Por otro lado, AWS CloudTrail permite registrar eventos de administración de lectura y escritura, incluyendo eventos globales y actividades en múltiples regiones.

También se habilita la validación de integridad de los archivos de registro para facilitar la auditoría y trazabilidad de las operaciones realizadas en AWS.

## 6. Automatización y pruebas

Se utiliza GitHub Actions para ejecutar automáticamente las siguientes validaciones cuando se realizan cambios en los archivos de infraestructura:

1. Descarga del repositorio.
2. Configuración de Terraform.
3. Verificación del formato mediante `terraform fmt`.
4. Inicialización mediante `terraform init`.
5. Validación mediante `terraform validate`.
6. Ejecución de pruebas automatizadas mediante `terraform test`.

Las pruebas utilizan un proveedor AWS simulado (*mock provider*), por lo que permiten comprobar diferentes aspectos de la configuración sin necesitar una conexión real con AWS.

Entre las validaciones realizadas se encuentran:

- Nombre del proyecto, región y entorno.
- Tipo y almacenamiento de la instancia EC2.
- Cifrado del volumen.
- Retención de registros en CloudWatch.
- Umbral de la alarma de CPU.
- Configuración de CloudTrail.
- Asociación del rol IAM con el perfil de instancia.

## 7. Estado actual del proyecto

La configuración de Terraform y las pruebas automatizadas se encuentran preparadas y validadas mediante GitHub Actions.

Los flujos de trabajo de integración continua permiten comprobar el formato, la validez y el funcionamiento esperado de la configuración antes de integrar los cambios al proyecto principal.

**Pendiente:**

- Conectar el proyecto con AWS Academy.
- Revisar el plan de ejecución de Terraform.
- Desplegar los recursos mediante Terraform, una vez revisados los costos y permisos.
- Verificar el funcionamiento de IAM, CloudWatch y CloudTrail.
- Comprobar la recopilación de métricas y registros de la instancia EC2.

**Importante:** hasta completar el despliegue, los recursos descritos corresponden a configuraciones definidas y validadas mediante Terraform. Las pruebas automatizadas utilizan recursos simulados y no demuestran por sí solas que los servicios estén funcionando en una cuenta AWS real.
