# Step 1: Build Angular App
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --configuration=production

# Step 2: Serve with NGINX
FROM nginx:alpine

# Copy correct build output (browser) to NGINX html folder
COPY --from=builder /app/dist/my-angular-app/browser /usr/share/nginx/html

# Optional: Remove default config and add your own
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Set port
ENV PORT=8080
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

