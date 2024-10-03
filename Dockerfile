# Etapa 1: Construcción de la aplicación React
FROM node:16.14.2 AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Etapa 2: Servir la aplicación con Nginx
FROM nginx:alpine

# Copiar la compilación de la aplicación React a Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Exponer el puerto 80 para Nginx
EXPOSE 80

# Etapa 3: Incluir el servidor Node.js para métricas
FROM node:16.14.2 AS metrics

WORKDIR /app

# Copiar el código de Node.js para exponer las métricas
COPY server.js ./
COPY metrics ./metrics/
# Instalar dependencias necesarias para el servidor de métricas
COPY package*.json ./

RUN npm install

# Exponer el puerto 4000 para las métricas
EXPOSE 4000

# Ejecutar ambos servidores en paralelo usando supervisord o similar
CMD ["sh", "-c", "node server.js & nginx -g 'daemon off;'"]

