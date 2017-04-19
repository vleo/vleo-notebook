echo "IFS orig =${IFS}="

IFS=: read -ra arr <<< $PATH

for f in  ${arr[@]}; do echo $f; done

echo "IFS after =${IFS}="

# easier alternative
for f in $(IFS=: ; echo $PATH); do echo $f; done

