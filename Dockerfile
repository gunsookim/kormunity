# 빌드 단계
FROM node:latest as build
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build

# 실행 단계
FROM nginx:alpine

# 필요한 디렉토리 생성 및 권한 설정
RUN mkdir -p /var/tmp/nginx && \
    chown -R nginx:nginx /var/tmp/nginx

# 커스텀 Nginx 설정 파일 복사
COPY nginx.conf /etc/nginx/nginx.conf
COPY custom-default.conf /etc/nginx/conf.d/default.conf

# 빌드된 React 앱 복사
COPY --from=build /app/build /usr/share/nginx/html

# Nginx를 non-root 사용자로 실행
USER nginx

EXPOSE 7080
CMD ["nginx", "-g", "daemon off;"]
