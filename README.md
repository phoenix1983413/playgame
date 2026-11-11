# 几猫 3A 大作 · GitHub Pages

《几猫》第一人称射击游戏 Web 版，单文件 WebGL2 构建，通过 GitHub Pages 托管。

- 在线地址：<https://phoenix1983413.github.io/playgame/>
- 本地文件：`index.html`（1.42 MB，零外部依赖、零图片、零音频文件）

## 仓库结构

```
.
├── index.html    # 游戏本体（由 几猫国产3A大作_V1.html 重命名而来，内容未改动）
├── 404.html      # 项目站点自定义 404，指回 /playgame/
├── .nojekyll     # 跳过 Jekyll 处理，保证原样发布
└── README.md
```

这是 **project site**（项目站点）。仓库名 `playgame` 直接决定 URL 路径 `/playgame/`，
所以仓库名必须与目标路径一致，不能改名。

## 本地预览

> 必须通过 http(s) 访问。直接双击 `file://` 打开会因安全上下文限制导致
> Pointer Lock、Web Audio 不可用，鼠标视角会退化为拖拽模式。

```bash
python3 -m http.server 8138
# 打开 http://127.0.0.1:8138/index.html
```

## 部署

首次：

```bash
git remote add origin git@github.com:phoenix1983413/playgame.git
git push -u origin main
```

之后更新：

```bash
cp "../几猫国产3A大作_V2.html" index.html   # 或替换为新构建产物
./deploy.sh "更新到 V2"
```

推送后到仓库 **Settings → Pages**，Source 选 `Deploy from a branch`，
Branch 选 `main`、目录选 `/ (root)`，保存。首次发布通常 1–3 分钟生效。

## 更新版本时注意

- 文件名始终保持 `index.html`，不要使用中文或带空格的文件名
- 单文件上限 100 MB、站点上限 1 GB，当前体积远低于限制
- Pages CDN 缓存 `max-age=600`，更新后最多 10 分钟才能看到新内容，属正常现象
- HTML 由 GitHub CDN 自动 gzip，实际传输约 300 KB

## 技术前置条件

浏览器需支持 WebGL2（Chrome 90+ / Safari 15+ / Edge 90+）。
页面加载完成后 `window.__ready === true`，可用于自动化验证。
