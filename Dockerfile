FROM node:20-alpine
RUN apk add --no-cache bash openssl curl git
WORKDIR /app
COPY package.json start.sh /app/
RUN npm install
RUN chmod +x /app/start.sh
ENV PATH /app/node_modules/.bin:$PATH
EXPOSE 18789
CMD ["npm", "start"]
