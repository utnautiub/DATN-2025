<template>
  <div class="space-y-6">
    <h1 class="text-2xl font-bold md:mb-4">Quản lý tin nhắn</h1>

    <!-- Loading State -->
    <div v-if="isLoading" class="flex justify-center items-center h-64">
      <div class="animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-primary"></div>
    </div>

    <!-- Error or Empty State -->
    <div v-else-if="error" class="text-center text-red-500">
      {{ error }}
    </div>
    <div v-else-if="conversations.length === 0" class="text-center text-muted-foreground">
      Chưa có cuộc trò chuyện nào. Hãy bắt đầu một cuộc trò chuyện mới!
    </div>

    <!-- Main Content -->
    <div v-else>
      <!-- Mobile: Show conversation list or selected chat -->
      <div class="lg:hidden">
        <!-- Conversation List (Mobile) -->
        <div v-if="!selectedConversation" class="space-y-4">
          <Card class="border border-border shadow-sm">
            <CardHeader>
              <CardTitle class="text-lg">Danh sách cuộc trò chuyện</CardTitle>
            </CardHeader>
            <CardContent>
              <div class="space-y-2">
                <div v-for="conversation in conversations" :key="conversation.id"
                  class="flex items-center p-2 rounded-lg hover:bg-muted cursor-pointer"
                  @click="selectConversation(conversation)">
                  <Avatar class="h-10 w-10 mr-2">
                    <AvatarImage :src="conversation.student_avatar" />
                    <AvatarFallback>{{ conversation.student_name[0] }}</AvatarFallback>
                  </Avatar>
                  <div class="flex-1">
                    <div class="font-medium">{{ conversation.student_name }}</div>
                    <div class="text-sm text-muted-foreground ">{{ conversation.last_message }}</div>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <!-- Selected Chat (Mobile) -->
        <div v-else class="space-y-4">
          <Card class="border border-border shadow-sm">
            <CardHeader class="flex flex-row items-center gap-2">
              <Button variant="ghost" size="icon" @click="selectedConversation = null">
                <Icon icon="heroicons:arrow-left" class="h-6 w-6" />
              </Button>
              <Avatar class="h-10 w-10">
                <AvatarImage :src="selectedConversation.student_avatar" />
                <AvatarFallback>{{ selectedConversation.student_name[0] }}</AvatarFallback>
              </Avatar>
              <CardTitle>{{ selectedConversation.student_name }}</CardTitle>
            </CardHeader>
            <CardContent class="space-y-4">
              <ScrollArea class="h-[calc(100vh-340px)] pr-4">
                <div v-for="message in selectedConversation.messages" :key="message.id"
                  :class="message.is_teacher ? 'flex justify-end' : 'flex justify-start'">
                  <div :class="message.is_teacher ? 'bg-primary text-primary-foreground' : 'bg-muted'"
                    class="max-w-[70%] p-3 rounded-lg my-2 relative">
                    <div>{{ message.content }}</div>
                    <div class="text-xs text-muted-foreground mt-1 flex items-center gap-1">
                      {{ new Date(message.sent_at).toLocaleTimeString() }}
                      <!-- Chỉ hiển thị trạng thái cho tin nhắn của giáo viên -->
                      <span v-if="message.is_teacher" class="ml-1">
                        <Icon v-if="message.status === 'sent'" icon="heroicons:check"
                          class="h-3.5 w-3.5 text-muted-foreground" title="Đã gửi" />
                        <Icon v-else-if="message.status === 'delivered'" icon="heroicons:check-check"
                          class="h-3.5 w-3.5 text-muted-foreground" title="Đã nhận" />
                        <Icon v-else-if="message.status === 'read'" icon="heroicons:eye"
                          class="h-3.5 w-3.5 text-muted-foreground" title="Đã đọc" />
                      </span>
                    </div>
                  </div>
                </div>
              </ScrollArea>
              <div class="flex gap-2">
                <Input v-model="newMessage" placeholder="Nhập tin nhắn..." @keyup.enter="sendMessage" />
                <Button @click="sendMessage">
                  <Icon icon="heroicons:paper-airplane" class="h-4 w-4" />
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      <!-- Desktop: Two-column layout -->
      <div class="hidden lg:grid md:grid-cols-12 gap-4 min-h-[calc(100vh-160px)]">
        <Card class="md:col-span-3 border border-border shadow-sm">
          <CardHeader>
            <CardTitle class="text-lg">Danh sách cuộc trò chuyện</CardTitle>
          </CardHeader>
          <CardContent>
            <div class="space-y-2">
              <div v-for="conversation in conversations" :key="conversation.id"
                class="flex items-center p-2 rounded-lg hover:bg-muted cursor-pointer"
                :class="{ 'bg-muted': selectedConversation?.id === conversation.id }"
                @click="selectConversation(conversation)">
                <Avatar class="h-10 w-10 mr-2">
                  <AvatarImage :src="conversation.student_avatar" />
                  <AvatarFallback>{{ conversation.student_name[0] }}</AvatarFallback>
                </Avatar>
                <div class="flex-1">
                  <div class="font-medium">{{ conversation.student_name }}</div>
                  <div class="text-sm text-muted-foreground ">{{ conversation.last_message }}</div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card class="md:col-span-9 border border-border shadow-sm">
          <CardHeader>
            <CardTitle v-if="selectedConversation">{{ selectedConversation.student_name }}</CardTitle>
            <CardTitle v-else>Chọn một cuộc trò chuyện</CardTitle>
          </CardHeader>
          <CardContent v-if="selectedConversation" class="space-y-4">
            <ScrollArea class="min-h-[calc(100vh-310px)] pr-4">
              <div v-for="message in selectedConversation.messages" :key="message.id"
                :class="message.is_teacher ? 'flex justify-end' : 'flex justify-start'">
                <div :class="message.is_teacher ? 'bg-primary text-primary-foreground' : 'bg-muted'"
                  class="max-w-[70%] p-3 rounded-lg my-2 relative">
                  <div>{{ message.content }}</div>
                  <div class="text-xs text-muted-foreground mt-1 flex items-center gap-1">
                    {{ new Date(message.sent_at).toLocaleTimeString() }}
                    <!-- Chỉ hiển thị trạng thái cho tin nhắn của giáo viên -->
                    <span v-if="message.is_teacher" class="ml-1">
                      <Icon v-if="message.status === 'sent'" icon="heroicons:check"
                        class="h-3.5 w-3.5 text-muted-foreground" title="Đã gửi" />
                      <Icon v-else-if="message.status === 'delivered'" icon="heroicons:check-check"
                        class="h-3.5 w-3.5 text-muted-foreground" title="Đã nhận" />
                      <Icon v-else-if="message.status === 'read'" icon="heroicons:eye"
                        class="h-3.5 w-3.5 text-muted-foreground" title="Đã đọc" />
                    </span>
                  </div>
                </div>
              </div>
            </ScrollArea>
            <div class="flex gap-2">
              <Input v-model="newMessage" placeholder="Nhập tin nhắn..." @keyup.enter="sendMessage" />
              <Button @click="sendMessage">
                <Icon icon="heroicons:paper-airplane" class="h-4 w-4" />
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Icon } from '@iconify/vue'
import { ref, onMounted } from 'vue'
import { navigateTo } from '#app'

