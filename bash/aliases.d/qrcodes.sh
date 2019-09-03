if iscommand qrencode; then
  # encode stdin and clipboard to qrcode on terminal
  alias qr='qrencode -t UTF8'
  qrclip() { clipboard | qrencode -t UTF8; }
fi

if iscommand zbarcam; then
  # read qr and barcodes with webcam silently
  qrread() { zbarcam --raw --nodisplay; }
fi
