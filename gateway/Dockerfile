# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --production

# Production stage
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --production

COPY . .

EXPOSE 5921

CMD ["npm", "start"]
