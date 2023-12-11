# 빌드 단계
FROM node:latest as build
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build

# 실행 단계
FROM nginx:alpine

# Nginx를 non-root 사용자로 실행
RUN mkdir -p /var/cache/nginx/client_temp /var/run \
    && chown -R nginx:nginx /var/cache/nginx /var/run

# Nginx가 root 대신 nginx 사용자로 실행되도록 설정
USER nginx

COPY --from=build /app/build /usr/share/nginx/html
# Nginx 설정을 수정하여 비 root 사용자가 사용할 수 있는 포트(예: 7080)를 리스닝하도록 설정
RUN sed -i 's/listen[ \t]*80;/listen 7080;/g' /etc/nginx/conf.d/default.conf
RUN sed -i 's/listen[ \t]*80;/listen 7080;/g' /etc/nginx/nginx.conf

EXPOSE 7080
CMD ["nginx", "-g", "daemon off;"]