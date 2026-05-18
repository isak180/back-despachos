# ============================================================
# STAGE 1 - BUILD
# Compila el proyecto Spring Boot con Maven
# ============================================================
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder

WORKDIR /app

# Copiamos solo el pom.xml primero para cachear dependencias Maven
COPY pom.xml ./pom.xml
COPY .mvn ./.mvn
COPY mvnw ./mvnw

# Descargamos dependencias (se cachean si pom.xml no cambia)
RUN chmod +x mvnw && ./mvnw dependency:go-offline -q

# Copiamos el código fuente
COPY src ./src

# Compilamos y empaquetamos (sin tests para agilizar el build)
RUN ./mvnw package -DskipTests -q

# ============================================================
# STAGE 2 - PRODUCTION
# Imagen mínima JRE para ejecutar el JAR
# ============================================================
FROM eclipse-temurin:21-jre-alpine AS production

# Creamos usuario no root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copiamos solo el JAR compilado desde el stage anterior
COPY --from=builder /app/target/*.jar app.jar

# Ajustamos permisos
RUN chown -R appuser:appgroup /app

# Usamos usuario no root
USER appuser

# Puerto de la API
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

# Variables de entorno con valores por defecto (se sobreescriben en docker-compose o EC2)
ENV DB_HOST=db \
    DB_PORT=3306 \
    DB_NAME=despachos_db \
    DB_USER=appuser \
    DB_PASS=apppassword \
    SERVER_PORT=8080

ENTRYPOINT ["java", "-jar", "app.jar"]