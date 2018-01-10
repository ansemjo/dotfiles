# if boost is not installed we want backblaze to use b2
if iscommand backblaze-b2; then

  # use 'blaze' either way
  alias blaze=backblaze-b2

  # if b2 is unused, use that too
  iscommand b2 || alias b2=backblaze-b2

fi
