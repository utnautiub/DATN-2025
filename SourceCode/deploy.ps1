# Script để triển khai các thay đổi mã nguồn và cập nhật cơ sở dữ liệu

# Dừng các dịch vụ hiện tại
docker-compose down

# Xây dựng lại các container (với --no-cache để đảm bảo cập nhật mới nhất)
docker-compose build --no-cache

# Khởi động lại các dịch vụ
docker-compose up -d

# Hiển thị log để theo dõi quá trình khởi động
docker-compose logs -f