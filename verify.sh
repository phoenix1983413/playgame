#!/usr/bin/env bash
# 部署后验证：./verify.sh [base_url]
set -uo pipefail

cd "$(dirname "$0")"
base="${1:-https://phoenix1983413.github.io/playgame}"
base="${base%/}"
local_size=$(wc -c < index.html | tr -d ' ')
tmp=$(mktemp -t playgame_verify.XXXXXX); trap 'rm -f "$tmp"' EXIT
pass=0; fail=0

chk() { if [ "$2" = "1" ]; then echo "  PASS  $1"; pass=$((pass+1)); else echo "  FAIL  $1"; fail=$((fail+1)); fi; }

echo "目标：$base/"
echo

echo "[1] 入口页（带末尾斜杠）"
read -r code ctype < <(curl -sS -o /dev/null --max-time 30 -w '%{http_code} %{content_type}' "$base/")
echo "  status=$code  content-type=$ctype"
chk "HTTP 200" "$([ "$code" = "200" ] && echo 1)"
chk "Content-Type 为 text/html" "$(printf '%s' "$ctype" | grep -q 'text/html' && echo 1)"

echo
echo "[2] 不带末尾斜杠（分享出去的链接通常长这样）"
read -r code2 loc2 < <(curl -sS -o /dev/null --max-time 30 -w '%{http_code} %{redirect_url}' "$base")
echo "  status=$code2  redirect=${loc2:-（无）}"
if [ "$code2" = "200" ]; then
  chk "直接返回 200（服务端自行处理）" 1
else
  chk "30x 跳转到 $base/" "$(printf '%s' "$loc2" | grep -q "$base/" && echo 1)"
fi

echo
echo "[3] 内容完整性（防止 CDN / Jekyll 改动或截断）"
curl -sS --compressed --max-time 60 -o "$tmp" "$base/"
remote_size=$(wc -c < "$tmp" | tr -d ' ')
echo "  本地=$local_size  远端=$remote_size"
chk "字节数一致" "$([ "$remote_size" = "$local_size" ] && echo 1)"

echo
echo "[4] 关键标记"
chk "标题为 几猫3A大作" "$(grep -q '<title>几猫3A大作</title>' "$tmp" && echo 1)"
chk "WebGL 画布 #view 存在" "$(grep -q 'id="view"' "$tmp" && echo 1)"
chk "内联脚本已完整下发（结尾为 </html>）" "$(tail -c 200 "$tmp" | grep -q '</html>' && echo 1)"

echo
echo "[5] 传输表现"
curl -sS -o /dev/null --compressed --max-time 60 \
  -w '  compressed_download=%{size_download} bytes  time=%{time_total}s  http=%{http_version}\n' "$base/"

echo
echo "结果：$pass 通过 / $fail 失败"
echo
echo "浏览器侧仍需人工确认（打开 $base/ 后）："
echo '  · Console 无红色报错；'
echo '  · 控制台执行 window.__ready 应为 true、window.__frames > 0；'
echo '  · window.__errors 为空数组；'
echo '  · 能进入标题页 → 开始行动 → 鼠标被捕获（Esc 释放）。'
[ "$fail" = "0" ]
