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
#RUN mkdir -p /var/cache/nginx/client_temp /var/run \
#    && chown -R nginx:nginx /var/cache/nginx /var/run

# Nginx가 root 대신 nginx 사용자로 실행되도록 설정
USER nginx

COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
