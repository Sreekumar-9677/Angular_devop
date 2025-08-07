# Stage 1: Build the Angular app
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build --prod

# Stage 2: Serve with NGINX
FROM nginx:alpine
COPY --from=builder /app/dist/my-angular-app /usr/share/nginx/html

# Optional: expose port 80
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
