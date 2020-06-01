vagrant up k8s-master

vagrant status | \
awk '
BEGIN{ tog=0; }
/^$/{ tog=!tog; }
/./ { if(tog){print $1} }
' | \
xargs -P2 -I {} vagrant up {}