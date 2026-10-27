# VetAgenda

Sistema web para la gestión de horas y citas veterinarias, desarrollado como proyecto académico para demostrar la implementación de prácticas DevOps, integración continua, contenedores, infraestructura como código y despliegue continuo en la nube.

## 1. Descripción del proyecto

VetAgenda es una aplicación web orientada a la gestión de horas veterinarias.

El proyecto aplica un flujo DevOps que integra control de versiones, integración continua (CI), construcción y publicación de imágenes Docker, configuración de infraestructura como código (IaC) y despliegue continuo (CD).

### Usuarios principales

- Dueños de mascotas.
- Veterinarios.
- Administradores de la plataforma.

### Alcance actual

La versión desarrollada para la evaluación corresponde a una aplicación web básica que permite comprobar el funcionamiento del entorno DevOps y del proceso de despliegue.

Actualmente, la aplicación muestra un mensaje de funcionamiento y sirve como base para futuras funcionalidades de gestión de usuarios, mascotas y horas veterinarias.

## 2. Requisitos técnicos

| Elemento | Tecnología o configuración |
|---|---|
| Lenguaje | Python 3.12 |
| Framework | Flask |
| Pruebas automatizadas | Pytest |
| Análisis de código | Flake8 |
| Contenedores | Docker |
| Orquestación local | Docker Compose |
| Registro de imágenes | Docker Hub |
| Control de versiones | Git y GitHub |
| Integración y despliegue continuo | GitHub Actions |
| Proveedor Cloud | Render |
| Infraestructura como código | Render Blueprint (`render.yaml`) |
| Puerto de la aplicación | 5000 |

## 3. Arquitectura del proyecto

La arquitectura de VetAgenda integra el repositorio de GitHub con los workflows de GitHub Actions, la construcción de imágenes Docker, la publicación en Docker Hub y el despliegue en Render.

El flujo general es:

1. El código fuente se administra mediante Git y GitHub.
2. GitHub Actions ejecuta las validaciones de calidad y las pruebas automatizadas.
3. El pipeline construye la imagen Docker utilizando el `Dockerfile`.
4. Cuando corresponde, la imagen se publica en Docker Hub.
5. El workflow solicita el despliegue mediante el Deploy Hook de Render.
6. Render utiliza la imagen publicada para ejecutar la aplicación web.

Docker Compose complementa esta arquitectura al permitir definir la construcción y ejecución del servicio en un entorno de desarrollo local.

## 4. Control de versiones y estrategia de ramas

El proyecto utiliza Git y GitHub para administrar el código fuente, registrar los cambios y facilitar el trabajo mediante ramas independientes.

Se adopta una estrategia basada en GitHub Flow, adaptada al contexto académico del proyecto. La rama `main` representa la línea principal de desarrollo y los cambios se integran mediante Pull Requests.

### Ramas de trabajo

Entre las ramas utilizadas durante el desarrollo se encuentran:

- `main`: rama principal del proyecto.
- `feature/backend`: implementación inicial de la aplicación y configuración del backend.
- `feature/cloud-terraform`: trabajo relacionado con infraestructura y despliegue.
- `feature/cd-render`: implementación del despliegue continuo hacia Render.
- `feature/cd-v2`: trabajo relacionado con la segunda versión de la aplicación.

También se pueden utilizar ramas específicas para documentación, correcciones de workflows y nuevas configuraciones, según la tarea desarrollada.

### Convención de nombres

Para las funcionalidades se utiliza el prefijo `feature/`, seguido de una descripción breve de la tarea. Esta convención facilita identificar el propósito de cada rama.

### Pull Requests

Los cambios se envían mediante Pull Requests antes de integrarse en `main`. Este mecanismo permite revisar las modificaciones y comprobar los resultados de los workflows antes de fusionar los cambios.

La rama principal cuenta con reglas de protección y revisión configuradas para el proyecto.

## 5. Convención de commits

Los mensajes de commit se utilizan para identificar de forma clara el propósito de cada modificación.

Se recomienda utilizar mensajes breves que describan el cambio realizado, por ejemplo:

- `feat: actualiza version de VetAgenda`
- `docs: actualiza documentacion del proyecto`
- `fix: corrige configuracion del workflow`
- `test: agrega validacion de Docker Compose`

Estos ejemplos representan una convención recomendada para organizar los cambios. El historial real del repositorio debe revisarse para determinar en qué medida los commits existentes siguen esta estructura.

## 6. Integración continua (CI)

La integración continua se implementa mediante GitHub Actions. El workflow principal se encuentra en:

`.github/workflows/ci.yml`

El proceso incluye las siguientes etapas:

