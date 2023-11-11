# nodejs / vue
FROM node:lts-alpine

RUN npm install -g http-server

WORKDIR /app

COPY ./ /app

RUN npm install

COPY .. .

RUN npm run build

EXPOSE 8080
CMD [ "http-server", "dist" ]
