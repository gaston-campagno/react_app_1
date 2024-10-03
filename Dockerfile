# Etapa 1: Construcción de la aplicación React
FROM node:16.14.2 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Etapa 2: Configuración de Nginx para servir la aplicación React
FROM nginx:alpine AS nginx

# Copiar la compilación de la aplicación React a Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Exponer el puerto 80 para la app React
EXPOSE 80

# Etapa 3: Configuración de Node.js para servir las métricas
FROM node:16.14.2 AS metrics

WORKDIR /app

# Copiar el código del servidor de métricas
COPY server.js ./ 
COPY metrics ./metrics/
COPY package*.json ./

RUN npm install

# Exponer el puerto 4000 para las métricas
EXPOSE 4000

# Comando para iniciar el servidor de métricas
CMD ["node", "server.js"]

# Etapa 4: Combinación de Nginx y Node.js en paralelo usando supervisord
FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

# Copiar el archivo de configuración de supervisord
RUN apk add --no-cache supervisor
COPY supervisord.conf /etc/supervisord.conf

# Copiar la configuración de Nginx y el servidor de métricas de Node.js
COPY --from=metrics /app /app

# Exponer puertos
EXPOSE 80 4000

# Iniciar Nginx y Node.js en paralelo con supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
