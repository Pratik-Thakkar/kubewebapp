FROM node:alpine

WORKDIR /var/www/node/kubewebapp

COPY ./ ./

RUN npm install -g npm@8.11.0 && \
    npm install -g yarn forever --force

USER node

EXPOSE 3000

CMD ["forever", "index.js"]