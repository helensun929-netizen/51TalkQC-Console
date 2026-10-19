// 质检工作台 · 数据库连接配置
// 按 DEPLOY.md 第 1 步，在 Supabase 后台 Project Settings → API 里找到下面两项，粘贴进引号里。
// anon key 本来就是公开在网页里用的，数据由数据库的登录和行级权限保护，可以放心提交到 GitHub。
// 不要把 service_role key 填在这里。
window.QC_CONFIG = {
  supabaseUrl: '',      // 例如 'https://abcdefghijkl.supabase.co'
  supabaseAnonKey: ''   // 例如 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9....'
};
