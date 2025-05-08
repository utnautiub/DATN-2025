<template>
  <div>
    <h1 class="text-2xl font-bold mb-6">Quản lý người dùng</h1>

    <!-- Form to create a new user -->
    <Card class="p-6 mb-6">
      <form @submit.prevent="createUser" class="space-y-4">
        <div>
          <Label for="role">Vai trò</Label>
          <select id="role" v-model="newUser.role" required class="w-full px-4 py-2 border rounded-lg"
            @change="resetForm">
            <option value="Teacher">Giáo viên</option>
            <option value="Student">Học sinh</option>
          </select>
        </div>
        <div>
          <Label for="department_id">Khoa</Label>
          <select id="department_id" v-model="newUser.department_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="">Chọn khoa</option>
            <option v-for="department in departments" :key="department.id" :value="department.id">{{ department.name }}
            </option>
          </select>
        </div>
        <div v-if="newUser.role === 'Student'">
          <Label for="major_id">Ngành</Label>
          <select id="major_id" v-model="newUser.major_id" required class="w-full px-4 py-2 border rounded-lg">
            <option value="">Chọn ngành</option>
            <option v-for="major in filteredMajors" :key="major.id" :value="major.id">{{ major.name }}</option>
          </select>
        </div>
        <div v-if="newUser.role === 'Student'">
          <Label for="class_id">Lớp</Label>
          <select id="class_id" v-model="newUser.class_id" required class="w-full px-4 py-2 border rounded-lg">
            <option value="">Chọn lớp</option>
            <option v-for="schoolClass in classes" :key="schoolClass.id" :value="schoolClass.id">{{ schoolClass.name }}
            </option>
          </select>
        </div>
        <div v-if="newUser.role === 'Student'">
          <Label for="training_program_id">Chương trình đào tạo</Label>
          <select id="training_program_id" v-model="newUser.training_program_id" required
            class="w-full px-4 py-2 border rounded-lg">
            <option value="">Chọn chương trình đào tạo</option>
            <option v-for="program in filteredPrograms" :key="program.id" :value="program.id">{{ program.name }}
            </option>
          </select>
        </div>
        <div v-if="newUser.role === 'Teacher'">
          <Label for="subject_id">Chuyên môn</Label>
          <select id="subject_id" v-model="newUser.subject_id" required class="w-full px-4 py-2 border rounded-lg">
            <option value="">Chọn chuyên môn</option>
            <option v-for="subject in subjects" :key="subject.id" :value="subject.id">{{ subject.name }}</option>
          </select>
        </div>
        <div>
          <Label for="username">Tên đăng nhập</Label>
          <Input id="username" v-model="newUser.username" required />
        </div>
        <div>
          <Label for="password">Mật khẩu</Label>
          <Input id="password" v-model="newUser.password" type="password" required />
        </div>
        <div v-if="error" class="text-red-500 text-sm">
          {{ error }}
        </div>
        <Button type="submit" :disabled="loading">Tạo tài khoản</Button>
      </form>
    </Card>

    <!-- Users List -->
    <Card>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Tên đăng nhập</TableHead>
            <TableHead>Vai trò</TableHead>
            <TableHead>Mã</TableHead>
            <TableHead>Hành động</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="user in users" :key="user.id">
            <TableCell>{{ user.username }}</TableCell>
            <TableCell>{{ user.role }}</TableCell>
            <TableCell>
              {{ user.role === 'Student' ? user.student?.student_code : user.role === 'Teacher' ?
                user.teacher?.teacher_code : 'N/A' }}
            </TableCell>
            <TableCell>
              <Button variant="outline" @click="editUser(user)">Sửa</Button>
              <Button v-if="canDeleteUser(user)" variant="destructive" @click="deleteUser(user.id)">Xóa</Button>
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </Card>

    <!-- XLSX Import Section -->
    <Card class="p-6 mt-6">
      <h2 class="text-xl font-bold mb-4">Tạo nhanh bằng file XLSX</h2>
      <div class="space-y-4">
        <div>
          <Button @click="downloadTemplate">Tải mẫu XLSX</Button>
        </div>
        <div>
          <Label for="file-upload">Tải lên file XLSX</Label>
          <input id="file-upload" type="file" accept=".xlsx" @change="handleFileUpload"
            class="w-full px-4 py-2 border rounded-lg" />
        </div>
        <div v-if="importError" class="text-red-500 text-sm">
          {{ importError }}
        </div>
        <Button @click="importUsers" :disabled="loading || !selectedFile">Nhập dữ liệu</Button>
      </div>
    </Card>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref, computed } from 'vue';
import type { AxiosResponse } from 'axios';
import ExcelJS from 'exceljs';

interface User {
  id: number;
  username: string;
  role: string;
  school_id: number;
  student?: { student_code: string };
  teacher?: { teacher_code: string };
}

