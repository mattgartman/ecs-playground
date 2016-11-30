FROM node:7.2.0
# for testing purposes
RUN npm install -g jasmine-node
RUN mkdir /app
WORKDIR /app
COPY package.json /app/
RUN npm install
COPY . /app
EXPOSE 3000
ENTRYPOINT ["npm", "start"]