# FOM https://hub.docker.com/r/appsvc/node/
FROM node:carbon

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
#http://bitjudo.com/blog/2014/03/13/building-efficient-dockerfiles-node-dot-js/
COPY package.json /usr/src/app/
RUN npm install --production
RUN npm install pm2 -g
# Copy app
COPY . /usr/src/app


# Expose for api
EXPOSE 3000

CMD [ "pm2-docker", "start", "pm2.json"]