interface Department {
  id: number;
  name: string;
}

interface Major {
  id: number;
  name: string;
  department_id: number;
}

interface SchoolClass {
  id: number;
  name: string;
}

interface TrainingProgram {
  id: number;
  name: string;
  major_id: number;
}

interface Subject {
  id: number;
  name: string;
}

const { $axios } = useNuxtApp();

const users = ref<User[]>([]);
const departments = ref<Department[]>([]);
const majors = ref<Major[]>([]);
const classes = ref<SchoolClass[]>([]);
const trainingPrograms = ref<TrainingProgram[]>([]);
const subjects = ref<Subject[]>([]);
const newUser = ref<{
  role: string;
  department_id: string;
  major_id: string;
  class_id: string;
  training_program_id: string;
  subject_id: string;
  username: string;
  password: string;
}>({
  role: 'Student',
  department_id: '',
  major_id: '',
  class_id: '',
  training_program_id: '',
  subject_id: '',
  username: '',
  password: '',
});
const loading = ref<boolean>(false);
const error = ref<string>('');
const importError = ref<string>('');
const selectedFile = ref<File | null>(null);
const currentUserRole = ref<string | null>(localStorage.getItem('user_role'));

const fetchDepartments = async () => {
  try {
    const response: AxiosResponse<Department[]> = await $axios.get('/departments');
    departments.value = response.data;
  } catch (error) {
    console.error('Error fetching departments:', error);
  }
};

const fetchMajors = async () => {
  try {
    const response: AxiosResponse<Major[]> = await $axios.get('/majors');
    majors.value = response.data;
  } catch (error) {
    console.error('Error fetching majors:', error);
  }
};

const fetchClasses = async () => {
  try {
    const response: AxiosResponse<SchoolClass[]> = await $axios.get('/classes');
    classes.value = response.data;
  } catch (error) {
    console.error('Error fetching classes:', error);
  }
};

const fetchTrainingPrograms = async () => {
  try {
    const response: AxiosResponse<TrainingProgram[]> = await $axios.get('/training_programs');
    trainingPrograms.value = response.data;
  } catch (error) {
    console.error('Error fetching training programs:', error);
  }
};

const fetchSubjects = async () => {
  try {
    const response: AxiosResponse<Subject[]> = await $axios.get('/subjects');
    subjects.value = response.data;
  } catch (error) {
    console.error('Error fetching subjects:', error);
  }
};

const fetchUsers = async () => {
  try {
    const response: AxiosResponse<User[]> = await $axios.get('/users');
    users.value = response.data;
  } catch (error) {
    console.error('Error fetching users:', error);
  }
};

const filteredMajors = computed(() => {
  return majors.value.filter(major => major.department_id === Number(newUser.value.department_id));
});

const filteredPrograms = computed(() => {
  return trainingPrograms.value.filter(program => program.major_id === Number(newUser.value.major_id));
});

const resetForm = () => {
  newUser.value.department_id = '';
  newUser.value.major_id = '';
  newUser.value.class_id = '';
  newUser.value.training_program_id = '';
  newUser.value.subject_id = '';
  newUser.value.username = '';
  newUser.value.password = '';
};

const createUser = async () => {
  try {
    loading.value = true;
    error.value = '';
    const payload: any = {
      username: newUser.value.username,
      password: newUser.value.password,
      role: newUser.value.role,
    };

    if (newUser.value.role === 'Student') {
      payload.student = {
        department_id: newUser.value.department_id,
        major_id: newUser.value.major_id,
        class_id: newUser.value.class_id,
        training_program_id: newUser.value.training_program_id,
      };
    } else if (newUser.value.role === 'Teacher') {
      payload.teacher = {
        department_id: newUser.value.department_id,
        subject_id: newUser.value.subject_id, // "Chuyên môn" là môn học (subject)
      };
    }

    await $axios.post('/users', payload);
    resetForm();
    await fetchUsers();
  } catch (error: any) {
    console.error('Error creating user:', error);
    if (error.response?.data?.errors) {
      error.value = error.response.data.errors.join(', ');
    } else if (error.response?.data?.error) {
      error.value = error.response.data.error;
    } else {
      error.value = 'Không thể tạo tài khoản. Vui lòng thử lại.';
    }
  } finally {
    loading.value = false;
  }
};

const editUser = (user: User) => {
  // Placeholder for edit functionality
  console.log('Editing user:', user);
};

const canDeleteUser = (user: User) => {
  if (currentUserRole.value === 'SuperAdmin') {
    return true;
  }
  if (currentUserRole.value === 'AdminSchools' && user.role === 'AdminSchools') {
    return false;
  }
  return true;
};

