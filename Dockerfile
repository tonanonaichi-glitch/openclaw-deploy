FROM node:20-alpine
RUN apk add --no-cache bash openssl curl git
RUN npm install -g openclaw
WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
EXPOSE 18789
CMD ["/bin/bash", "/app/start.sh"]
