FROM node:alpine

WORKDIR /var/www/node/k8s-tutorial-api

COPY ./ ./

RUN npm install -g npm@8.11.0

RUN npm install -g yarn forever && \
  yarn install --production

USER node

EXPOSE 3000

CMD ["forever", "index.js"]