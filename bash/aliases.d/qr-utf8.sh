if hash qrencode 2>/dev/null; then
  alias qr='qrencode -t UTF8'
  qrclip() { clipboard | qr; }
fi
