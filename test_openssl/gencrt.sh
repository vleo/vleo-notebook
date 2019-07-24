~/local/ssl/bin/openssl genpkey -engine gost -out user_gost.key -algorithm gost2012_512 -pkeyopt paramset:A
~/local/ssl/bin/openssl req -engine gost -new -key user_gost.key -out user_gost.csr -subj "/C=RU/ST=Russia/L=Moscow/O=LML/OU=TWA/CN=vleolml@mail.ru"
~/local/ssl/bin/openssl x509 -engine gost -req -CA gost.crt -CAkey gost.key -in user_gost.csr -out user_gost.crt -CAcreateserial
