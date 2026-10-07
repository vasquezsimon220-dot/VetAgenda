#  VetAgenda

Sistema web para la gestión de horas y citas veterinarias, desarrollado como proyecto académico para demostrar la implementación de prácticas DevOps, integración continua, contenedores, infraestructura como código y despliegue continuo en la nube.

---

## 1. Descripción del proyecto

VetAgenda es una aplicación web orientada a la gestión de horas veterinarias.

El proyecto fue desarrollado para aplicar un flujo DevOps completo, incorporando control de versiones, integración continua (CI), construcción y publicación de imágenes Docker, infraestructura como código (IaC) y despliegue continuo (CD).

### Usuarios principales

* Dueños de mascotas.
* Veterinarios.
* Administradores de la plataforma.

### Alcance actual

La versión desarrollada para la evaluación implementa una aplicación web básica que permite validar el funcionamiento del entorno DevOps y del proceso de despliegue.

La aplicación actualmente muestra el estado de funcionamiento de VetAgenda y sirve como base para futuras funcionalidades de gestión de usuarios, mascotas y horas veterinarias.

---

# 2. Requisitos técnicos

| Elemento             | Tecnología                       |
| -------------------- | -------------------------------- |
| Lenguaje             | Python 3.12                      |
| Framework            | Flask                            |
| Pruebas              | Pytest                           |
| Análisis de código   | Flake8                           |
| Contenedores         | Docker                           |
| Registro de imágenes | Docker Hub                       |
| Control de versiones | Git + GitHub                     |
| CI/CD                | GitHub Actions                   |
| Cloud                | Render                           |
| IaC                  | Render Blueprint (`render.yaml`) |
| Puerto de aplicación | 5000                             |

---

# 3. Arquitectura

El flujo general del proyecto es:

                    ┌─────────────────┐
                    │     GitHub      │
                    │  Código + Git   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ GitHub Actions  │
                    │       CI        │
                    └────────┬────────┘
                             │
                 ┌───────────┴───────────┐
                 ▼                       ▼
          ┌─────────────┐         ┌─────────────┐
          │   Flake8    │         │   Pytest    │
          └─────────────┘         └─────────────┘
                 │                       │
                 └───────────┬───────────┘
                             ▼
                    ┌─────────────────┐
                    │      Docker     │
                    │ Build + Image   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   Docker Hub    │
                    │ simonvf10/...   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Deploy Hook     │
                    │     Render      │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ VetAgenda Cloud │
                    │     Render      │
                    └─────────────────┘



# 4. Control de versiones

El proyecto utiliza Git y GitHub para administrar el código fuente y el trabajo colaborativo.

Se utilizaron ramas de trabajo independientes para implementar las diferentes etapas del proyecto.

### Ramas principales utilizadas

* main: rama principal y protegida.
* feature/backend: implementación inicial de la aplicación y configuración del backend.
* feature/cloud-terraform: configuración inicial de infraestructura y despliegue.
* feature/cd-render: implementación del despliegue continuo hacia Render.
* feature/cd-v2: demostración de una segunda versión de la aplicación.

La rama main cuenta con protección y requiere una revisión/aprobación mediante Pull Request antes de realizar un merge.

### Commits

Se utilizaron mensajes descriptivos para identificar los cambios realizados, por ejemplo:


feat: actualiza version de VetAgenda




# 5. Integración Continua (CI)

La integración continua se implementó mediante GitHub Actions.

El workflow se encuentra versionado en:

.github/workflows/ci.yml


El pipeline realiza las siguientes tareas:

1. Descarga del código.
2. Configuración de Python 3.12.
3. Instalación de dependencias.
4. Ejecución de Flake8.
5. Ejecución de pruebas con Pytest.
6. Inicio de sesión en Docker Hub.
7. Construcción de la imagen Docker.
8. Publicación de la imagen en Docker Hub.

El pipeline se ejecuta ante cambios en las ramas de trabajo y Pull Requests hacia `main`.

### Validaciones

El pipeline impide continuar correctamente cuando fallan las validaciones de código o las pruebas automatizadas.


# 6. Contenedores

VetAgenda utiliza Docker para empaquetar la aplicación junto con sus dependencias.

El archivo utilizado es:


Dockerfile


La imagen se construye utilizando Python 3.12 y expone el puerto:
5000


La imagen se publica en Docker Hub con los siguientes tags:


latest
<commit SHA>


Esto permite identificar tanto la versión actual como una versión específica asociada a un commit.

---

# 7. Infraestructura como Código (IaC)

Para declarar la configuración del servicio en Render se utiliza:

render.yaml


La configuración define:

* Tipo de servicio: Web.
* Nombre: `vetagenda`.
* Runtime: imagen Docker.
* Plan: Free.
* Región: Oregon.
* Imagen utilizada: `simonvf10/vetagenda:latest`.
* Ruta de health check: `/`.

El archivo permite mantener la configuración de infraestructura versionada junto al código fuente.


# 8. Cloud

El proveedor Cloud seleccionado es **Render**.

