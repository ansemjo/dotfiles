if iscommand qrencode; then
  alias qr='qrencode -t UTF8'
  qrclip() { clipboard | qrencode -t UTF8; }
fi

if iscommand zbarcam; then
  qrread() { zbarcam --raw --nodisplay; }
fi
