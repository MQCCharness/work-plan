#!/bin/bash
cd /g/G_cursor/work-plan
lark-cli docs +fetch --api-version v2 --doc "https://ecnbxf2wq712.feishu.cn/docx/YkFJdErLeoD2AQxjUkecoq0vnwg" --scope outline > /tmp/qoutline.json 2>&1
grep -o '待办追踪[^"<]*' /tmp/qoutline.json | head -1
grep -o 'Q1[0-9] · [^"<]*' /tmp/qoutline.json | head -6
grep -o 'Q[1-9] · [^"<]*' /tmp/qoutline.json | head -3