1. Descargar el código fuente.
2. Configurar Python 3.12.
3. Instalar las dependencias declaradas en `requirements.txt`.
4. Ejecutar Flake8 para revisar la calidad del código.
5. Ejecutar las pruebas automatizadas mediante Pytest.
6. Construir la imagen Docker.
7. Autenticarse en Docker Hub y publicar la imagen cuando se cumplen las condiciones del workflow.

Las validaciones de calidad y las pruebas automatizadas permiten detectar errores antes de integrar los cambios o publicar una nueva imagen.

Si falla una etapa que utiliza comandos con control de errores, como Flake8, Pytest o la construcción de Docker, el workflow puede finalizar con error y evitar que se ejecuten los pasos posteriores dependientes de ella.

## 7. Construcción y publicación de imágenes Docker

El archivo `Dockerfile` define cómo se construye la imagen de VetAgenda.

La imagen utiliza `python:3.12-slim` como base, establece el directorio de trabajo `/app`, instala las dependencias de Python, copia el código de la aplicación y expone el puerto 5000.

La aplicación se inicia mediante el comando configurado en el Dockerfile.

Las imágenes se publican en Docker Hub bajo el repositorio:

`docker.io/simonvf10/vetagenda`

### Etiquetas de las imágenes

El pipeline utiliza las etiquetas `latest` y el SHA del commit.

- `latest`: identifica la imagen publicada más recientemente con esa etiqueta.
- SHA del commit: permite identificar una imagen asociada a un cambio específico del repositorio.

El uso del SHA facilita la trazabilidad entre el código fuente y la imagen construida. La etiqueta `latest` es mutable y puede apuntar a una imagen diferente después de una nueva publicación.

## 8. Infraestructura como código (IaC)

La configuración del servicio de Render se declara en el archivo:

`render.yaml`

Este archivo permite versionar la configuración del servicio junto con el código fuente.

La configuración documentada para VetAgenda contempla:

- Tipo de servicio: Web.
- Nombre del servicio: `vetagenda`.
- Runtime: imagen Docker.
- Plan: Free.
- Región: Oregon.
- Imagen: `docker.io/simonvf10/vetagenda:latest`.

El archivo funciona como declaración de configuración de infraestructura para Render. El aprovisionamiento efectivo depende de que el servicio se cree o actualice mediante el mecanismo de Render correspondiente, como un Blueprint.

La configuración final debe mantener coherencia entre la imagen publicada, el servicio desplegado y la ruta de comprobación de salud, si esta se encuentra definida.

## 9. Despliegue en la nube

El proveedor Cloud utilizado es Render, que permite ejecutar la aplicación como un servicio web a partir de una imagen Docker.

La aplicación se publica mediante el servicio `vetagenda`, y Render proporciona una URL pública para acceder a ella.

La configuración del servicio se mantiene en `render.yaml`, mientras que la automatización del despliegue se integra con GitHub Actions y Docker Hub.

## 10. Despliegue continuo (CD)

El despliegue continuo se implementa mediante GitHub Actions y el Deploy Hook de Render.

El workflow principal contiene un paso que solicita el despliegue después de la construcción y publicación de la imagen, bajo las condiciones configuradas para la rama principal.

El flujo general es:

1. Se realiza un cambio en el repositorio.
2. GitHub Actions ejecuta las validaciones y las pruebas.
3. Se construye la imagen Docker.
4. Se publica la imagen en Docker Hub.
5. Si el evento cumple la condición configurada para `main`, se invoca el Deploy Hook de Render.
6. Render procesa el despliegue del servicio.

El workflow utiliza el secreto `RENDER_DEPLOY_HOOK` para realizar la solicitud. La respuesta del Deploy Hook confirma la recepción de la solicitud, mientras que el estado final del despliegue debe comprobarse en Render.

## 11. Gestión de secretos y seguridad

El proyecto utiliza GitHub Repository Secrets para proteger credenciales y datos sensibles requeridos por los workflows.

Entre los secretos configurados se encuentran:

- `DOCKERHUB_USERNAME`: nombre de usuario de Docker Hub.
- `DOCKERHUB_TOKEN`: token utilizado para autenticarse en Docker Hub.
- `RENDER_DEPLOY_HOOK`: dirección del Deploy Hook de Render.
- `RENDER_API_KEY`: credencial para autenticarse ante la API de Render cuando un workflow lo requiere.

Los workflows deben utilizar los secretos únicamente en los pasos que necesitan esas credenciales. Sus valores no deben incluirse directamente en el código fuente ni en la documentación.

La existencia de un secreto en GitHub no implica que todos los workflows lo utilicen; su uso efectivo depende de las referencias presentes en cada archivo de configuración.

## 12. Versiones sucesivas de la aplicación

Durante el desarrollo se trabajó con dos versiones sucesivas de VetAgenda para demostrar el flujo de publicación y despliegue.

