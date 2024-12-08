FROM node:14 AS ui-build

WORKDIR /frontend

COPY package.json /frontend
COPY package-lock.json /frontend
RUN npm install
COPY . /frontend
RUN npm run build

# Delete source code files that were used to build the app that are no longer needed
# RUN rm -rf src/ static/ emailTemplates/ docker-compose.yml

FROM nginx:1.19-alpine
COPY --from=ui-build /frontend/build /usr/share/nginx/html
