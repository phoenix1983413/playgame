#!/usr/bin/env bash
# 一键提交并推送：./deploy.sh "提交说明"
set -euo pipefail

cd "$(dirname "$0")"
msg="${1:-update build}"

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "未配置 origin，请先执行："
  echo "  git remote add origin git@github.com:phoenix1983413/playgame.git"
  exit 1
fi

if [[ -z "$(git status --porcelain)" ]]; then
  echo "工作区无变更，跳过提交。"
else
  git add -A
  git commit -m "$msg"
fi

git push origin main
echo "已推送。Pages 约 1-3 分钟后重新构建，CDN 缓存有效期 10 分钟。"
echo "验证：curl -sI https://phoenix1983413.github.io/playgame/ | head -1"
