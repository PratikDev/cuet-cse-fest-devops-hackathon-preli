FROM node:18.20-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --production

COPY --chown=node:node . .

EXPOSE 5921

USER node
CMD ["npm", "start"]
