if iscommand qrencode; then
  alias qr='qrencode -t UTF8'
  qrclip() { clipboard | qr; }
fi

if iscommand zbarcam; then
  qrread() { zbarcam --raw; }
fi
