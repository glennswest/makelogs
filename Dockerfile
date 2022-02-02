ARG NODE_VERSION=17.4.0
FROM node:${NODE_VERSION} AS base

COPY / /app
WORKDIR /app
RUN yarn install

ENTRYPOINT [ "/app/bin/makelogs" ]