### Versión 1

La aplicación mostraba el mensaje:

`VetAgenda funcionando correctamente`

### Versión 2

Se realizó un cambio controlado en el mensaje mostrado por la aplicación:

`VetAgenda funcionando correctamente - v2`

El cambio se incorporó al repositorio mediante el flujo de trabajo basado en ramas y Pull Requests.

La justificación técnica de esta prueba consiste en comprobar que una modificación en el código puede generar una nueva imagen Docker y activar el proceso de despliegue configurado.

Para demostrar el resultado deben conservarse evidencias del cambio en el código, de las imágenes o etiquetas publicadas y del despliegue correspondiente en Render. La confirmación de dos versiones sucesivas requiere respaldar ambos despliegues con evidencias verificables.

## 13. Estructura del repositorio

La estructura del proyecto organiza la aplicación, las pruebas automatizadas y los archivos de configuración DevOps.

```text
VetAgenda/
├── app/
│   ├── __init__.py
│   └── app.py
├── tests/
│   └── test_app.py
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── terraform.yml
│       └── compose-test.yml
├── docker/
├── terraform/
│   ├── main.tf
│   └── variables.tf
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── render.yaml
├── .gitignore
└── README.md
```

La estructura debe mantenerse sincronizada con los archivos realmente presentes en la rama principal del repositorio.

### Descripción de los componentes

- `app/`: contiene el código de la aplicación Flask.
- `tests/`: contiene las pruebas automatizadas.
- `.github/workflows/`: almacena los workflows de integración, infraestructura y validación de Docker Compose.
- `docker/`: directorio destinado a archivos relacionados con Docker, si corresponde a la configuración actual.
- `terraform/`: contiene archivos de infraestructura como código.
- `Dockerfile`: define la construcción de la imagen Docker.
- `docker-compose.yml`: define el servicio utilizado para ejecutar la aplicación mediante Docker Compose.
- `requirements.txt`: declara las dependencias de Python.
- `render.yaml`: contiene la configuración declarativa del servicio de Render.
- `.gitignore`: excluye archivos locales y generados que no deben incluirse en el control de versiones.
- `README.md`: documenta el proyecto y su arquitectura.

## 14. Orquestación con Docker Compose

Se incorporó el archivo `docker-compose.yml` para facilitar la construcción y ejecución del servicio VetAgenda mediante Docker Compose.

La configuración utiliza el `Dockerfile` existente, define el servicio `vetagenda` y establece la correspondencia entre el puerto 5000 del contenedor y el puerto 5000 del entorno anfitrión.

Además, se incorporó el workflow `Docker Compose Test` en GitHub Actions. Este workflow valida la configuración, construye la imagen e intenta iniciar el servicio en un entorno de ejecución automatizado.

Esta integración permite comprobar la configuración de Docker Compose sin requerir una instalación local de Docker en el equipo del desarrollador. El resultado del workflow debe conservarse como evidencia de la validación automatizada.

## 15. Resultados obtenidos

Durante el desarrollo de VetAgenda se trabajó en los siguientes aspectos:

- Control de versiones mediante Git y GitHub.
- Organización del trabajo mediante ramas y Pull Requests.
- Integración continua mediante GitHub Actions.
- Análisis de código mediante Flake8.
- Pruebas automatizadas mediante Pytest.
- Construcción de imágenes Docker.
- Publicación de imágenes en Docker Hub.
- Configuración declarativa del servicio de Render.
- Despliegue automatizado mediante el Deploy Hook.
- Gestión de credenciales mediante GitHub Repository Secrets.
- Incorporación de Docker Compose y validación automatizada de su configuración.

Los resultados deben acompañarse con evidencias del repositorio, los workflows, Docker Hub y Render, según corresponda a cada actividad.

## 16. Conclusiones

El proyecto VetAgenda permitió aplicar prácticas DevOps a una aplicación web desarrollada con Python y Flask, integrando control de versiones, validaciones automatizadas, contenerización, publicación de imágenes e implementación del despliegue en la nube.

GitHub Actions permite automatizar etapas del proceso y detectar errores durante las validaciones. Docker facilita empaquetar la aplicación y sus dependencias, mientras que Docker Hub proporciona un registro para almacenar las imágenes construidas.

La configuración declarativa de Render permite mantener la definición del servicio versionada. Por su parte, Docker Compose facilita definir y validar la ejecución del servicio en un entorno automatizado.

En conjunto, estas herramientas contribuyen a mejorar la trazabilidad de los cambios, la reproducibilidad del entorno y la automatización del proceso de entrega de VetAgenda. La verificación de cada despliegue y de las versiones publicadas debe respaldarse mediante las evidencias correspondientes.
