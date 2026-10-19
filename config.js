// 质检工作台 · 数据库连接配置
// 按 DEPLOY.md 第 1 步，在 Supabase 后台 Project Settings → API 里找到下面两项，粘贴进引号里。
// anon key 本来就是公开在网页里用的，数据由数据库的登录和行级权限保护，可以放心提交到 GitHub。
// 不要把 service_role key 填在这里。
window.QC_CONFIG = {
  supabaseUrl: 'https://reatiibptldkudhxvfdt.supabase.co/rest/v1/',      // 例如 'https://abcdefghijkl.supabase.co'
  supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJlYXRpaWJwdGxka3VkaHh2ZmR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI0MDA0ODEsImV4cCI6MjEwNzk3NjQ4MX0.8g4qUZJceh9E0k4_nKLX6ZX74zuTWsoS0dZakKyWl_o'   // 例如 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9....'
};
