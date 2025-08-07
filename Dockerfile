# Step 1: Build Angular App
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --configuration=production

# Step 2: Serve with NGINX
FROM nginx:alpine

# Copy compiled Angular app
COPY --from=builder /app/dist/my-angular-app /usr/share/nginx/html

# Remove default config and add our own
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

# Use Cloud Run's expected port
ENV PORT 8080
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
