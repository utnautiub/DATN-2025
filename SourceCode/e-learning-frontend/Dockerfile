FROM node:22

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép package.json và cài đặt npm dependencies
COPY package.json ./
RUN npm install

# Sao chép toàn bộ mã nguồn
COPY . .

# Mở cổng 4000
EXPOSE 4000

# Command mặc định (sẽ bị ghi đè trong docker-compose.yml)
CMD ["npm", "run", "dev"]