Render fue seleccionado porque permite desplegar la aplicación Dockerizada en la nube mediante un servicio web, facilitando la implementación del proceso de despliegue continuo.

La aplicación desplegada puede ser accedida desde Internet mediante la URL pública proporcionada por Render.

---

# 9. Despliegue Continuo (CD)

El despliegue continuo se implementó mediante GitHub Actions y un Deploy Hook de Render.

Después de realizar un merge hacia main, GitHub Actions:

1. Ejecuta nuevamente las validaciones.
2. Construye la imagen Docker.
3. Publica la nueva imagen en Docker Hub.
4. Ejecuta el Deploy Hook de Render.
5. Render despliega la nueva versión de la aplicación.

El workflow utiliza el secreto:

RENDER_DEPLOY_HOOK


El secreto se almacena en GitHub Actions Secrets y no se encuentra dentro del código fuente.

---

# 10. Seguridad

Las credenciales utilizadas para acceder a Docker Hub y Render no se almacenan directamente en el repositorio.

Se utilizan GitHub Repository Secrets para proteger información sensible, incluyendo:

DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
RENDER_DEPLOY_HOOK


De esta manera, las credenciales no forman parte del código versionado.

---

# 11. Demostración del despliegue continuo

Para comprobar el funcionamiento del CD se realizaron dos versiones sucesivas.

### Versión 1

La aplicación mostraba:

VetAgenda funcionando correctamente

Esta versión fue construida, publicada en Docker Hub y desplegada en Render.

### Versión 2

Posteriormente se realizó un cambio controlado en la aplicación:

VetAgenda funcionando correctamente - v2

El cambio fue enviado mediante Pull Request hacia main.

Después de la aprobación y merge:


GitHub
   ↓
GitHub Actions
   ↓
Docker Build
   ↓
Docker Hub
   ↓
Deploy Hook
   ↓
Render


La nueva versión fue desplegada correctamente y comprobada directamente en el servicio Cloud.

Esto permitió verificar el funcionamiento del proceso de despliegue continuo entre dos versiones sucesivas.

---

# 12. Estructura del proyecto


VetAgenda/
│
├── app/
│   ├── __init__.py
│   └── app.py
│
├── tests/
│   └── test_app.py
│
├── docker/
│
├── terraform/
│   ├── main.tf
│   └── variables.tf
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── terraform.yml
│
├── Dockerfile
├── requirements.txt
├── render.yaml
└── README.md

# 12. Diagrama del PIPELINE


                 ┌─────────────────────┐
                 │       GitHub        │
                 │ Push / Pull Request │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │   GitHub Actions    │
                 │        CI/CD        │
                 └──────────┬──────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
        ┌───────────┐               ┌───────────┐
        │  Flake8   │               │  Pytest   │
        └─────┬─────┘               └─────┬─────┘
              │                           │
              └─────────────┬─────────────┘
                            ▼
                    ┌───────────────┐
                    │ Docker Build  │
                    └───────┬───────┘
                            ▼
                    ┌───────────────┐
                    │  Docker Hub   │
                    └───────┬───────┘
                            │
                       Solo main
                            ▼
                    ┌───────────────┐
                    │ Deploy Hook   │
                    └───────┬───────┘
                            ▼
                    ┌───────────────┐
                    │    Render     │
                    └───────────────┘


Triggers:

Push a ramas de trabajo.
Pull Request hacia main.
Push a main para ejecutar el despliegue.

Condiciones de falla:

Si Flake8 falla → pipeline falla.
Si Pytest falla → pipeline falla.
Si Docker build falla → pipeline falla.
Si publicación Docker falla → pipeline falla.
Si el Deploy Hook falla → debemos mejorar el comando a curl -f para que GitHub detecte correctamente el error.




# 13. Resultados obtenidos

Durante la implementación se logró:

* Implementar control de versiones mediante Git y GitHub.
* Configurar ramas de trabajo y protección de `main`.
* Implementar Pull Requests con revisión.
* Crear un pipeline de integración continua.
* Ejecutar análisis de código mediante Flake8.
* Ejecutar pruebas automatizadas mediante Pytest.
* Crear imágenes Docker.
* Publicar imágenes en Docker Hub.
* Declarar la configuración Cloud mediante `render.yaml`.
* Desplegar VetAgenda en Render.
* Automatizar el despliegue mediante GitHub Actions.
* Probar dos versiones sucesivas de la aplicación mediante CD.

---

# 14. Conclusiones

El proyecto permitió implementar un flujo DevOps completo para una aplicación web, integrando control de versiones, integración continua, contenedores, infraestructura como código y despliegue continuo.

La automatización permitió reducir la intervención manual necesaria para publicar nuevas versiones, además de incorporar validaciones automáticas antes del despliegue.

La demostración de dos versiones sucesivas confirmó que una modificación realizada en el código puede atravesar el proceso de CI, generar una nueva imagen Docker y finalmente ser desplegada automáticamente en un entorno Cloud mediante Render.
