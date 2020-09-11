FROM node AS builder

COPY . /app
WORKDIR /app

RUN npm config set registry "https://registry.npm.taobao.org/" \
    && npm config set sass_binary_site=https://npm.taobao.org/mirrors/node-sass/ \
    && npm install \
    && npm run build


FROM nginx

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt update && apt install -y file zip curl

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
