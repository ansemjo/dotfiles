# generate crypt(3) compatible passwords with python
mkpasswd-sha512() {
  python -c 'import getpass as g; import crypt as c; p = g.getpass("Enter password: "); print(c.crypt(p, c.METHOD_SHA512) if p == g.getpass("Repeat password: ") else "Passwords do not match.")';
}
