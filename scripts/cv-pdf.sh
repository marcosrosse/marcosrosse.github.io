#!/usr/bin/env bash
# Render the built CV (public/index.html) to a PDF with headless Chrome, using the
# site's print stylesheet. Run after `hugo`. Usage: scripts/cv-pdf.sh [public-dir]
set -euo pipefail

site="${1:-public}"
name="$(sed -n 's/^ *cvPDF *= *"\(.*\)"/\1/p' hugo.toml)"
[ -n "$name" ] || { echo "params.cvPDF is empty in hugo.toml; nothing to do" >&2; exit 0; }
out="$site/$name"

chrome="${CHROME:-}"
if [ -z "$chrome" ]; then
  for c in google-chrome google-chrome-stable chromium chromium-browser \
           "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"; do
    if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then chrome="$c"; break; fi
  done
fi
[ -n "$chrome" ] || { echo "Chrome/Chromium not found; set CHROME=/path/to/chrome" >&2; exit 1; }

# Serve over HTTP so root-relative CSS paths resolve (file:// would break them).
port="$(python3 -c 'import socket; s = socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1])')"
python3 -m http.server "$port" --bind 127.0.0.1 --directory "$site" >/dev/null 2>&1 &
server=$!
profile="$(mktemp -d)"
trap 'kill "$server" 2>/dev/null; wait "$server" 2>/dev/null || true; rm -rf "$profile"' EXIT
for _ in $(seq 50); do curl -fs -o /dev/null "http://127.0.0.1:$port/" && break; sleep 0.1; done

"$chrome" --headless=new --no-sandbox --disable-gpu --user-data-dir="$profile" \
  --no-pdf-header-footer --virtual-time-budget=5000 \
  --print-to-pdf="$out" "http://127.0.0.1:$port/" >/dev/null 2>&1

test -s "$out" || { echo "PDF was not produced: $out" >&2; exit 1; }
echo "wrote $out ($(wc -c < "$out" | tr -d ' ') bytes)"
