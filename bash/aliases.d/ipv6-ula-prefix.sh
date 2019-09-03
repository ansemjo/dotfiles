# generate ula prefix
# https://gist.githubusercontent.com/ansemjo/40667dd9ee072107ae75000d047a89a0/raw/
if iscommand node; then
ipv6prefix() {
cat <<'SCRIPT' | node - "$*"
#!/usr/bin/env node
/* generate a unique local address prefix */
/* usage: `node prefix.js 56`, where 56 can be replaced by any prefix length between 8 and 128 */

/* alternatively, a simple one-liner for a /48 ula prefix:
 *  node -pe "('fd' + crypto.randomBytes(5).toString('hex')).match(/.{1,4}/g).join(':') + '::/48'"
 */

/* iife-wrapped prefix generator */
console.log((function prefix() {

  /* get n random bytes */
  let b = n => require('crypto').randomBytes(n);

  /* get desired prefix length from commandline */
  let p = process.argv.find(e => e.match(/^[\d]+$/)) || 48;

  /* last byte index required */
  let l = Math.floor(p/8);

  /* necessary bitshift */
  let s = 8 - p % 8;

  /* generate random ula prefix */         
  let a = b(16)
    /* first byte = fd */
    .fill(253, 0, 1)
    /* zero bytes */
    .fill(0, l) 
    /* shift last byte */
    .fill(b(1).readUInt8() << s,l,Math.min(16, l+1));

  /* format as ipv6 string */
  let f = (b, p) => b.toString('hex').match(/.{1,4}/g)
    .join(':').replace(/(:0000)+$/,'::') + `/${p}`;

  return f(a, p);

})());
SCRIPT
}
fi
