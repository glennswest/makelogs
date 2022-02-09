ARG NODE_VERSION=17.4.0
FROM node:${NODE_VERSION} AS base

COPY / /app
COPY runmakelogs.sh /app/bin/runmakelogs.sh
WORKDIR /app
RUN yarn install

CMD ["bash","/app/bin/runmakelogs.sh"]
