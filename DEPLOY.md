# 部署步骤 · 师资运营工作台

整体约 20 分钟，分三段：建数据库 → 发布网页 → 初始化数据。

```mermaid
flowchart LR
  A[1 注册 Supabase<br/>新建项目] --> B[2 运行 setup.sql] --> C[3 设置登录方式] --> D[4 填 config.js]
  D --> E[5 上传到 GitHub] --> F[6 开启 Pages] --> G[7 注册管理员] --> H[8 初始化数据]
```

---

## 第一段：建数据库（Supabase）

### 1. 新建项目
1. 打开 https://supabase.com ，用 GitHub 账号登录。
2. 点 **New project**：
   - Name：`qc-workbench`
   - Database Password：点 Generate 生成并自己保存好
   - Region：选 **Northeast Asia (Tokyo)** 或 **Southeast Asia (Singapore)**，国内访问更快
3. 等 1–2 分钟项目创建完成。

### 2. 运行初始化脚本
1. 左侧菜单 **SQL Editor** → **New query**。
2. 复制初始化脚本，粘贴进去，点 **Run**。脚本可以用以下任一方式拿到：
   - 用文件包里的 `setup-复制到Supabase.txt`（双击即可用文本编辑打开），全选复制；
   - 或者先完成第 5 步上传到 GitHub，在仓库网页里点开 `supabase/setup.sql`，点右上角的 **复制**（Copy raw file）按钮。
3. 看到 `Success. No rows returned` 即完成。脚本可以重复运行，不会删数据。

### 3. 设置登录方式
左侧 **Authentication** → **Sign In / Providers**（旧版叫 Providers）：
- **Email** 保持开启。
- 内部使用建议关闭 **Confirm email**，同事注册后可以直接登录，不用去邮箱点链接。（保留开启也可以，只是多一步确认邮件。）

**Authentication → URL Configuration**：
- **Site URL** 填之后的网页地址，例如 `https://你的GitHub用户名.github.io/qc-workbench/`

### 4. 拿到连接信息，填进 config.js
左侧 **Project Settings → API**（或 **Data API**）：
- 复制 **Project URL**
- 复制 **anon public** key（不是 service_role）

先把这两项记下来。等第 5 步上传到 GitHub 后，直接在网页上改：仓库里点开 `config.js` → 右上角铅笔图标（Edit this file）→ 把两项粘贴进引号 → **Commit changes**。不需要在电脑上打开文件。填好后是这样：

```js
window.QC_CONFIG = {
  supabaseUrl: 'https://xxxxxxxx.supabase.co',
  supabaseAnonKey: 'eyJhbGciOi...'
};
```

---

## 第二段：发布网页（GitHub Pages）

### 5. 新建仓库并上传文件
1. GitHub 右上角 **+ → New repository**，名称 `qc-workbench`，选 **Public**，点 Create。
2. 在新仓库页面点 **uploading an existing file**，把以下文件和文件夹拖进去：
   `index.html`、`config.js`、`README.md`、`DEPLOY.md`、`supabase/` 文件夹
3. 点 **Commit changes**。

> 免费版 GitHub Pages 要求仓库公开。仓库里只有代码，没有业务数据，也不含质检标准内容。

### 5+. 把两个组件放进仓库（推荐，国内同事打开更稳）
网页要用两个公开的程序组件：数据库组件 `supabase.min.js` 和表格组件 `xlsx.full.min.js`。仓库里没有时，网页会依次去国内镜像、海外 CDN 下载，部分公司网络会全部拦截，同事就会看到「数据库组件加载失败」。把它们放进仓库后，只要能打开网页就能加载。

1. 用你自己的 Chrome 打开下面两个链接，每打开一个按 **Cmd + S**（Windows 按 Ctrl + S）保存，文件名保持不变：
   - https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4/dist/umd/supabase.min.js
   - https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js
2. 在电脑上新建一个叫 `vendor` 的文件夹，把这两个文件放进去。
3. 仓库首页 → **Add file → Upload files** → 把整个 `vendor` 文件夹拖进去 → **Commit changes**。
4. 上传后仓库里应该有 `vendor/supabase.min.js` 和 `vendor/xlsx.full.min.js`。


### 6. 开启 Pages
仓库 **Settings → Pages**：
- Source：**Deploy from a branch**
- Branch：**main**，文件夹 **/ (root)**，点 Save

