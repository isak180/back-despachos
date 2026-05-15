# Backend Despachos - Spring Boot | ISY1101 EP2

API REST desarrollada con **Spring Boot + Java 21 + MySQL**, dockerizada con multi-stage build y desplegada en AWS EC2 (subred privada) mediante GitHub Actions.

---

## Tecnologías

- Java 21 + Spring Boot 3
- MySQL 8.0
- Maven
- Docker (multi-stage build)
- GitHub Actions (CI/CD)
- AWS ECR + EC2 (subred privada)

---

## Estructura del repositorio

```
backend-despachos/
├── Springboot-API-REST-DESPACHO/   # Código fuente Spring Boot
│   ├── src/
│   │   └── main/
│   │       ├── java/com/citt/      # Paquetes Java
│   │       └── resources/
│   │           └── application.properties
│   └── pom.xml
├── Dockerfile                       # Multi-stage build (Maven → JRE)
├── docker-compose.yml               # Stack: Spring Boot + MySQL
├── init.sql                         # Script de inicialización de BD
├── .env.example                     # Variables de entorno
└── .github/
    └── workflows/
        └── cicd-backend-despachos.yml
```

---

## Ejecución local con Docker

```bash
cp .env.example .env
# Editar .env con valores deseados

docker-compose up -d --build

# Verificar que ambos servicios están corriendo
docker-compose ps
```

La API estará disponible en: `http://localhost:8080`

---

## Endpoints principales

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/despachos` | Listar todos los despachos |
| GET | `/api/despachos/{id}` | Obtener despacho por ID |
| POST | `/api/despachos` | Crear nuevo despacho |
| PUT | `/api/despachos/{id}` | Actualizar despacho |
| DELETE | `/api/despachos/{id}` | Eliminar despacho |

---

## Persistencia de datos

Se usa un **named volume** (`despachos-db-data`) para persistir los datos de MySQL.

**¿Por qué named volume y no bind mount?**
- Es gestionado completamente por Docker, sin depender de la ruta del sistema host
- Portable entre entornos (local, EC2, CI)
- Recomendado para bases de datos en producción
- El bind mount es útil para desarrollo cuando se quiere editar archivos directamente

---

## Pipeline CI/CD

Se activa con **push en la rama `deploy`**:

1. Build de la imagen con `docker build`
2. Push a Amazon ECR (con tag `sha` y `latest`)
3. Deploy automático en EC2 privada via AWS SSM

---

## GitHub Secrets requeridos

| Secret | Descripción |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | Credencial AWS |
| `AWS_SECRET_ACCESS_KEY` | Credencial AWS |
| `AWS_SESSION_TOKEN` | Token AWS Academy |
| `AWS_REGION` | Región (`us-east-1`) |
| `ECR_REGISTRY` | URL del ECR |
| `ECR_REPO_BACKEND_DESPACHOS` | Nombre del repo ECR |
| `EC2_BACKEND_INSTANCE_ID` | ID de la instancia EC2 privada |
| `DB_HOST` | IP privada del contenedor MySQL |
| `DB_NAME` | Nombre de la base de datos |
| `DB_USER` | Usuario de la base de datos |
| `DB_PASS` | Contraseña de la base de datos |
| `FRONTEND_URL` | URL del frontend (para CORS) |
