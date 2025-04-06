FROM ruby:3.3.7

# Cài đặt các phụ thuộc cần thiết
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép Gemfile và cài đặt gem
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Sao chép toàn bộ mã nguồn
COPY . .

# Mở cổng 3000
EXPOSE 3000

# Command mặc định (sẽ bị ghi đè trong docker-compose.yml)
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]