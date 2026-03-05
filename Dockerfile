FROM node:22
RUN apt-get update && apt-get install -y --no-install-recommends bash openssl curl git python3 make g++ build-essential
WORKDIR /app
COPY package.json start.sh /app/
RUN npm install
RUN chmod +x /app/start.sh
ENV PATH /app/node_modules/.bin:$PATH
EXPOSE 18789
CMD ["npm", "start"]