// Define layout
definePageMeta({
  layout: 'teacher',
});

// State variables
const conversations = ref([])
const selectedConversation = ref(null)
const newMessage = ref('')
const isLoading = ref(true)
const error = ref(null)

// Định nghĩa kiểu cho tin nhắn
interface Message {
  id: number
  content: string
  is_teacher: boolean
  sent_at: string
  status?: 'sent' | 'delivered' | 'read'
}

// Dữ liệu mẫu
const demoConversations = [
  {
    id: 1,
    student_name: "Nguyễn Văn An",
    student_avatar: "https://ui-avatars.com/api/?name=Nguyen+Van+An&background=0D8ABC&color=fff",
    last_message: "Cô ơi, em có thắc mắc về bài tập tuần này.",
    messages: [
      {
        id: 1,
        content: "Cô ơi, em có thắc mắc về bài tập tuần này.",
        is_teacher: false,
        sent_at: "2025-04-19T10:00:00Z"
      },
      {
        id: 2,
        content: "Chào An, em có thể nói rõ hơn về thắc mắc của mình không?",
        is_teacher: true,
        sent_at: "2025-04-19T10:05:00Z",
        status: 'read'
      },
      {
        id: 3,
        content: "Dạ, em không hiểu cách giải bài tập số 3 ạ.",
        is_teacher: false,
        sent_at: "2025-04-19T10:10:00Z"
      }
    ]
  },
  {
    id: 2,
    student_name: "Trần Thị Bình",
    student_avatar: "https://ui-avatars.com/api/?name=Tran+Thi+Binh&background=4F46E5&color=fff",
    last_message: "Em đã nộp bài tập rồi ạ, cô xem giúp em nhé!",
    messages: [
      { id: 4, content: "Em đã nộp bài tập rồi ạ, cô xem giúp em nhé!", is_teacher: false, sent_at: "2025-04-19T09:30:00Z" },
      { id: 5, content: "Cô đã nhận được, để cô chấm và phản hồi sớm nhé!", is_teacher: true, sent_at: "2025-04-19T09:35:00Z" }
    ]
  },
  {
    id: 3,
    student_name: "Lê Minh Châu",
    student_avatar: "https://ui-avatars.com/api/?name=Le+Minh+Chau&background=EF4444&color=fff",
    last_message: "Cô cho em hỏi về lịch thi cuối kỳ được không ạ?",
    messages: [
      { id: 6, content: "Cô cho em hỏi về lịch thi cuối kỳ được không ạ?", is_teacher: false, sent_at: "2025-04-18T15:00:00Z" }
    ]
  }
]

// Check if user is logged in and is teacher
onMounted(() => {
  const userRole = localStorage.getItem('user_role')
  if (!userRole || userRole !== 'teacher') {
    navigateTo('/teacher/login')
  } else {
    fetchConversations()
  }
})

const fetchConversations = async () => {
  try {
    isLoading.value = true
    conversations.value = demoConversations
    console.log('Conversations loaded:', conversations.value)
  } catch (err) {
    console.error('Error fetching conversations:', err)
    error.value = 'Không thể tải danh sách cuộc trò chuyện. Vui lòng thử lại sau.'
  } finally {
    isLoading.value = false
  }
}

const selectConversation = (conversation) => {
  selectedConversation.value = conversation
  console.log('Selected conversation:', selectedConversation.value)
}

const sendMessage = async () => {
  if (!newMessage.value || !selectedConversation.value) return
  try {
    const newMsg = {
      id: selectedConversation.value.messages.length + 1,
      content: newMessage.value,
      is_teacher: true,
      sent_at: new Date().toISOString(),
      status: 'sent'
    }
    selectedConversation.value.messages.push(newMsg)
    selectedConversation.value.last_message = newMessage.value
    newMessage.value = ''

    // Giả lập cập nhật trạng thái tin nhắn
    setTimeout(() => {
      newMsg.status = 'delivered'
    }, 1000)

    setTimeout(() => {
      newMsg.status = 'read'
    }, 3000)

  } catch (error) {
    console.error('Error sending message:', error)
  }
}
</script>

<style scoped>
.card {
  transition: all 0.2s ease-in-out;
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
