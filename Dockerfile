FROM node:alpine

WORKDIR /var/www/node/kubewebapp

COPY ./ ./

USER node

EXPOSE 3000

CMD ["forever", "index.js"]