const deleteUser = async (id: number) => {
  try {
    await $axios.delete(`/users/${id}`);
    await fetchUsers();
  } catch (error: any) {
    console.error('Error deleting user:', error);
    if (error.response?.data?.error) {
      error.value = error.response.data.error;
    } else {
      error.value = 'Không thể xóa tài khoản. Vui lòng thử lại.';
    }
  }
};

// ExcelJS Import Functionality
const downloadTemplate = async () => {
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet('Users');

  // Định nghĩa tiêu đề
  worksheet.columns = [
    { header: 'Role', key: 'role', width: 10 },
    { header: 'Department Name', key: 'departmentName', width: 20 },
    { header: 'Major Name (for Student)', key: 'majorName', width: 20 },
    { header: 'Class Name (for Student)', key: 'className', width: 20 },
    { header: 'Training Program Name (for Student)', key: 'programName', width: 30 },
    { header: 'Subject Name (for Teacher)', key: 'subjectName', width: 20 },
    { header: 'Username', key: 'username', width: 15 },
    { header: 'Password', key: 'password', width: 15 },
  ];

  // Thêm dữ liệu mẫu
  worksheet.addRow({
    role: 'Student',
    departmentName: 'Khoa Máy Tính',
    majorName: 'Công Nghệ Thông Tin',
    className: 'Lớp CNTT K65',
    programName: 'CNTT 2023-2027',
    subjectName: '',
    username: 'student1',
    password: 'password123',
  });
  worksheet.addRow({
    role: 'Teacher',
    departmentName: 'Khoa Máy Tính',
    majorName: '',
    className: '',
    programName: '',
    subjectName: 'Lập trình Java',
    username: 'teacher1',
    password: 'password123',
  });

  // Tạo file và tải xuống
  const buffer = await workbook.xlsx.writeBuffer();
  const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
  const url = window.URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = 'user_template.xlsx';
  link.click();
  window.URL.revokeObjectURL(url);
};

const handleFileUpload = (event: Event) => {
  const input = event.target as HTMLInputElement;
  if (input.files && input.files.length > 0) {
    selectedFile.value = input.files[0];
  }
};

const importUsers = async () => {
  if (!selectedFile.value) return;

  try {
    loading.value = true;
    importError.value = '';

    const workbook = new ExcelJS.Workbook();
    const arrayBuffer = await selectedFile.value.arrayBuffer();
    await workbook.xlsx.load(arrayBuffer);
    const worksheet = workbook.getWorksheet(1);
    const rows: any[] = [];

    worksheet.eachRow({ includeEmpty: false }, (row, rowNumber) => {
      if (rowNumber === 1) return; // Bỏ qua tiêu đề
      rows.push(row.values);
    });

    // Bỏ qua hàng tiêu đề
    const usersData = rows.slice(1);

    for (const row of usersData) {
      const [, role, departmentName, majorName, className, programName, subjectName, username, password] = row;

      // Tìm department
      const department = departments.value.find(d => d.name === departmentName);
      if (!department) {
        importError.value = `Khoa '${departmentName}' không tồn tại`;
        return;
      }

      const payload: any = {
        username,
        password,
        role,
      };

      if (role === 'Student') {
        const major = majors.value.find(m => m.name === majorName && m.department_id === department.id);
        if (!major) {
          importError.value = `Ngành '${majorName}' không tồn tại trong khoa '${departmentName}'`;
          return;
        }

        const schoolClass = classes.value.find(c => c.name === className);
        if (!schoolClass) {
          importError.value = `Lớp '${className}' không tồn tại`;
          return;
        }

        const program = trainingPrograms.value.find(p => p.name === programName && p.major_id === major.id);
        if (!program) {
          importError.value = `Chương trình đào tạo '${programName}' không tồn tại trong ngành '${majorName}'`;
          return;
        }

        payload.student = {
          department_id: department.id,
          major_id: major.id,
          class_id: schoolClass.id,
          training_program_id: program.id,
        };
      } else if (role === 'Teacher') {
        const subject = subjects.value.find(s => s.name === subjectName);
        if (!subject) {
          importError.value = `Chuyên môn (môn học) '${subjectName}' không tồn tại`;
          return;
        }

        payload.teacher = {
          department_id: department.id,
          subject_id: subject.id,
        };
      }

      await $axios.post('/users', payload);
    }

    await fetchUsers();
  } catch (error: any) {
    console.error('Error importing users:', error);
    importError.value = error.response?.data?.error || 'Không thể nhập dữ liệu. Vui lòng thử lại.';
  } finally {
    loading.value = false;
    selectedFile.value = null;
  }
};

onMounted(() => {
  fetchDepartments();
  fetchMajors();
  fetchClasses();
  fetchTrainingPrograms();
  fetchSubjects();
  fetchUsers();
});

definePageMeta({
  layout: 'admin',
});
</script>

<style scoped></style>