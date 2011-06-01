
echo "squeamish ossifrage" | ./rsa.pl -k=10001 -n=1967cb529 > msg.rsa
./rsa.pl -d -k=ac363601 -n=1967cb529 < msg.rsa
