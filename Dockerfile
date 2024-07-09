FROM node:17-alpine3.15
RUN apk add --no-cache ffmpeg
WORKDIR /app
RUN adduser -D app
COPY --chown=app:app . .
RUN npm install --production
RUN mkdir -p ./tmp
RUN chown app:app ./tmp
USER app
ENTRYPOINT [ "node", "index.js" ]