1–2 分钟后页面顶部会显示网址：`https://你的用户名.github.io/qc-workbench/`

---

## 第三段：初始化数据

### 7. 注册管理员
打开网址 → **注册** → 填姓名、工作邮箱、密码。**第一个注册的账号自动成为管理员**，所以请你自己先注册。

### 8. 按顺序完成初始化

| 顺序 | 位置 | 操作 |
|---|---|---|
| ① | 课堂质检 → 标准库 → 体验课 → 上传新版 Excel | 上传《单词2.2体验课课程质量检验标准》，填说明，保存 |
| ② | 课堂质检 → 标准库 → 正课 → 上传新版 Excel | 上传《单词2.2正课 评价标准细则》，填说明，保存 |
| ③ | 导入 → 教练信息 | 上传教练信息表（如「薪资信息」导出表），确认列对应后导入 |
| ④ | 导入 → 退费明细 | 上传退费明细，确认「体验课教练ID」「正课教练ID」「退费前第几次课」三列对应正确，再在「高退费判定」里选择计入哪类教练 |
| ⑤ | 投诉管理 → 处罚规则 → 导入规则 Excel | 上传《投诉处罚规则-导入用.xlsx》，确认后点「保存规则」 |
| ⑤-2 | 投诉管理 → 导入 | 上传投诉总表；已判定过「是否属实」的作为历史记录，新投诉生成待发通知 |
| ⑤-3 | 教练档案 → 标签设置 | 确认画像标签的下拉选项 |
| ⑥ | 把网址发给同事注册 | 同事注册后为「待审核」 |
| ⑦ | 导入 → 成员权限 | 给同事分配：管理员 / 质检专员 / 只读 |
| ⑧ | 任务中心 → 派发设置 | 添加质检专员、设每日上限、确认规则，勾选「自动派发」并保存 |

完成后，第二天起系统每天自动派发质检任务。

---

## 日常维护

**更新网页**（拿到新版 `index.html` 时）：
1. 打开 GitHub 仓库首页 → 点右上角 **Add file** → **Upload files**。
2. 把新的 `index.html` 拖进去（同名文件会直接覆盖），需要时把新的 `README.md`、`DEPLOY.md` 一起拖进去。
3. 拉到底部点 **Commit changes**。
4. 等 1–2 分钟，打开工作台按 **Cmd + Shift + R**（Windows 按 Ctrl + F5）强制刷新。
`config.js` 不要上传、不用动；数据库里的数据也不受影响。

**备份数据**：Supabase 后台 **Table Editor → docs → Export → CSV**，建议每月导出一次。

**免费额度**：Supabase 免费版 500MB 数据库，足够本工作台使用多年。项目连续 7 天无人访问会被暂停，在后台点 Restore 即可恢复；正常每天使用不会触发。

**忘记密码**：管理员可在 Supabase 后台 **Authentication → Users** 找到该用户，发送重置密码邮件或删除后让其重新注册（重新注册后需再次分配角色）。

---

## 常见问题

| 现象 | 原因与处理 |
|---|---|
| 打开显示「还没有配置数据库」 | `config.js` 没填或填错，检查 URL 和 anon key |
| 注册后一直显示「等待管理员开通」 | 正常，管理员在「导入 → 成员权限」分配角色后刷新 |
| 保存时提示「只有查看权限」 | 当前账号是只读或待审核，请管理员调整角色 |
| 打开显示「数据库组件加载失败」 | 同事的网络拦截了 CDN。按第 5+ 步把两个组件放进仓库的 `vendor` 文件夹；临时也可以换手机热点打开 |
| 上传 Excel 提示组件加载失败 | 同上，`vendor/xlsx.full.min.js` 放进仓库后即可 |
| 别人的修改没有马上出现 | 实时同步未开启：重新运行一次 `setup.sql` 最后一段 |
| 国内打开慢 | GitHub Pages 和 Supabase 都在境外；如需更稳定，可以后续迁到国内托管 |

---

## 从 claude.ai 版本迁移

claude.ai 版本里的数据不会自动带过来：
- 教练名单、退费明细：用原 Excel 在新版本里重新导入即可。
- 质检标准：按第 8 步上传两份标准表。
- 已有的质检记录、任务、工单：如需迁移，可以导出 CSV 后联系维护人处理。
