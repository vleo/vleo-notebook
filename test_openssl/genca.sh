~/local/ssl/bin/openssl genpkey -engine gost -out gost.key -algorithm gost2012_512 -pkeyopt paramset:A
~/local/ssl/bin/openssl asn1parse -in gost.key
~/local/ssl/bin/openssl pkey -engine gost -in gost.key -noout -text
~/local/ssl/bin/openssl pkey -engine gost -in gost.key -outform DER -out gost_key.der
dumpasn1 gost_key.der
~/local/ssl/bin/openssl rand -writerand ~/.rng
~/local/ssl/bin/openssl req -engine gost -new -x509 -days 3650 -key gost.key -out gost.crt -subj "/C=RU/ST=Russia/L=Moscow/O=SuperPlat/OU=SuperPlat CA/CN=SuperPlat CA Root"
