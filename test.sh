
SRC="node-keysym/data/keysyms.txt"
DST="out.h"
TMPL0=template0.txt
TMPL1=template1.txt
TMPL2=template2.txt
TMPL3=template3.txt
CLOSE="};"
>$TMPL1
>$TMPL2
cat $TMPL0 > $DST
set -x
while read line
do

  if [[ $line =~ ^#.* ]]
  then
    echo "comment ignored"
  else
    if [ "$line" != "" ]
    then
       utfcode=`echo $line | awk {' print $1 '}` 
       xsymcode=`echo $line | awk {' print $5 '}`
       echo "        ${utfcode}," >> $TMPL1
       echo "        XK_${xsymcode}," >> $TMPL2
    fi
  fi
  
done < $SRC
sed -i '$s/,//g' $TMPL1
sed -i '$s/,//g' $TMPL2

cat $TMPL1 >> $DST
echo $CLOSE >> $DST

cat $TMPL3 >> $DST
cat $TMPL2 >> $DST

echo $CLOSE >> $DST

