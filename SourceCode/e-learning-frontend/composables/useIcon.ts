import * as lucideIcons from 'lucide-vue-next'

export function useIcon() {
  /**
   * Lấy icon từ thư viện lucide-vue-next
   * @param name Tên icon trong Lucide (ví dụ: 'sun', 'moon', 'laptop')
   * @returns Lucide icon component
   */
  const getLucideIcon = (name: string) => {
    // Chuyển đổi tên icon thành PascalCase theo quy ước Lucide
    const pascalCaseName = name.charAt(0).toUpperCase() + name.slice(1)
    return (lucideIcons as any)[pascalCaseName] || null
  }

  return {
    getLucideIcon
  }
} 