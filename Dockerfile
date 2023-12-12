# 빌드 단계
FROM node:latest as build
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build

# 실행 단계 Nginx 이미지 기반
FROM nginx:alpine

# 빌드된 애플리케이션 복사
COPY --from=build /app/build /usr/share/nginx/html

# 필요한 디렉토리 생성 및 권한 설정
RUN mkdir -p /var/tmp/nginx /var/cache/nginx /var/run /var/log/nginx && \
    chown -R nginx:nginx /var/tmp/nginx /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R 755 /var/tmp/nginx /var/cache/nginx /var/run /var/log/nginx

# Nginx 구성 파일 추가
COPY nginx.conf /etc/nginx/nginx.conf
COPY custom-default.conf /etc/nginx/conf.d/default.conf


# Nginx를 non-root 사용자(nginx)로 실행
USER nginx

EXPOSE 7080
CMD ["nginx", "-g", "daemon off;"]

