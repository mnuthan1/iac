vagrant up k8s-master
if [ $? -eq 0 ];
then
    vagrant status | grep -v k8s-master | \
    awk '
    BEGIN{ tog=0; }
    /^$/{ tog=!tog; }
    /./ { if(tog){print $1} }
    ' | \
    xargs -P3 -I {} vagrant up {}
fi