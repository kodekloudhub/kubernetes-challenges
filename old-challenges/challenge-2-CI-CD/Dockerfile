FROM node:carbon

WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install 
# Copy app
COPY . /usr/src/app


# Expose for api
EXPOSE 3000

CMD [ "node", "app/server.js"]

