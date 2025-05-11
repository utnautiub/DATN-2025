<template>
  <div>
    <section class="py-40 mt-4 bg-gradient-to-b to-primary/5 from-background">
      <div class="container mx-auto px-4 text-center">
        <div class="flex justify-center mb-6">
          <img src="https://tlu.edu.vn/Portals/_default/skins/tluvie/images/logo.png" alt="Đại học Thủy Lợi" class="h-24" />
        </div>
        <h1 class="text-4xl md:text-5xl font-bold mb-6 text-primary">Hệ Thống Quản Lý Đào Tạo</h1>
        <p class="text-xl md:text-2xl mb-8 max-w-3xl mx-auto text-muted-foreground">Trường Đại học Thủy Lợi</p>
        <div class="flex flex-col sm:flex-row justify-center gap-4">
          <NuxtLink to="/login">
            <Button size="lg" class="font-medium">
              Đăng nhập hệ thống
            </Button>
          </NuxtLink>
          <NuxtLink to="/#features">
            <Button size="lg" variant="outline" class="font-medium">
              Tìm hiểu thêm
            </Button>
          </NuxtLink>
        </div>
      </div>
    </section>

    <section id="features" class="py-16">
      <div class="container mx-auto px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold mb-4">Tính năng hệ thống</h2>
          <p class="text-muted-foreground max-w-2xl mx-auto">Hệ thống quản lý đào tạo trực tuyến giúp sinh viên, giảng viên và cán bộ quản lý dễ dàng truy cập thông tin và nguồn tài nguyên học tập</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardHeader class="pb-2">
              <div class="p-3 rounded-full bg-primary/10 text-primary w-fit">
                <Icon icon="heroicons:academic-cap" class="h-6 w-6" />
              </div>
              <CardTitle class="text-xl font-medium mt-4">Quản lý học tập</CardTitle>
              <CardDescription>Truy cập thông tin khóa học, lịch học và tài liệu học tập</CardDescription>
            </CardHeader>
            <CardContent>
              <ul class="space-y-2 text-muted-foreground">
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>Quản lý thời khóa biểu</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>Truy cập tài liệu học tập</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>Theo dõi kết quả học tập</span>
                </li>
              </ul>
            </CardContent>
          </Card>

          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardHeader class="pb-2">
              <div class="p-3 rounded-full bg-primary/10 text-primary w-fit">
                <Icon icon="heroicons:document-text" class="h-6 w-6" />
              </div>
              <CardTitle class="text-xl font-medium mt-4">Quản lý đào tạo</CardTitle>
              <CardDescription>Công cụ hiệu quả cho cán bộ quản lý và giảng viên</CardDescription>
            </CardHeader>
            <CardContent>
              <ul class="space-y-2 text-muted-foreground">
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>Quản lý lớp học và khóa học</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>Điểm danh và đánh giá học tập</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>Quản lý chương trình đào tạo</span>
                </li>
              </ul>
            </CardContent>
          </Card>

          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardHeader class="pb-2">
              <div class="p-3 rounded-full bg-primary/10 text-primary w-fit">
                <Icon icon="heroicons:chart-bar" class="h-6 w-6" />
              </div>
              <CardTitle class="text-xl font-medium mt-4">Báo cáo & Thống kê</CardTitle>
              <CardDescription>Công cụ phân tích dữ liệu và báo cáo</CardDescription>
            </CardHeader>
            <CardContent>
              <ul class="space-y-2 text-muted-foreground">
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>Thống kê điểm số và kết quả</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>Theo dõi tiến độ học tập</span>
                </li>
                <li class="flex items-center">
                  <Icon icon="heroicons:check" class="h-5 w-5 text-primary mr-2" />
                  <span>Báo cáo tổng hợp thông tin đào tạo</span>
                </li>
              </ul>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>

    <section class="py-16 bg-muted/50">
      <div class="container mx-auto px-4">
        <div class="flex flex-col lg:flex-row items-center gap-12">
          <div class="lg:w-1/2">
            <img src="https://i1-vnexpress.vnecdn.net/2023/08/21/316222594-3471214863152813-531-5319-3204-1692602206.jpg?w=0&h=0&q=100&dpr=2&fit=crop&s=jIfZ_imTBAzXv25MX78IKA" alt="Đại học Thủy Lợi" 
              class="rounded-lg shadow-lg object-cover h-full">
          </div>
          <div class="lg:w-1/2">
            <h2 class="text-3xl font-bold mb-6">Về Trường Đại học Thủy Lợi</h2>
            <p class="text-muted-foreground mb-6">Trường Đại học Thủy Lợi là trường đại học công lập trọng điểm quốc gia Việt Nam, được thành lập từ năm 1959. Trường chuyên đào tạo về lĩnh vực thủy lợi, tài nguyên nước, kỹ thuật hạ tầng, môi trường và nhiều ngành khoa học kỹ thuật khác.</p>
            <div class="grid grid-cols-2 gap-6 mb-8">
              <div>
                <div class="text-3xl font-bold text-primary mb-2">65+</div>
                <p class="text-muted-foreground">Năm phát triển và đào tạo</p>
              </div>
              <div>
                <div class="text-3xl font-bold text-primary mb-2">300+</div>
                <p class="text-muted-foreground">Giảng viên và nhà nghiên cứu</p>
              </div>
              <div>
                <div class="text-3xl font-bold text-primary mb-2">24,066+</div>
                <p class="text-muted-foreground">Sinh viên đang theo học</p>
              </div>
              <div>
                <div class="text-3xl font-bold text-primary mb-2">45+</div>
                <p class="text-muted-foreground">Ngành đào tạo</p>
              </div>
            </div>
            <div class="space-x-4">
              <NuxtLink to="/history">
                <Button variant="outline">
                  Lịch sử phát triển
                </Button>
              </NuxtLink>
              <a href="https://www.tlu.edu.vn" target="_blank" rel="noopener noreferrer">
                <Button variant="secondary">
                  Website chính thức
                </Button>
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="py-16">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-3xl font-bold mb-4">Liên hệ hỗ trợ</h2>
        <p class="text-muted-foreground max-w-2xl mx-auto mb-8">Nếu bạn cần hỗ trợ về hệ thống, vui lòng liên hệ với chúng tôi qua các kênh sau</p>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardContent class="pt-6">
              <div class="flex flex-col items-center">
                <div class="p-3 rounded-full bg-primary/10 text-primary mb-4">
                  <Icon icon="heroicons:envelope" class="h-6 w-6" />
                </div>
                <h3 class="font-medium mb-2">Email</h3>
                <p class="text-muted-foreground mb-4">daotao@tlu.edu.vn</p>
                <a href="mailto:daotao@tlu.edu.vn">
                  <Button variant="outline" size="sm">Gửi email</Button>
                </a>
              </div>
            </CardContent>
          </Card>
          
          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardContent class="pt-6">
              <div class="flex flex-col items-center">
                <div class="p-3 rounded-full bg-primary/10 text-primary mb-4">
                  <Icon icon="heroicons:phone" class="h-6 w-6" />
                </div>
                <h3 class="font-medium mb-2">Điện thoại</h3>
                <p class="text-muted-foreground mb-4">024.3852.2201</p>
                <a href="tel:+842438522201">
                  <Button variant="outline" size="sm">Gọi ngay</Button>
                </a>
              </div>
            </CardContent>
          </Card>
          
          <Card class="overflow-hidden border-border/50 transition-all duration-200 hover:shadow-md">
            <CardContent class="pt-6">
              <div class="flex flex-col items-center">
                <div class="p-3 rounded-full bg-primary/10 text-primary mb-4">
                  <Icon icon="heroicons:map-pin" class="h-6 w-6" />
                </div>
                <h3 class="font-medium mb-2">Địa chỉ</h3>
                <p class="text-muted-foreground mb-4">175 Tây Sơn, Đống Đa, Hà Nội</p>
                <a href="https://maps.app.goo.gl/dCDR4KH9z3U27RkL8" target="_blank" rel="noopener noreferrer">
                  <Button variant="outline" size="sm">Xem bản đồ</Button>
                </a>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>
  </div>
</template>

<script lang="ts" setup>
import { Icon } from '@iconify/vue';
const { t } = useLanguage();
const router = useRouter();

definePageMeta({
  layout: 'landing'
});

useHead({
  title: 'Hệ thống quản lý đào tạo - Đại học Thủy Lợi',
  meta: [
    {
      name: 'description',
      content: 'Hệ thống quản lý đào tạo trực tuyến Trường Đại học Thủy Lợi'
    }
  ]
});

onMounted(() => {
  // Kiểm tra nếu người dùng đã đăng nhập thì redirect về trang tương ứng
  const token = localStorage.getItem('token');
  const userRole = localStorage.getItem('user_role');
  
  if (token && userRole) {
    switch (userRole) {
      case 'SuperAdmin':
        router.push('/super-admin/dashboard');
        break;
      case 'AdminSchools':
        router.push('/admin/dashboard');
        break;
      case 'Teacher':
        router.push('/teacher/dashboard');
        break;
      case 'Student':
        router.push('/student/dashboard');
        break;
    }
  }
});
</script>

<style></style>
