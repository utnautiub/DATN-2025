# Nền tảng học tập điện tử tích hợp cho giáo dục từ xa

## Giới thiệu

Hệ thống quản lý học tập (LMS) này được phát triển để cung cấp một giải pháp toàn diện cho việc học tập và giảng dạy trực tuyến. Được xây dựng với công nghệ hiện đại, nền tảng này đáp ứng nhu cầu cơ bản của các cơ sở giáo dục từ quản lý người dùng, chương trình học đến theo dõi tiến độ và báo cáo.

## Kiến trúc kỹ thuật

### Front-end
- **Framework**: Nuxt.js - Framework Vue.js với kết xuất phía máy chủ
- **UI Component**: Shadcn-vue - Thư viện thành phần giao diện đẹp và hiệu suất cao
- **Responsive Design**: Tối ưu cho mọi thiết bị từ máy tính đến điện thoại di động

### Back-end
- **Framework**: Ruby on Rails - Nền tảng phát triển web mạnh mẽ, tập trung vào quy ước
- **Database**: PostgreSQL - Hệ quản trị CSDL mã nguồn mở với khả năng mở rộng cao
- **API**: RESTful API - Cung cấp giao diện tương tác giữa front-end và back-end

## Các chức năng chính

### 1. Quản lý người dùng
- Đăng ký và xác thực người dùng
- Phân quyền theo vai trò (sinh viên, giảng viên, quản trị viên)
- Hồ sơ cá nhân với thông tin chi tiết
- Quản lý nhóm người dùng và phân quyền

### 2. Quản lý chương trình đào tạo
- Thiết lập và quản lý chương trình học
- Tạo và quản lý danh mục khóa học
- Theo dõi tiến độ chương trình học của sinh viên
- Quản lý điều kiện tiên quyết và kế hoạch học tập

### 3. Quản lý kỳ học
- Thiết lập các chu kỳ học tập (học kỳ, ...)
- Quản lý lịch đăng ký học phần
- Theo dõi tiến độ kỳ học

### 4. Quản lý lớp học
- Tạo và quản lý các lớp học từ khóa học
- Lịch học và lịch thi
- Quản lý phòng học và thiết bị
- Hỗ trợ các hình thức học tập trực tiếp, trực tuyến và kết hợp

### 5. Quản lý đăng ký học phần
- Đăng ký học phần trực tuyến
- Theo dõi trạng thái đăng ký
- Quản lý danh sách chờ và giới hạn sĩ số

### 6. Quản lý điểm danh
- Điểm danh bằng mã QR hoặc định vị GPS
- Báo cáo điểm danh tự động
- Thống kê và cảnh báo vắng mặt

### 7. Quản lý học tập
- Lưu trữ và phân phối tài liệu học tập
- Bài giảng video và theo dõi lượt xem
- Quản lý bài tập và đánh giá
- Theo dõi tiến độ học tập của sinh viên

### 8. Quản lý đánh giá và thi cử
- Tạo bài kiểm tra trực tuyến với nhiều loại câu hỏi
- Thiết lập thời gian làm bài và điều kiện thi
- Chấm điểm tự động và phản hồi
- Phân tích kết quả học tập

### 9. Quản lý tương tác
- Diễn đàn thảo luận cho từng lớp học
- Nhắn tin trực tiếp giữa sinh viên và giảng viên
- Thông báo và cập nhật hoạt động

### 10. Quản lý đánh giá chất lượng
- Đánh giá giảng viên và khóa học
- Khảo sát ý kiến sinh viên
- Cải thiện chất lượng giảng dạy

### 11. Quản lý tiến độ học tập
- Theo dõi điểm số và tín chỉ đạt được
- Biểu đồ tiến độ và báo cáo tổng hợp
- Cảnh báo học vụ tự động

### 12. Quản lý thông báo
- Thông báo tự động về sự kiện quan trọng
- Lịch sử thông báo và trạng thái đọc

### 13. Quản lý tài chính
- Tính học phí
- Theo dõi thanh toán
- Báo cáo tài chính và thống kê

### 14. Quản lý tích hợp công cụ
- Tích hợp với công cụ học tập trực tuyến (Zoom, Google Meet)
- Quản lý phòng học ảo và lịch học trực tuyến
- API mở cho tích hợp bên thứ ba

### 15. Quản lý báo cáo
- Báo cáo tổng hợp về hoạt động học tập
- Phân tích dữ liệu và xu hướng
- Báo cáo tài chính và thống kê

## Cài đặt và triển khai

### Yêu cầu hệ thống
- Node.js (>=14.x)
- Ruby (>=3.0)
- PostgreSQL (>=13)
- NPM hoặc Yarn

### Các bước cài đặt

#### Back-end (Ruby on Rails)
```bash
# Clone repository
git clone https://github.com/your-org/e-learning-backend.git
cd e-learning-backend

# Cài đặt dependencies
bundle install

# Thiết lập database
rails db:create
rails db:migrate
rails db:seed

# Khởi động server
rails s
```

#### Front-end (Nuxt.js)
```bash
# Clone repository
git clone https://github.com/your-org/e-learning-frontend.git
cd e-learning-frontend

# Cài đặt dependencies
npm install # hoặc yarn install

# Khởi động server phát triển
npm run dev # hoặc yarn dev

# Build cho production
npm run build # hoặc yarn build
```

### Cấu hình môi trường
Tạo file `.env` với các thông số cần thiết:
```
DATABASE_URL=postgresql://username:password@localhost:5432/elearning_db
SECRET_KEY_BASE=your_secret_key
API_BASE_URL=http://localhost:3000/api
```

## Mô hình dữ liệu

Hệ thống sử dụng cơ sở dữ liệu PostgreSQL. Chi tiết về cấu trúc database có thể tìm thấy trong file `db/schema.sql`.

## Phát triển và đóng góp

### Quy trình phát triển ()
- Sử dụng Git Flow với các nhánh chính: `main`, `develop`, `dev-sprint{id}`
- Mọi thay đổi phải được review code trước khi merge
- Tuân thủ các tiêu chuẩn mã nguồn và kiểm thử

## Liên hệ và hỗ trợ

Nếu bạn có câu hỏi hoặc cần hỗ trợ, vui lòng liên hệ:
- Email: buituantu@buituantu.com
- Trang web: https://www.elearning.buituantu.com
- Documentation: https://docs.elearning.buituantu.com

---

© 2025 Nền tảng học tập điện tử | Phiên bản 1.0.0