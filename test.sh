wget -c https://www.cl.cam.ac.uk/~mgk25/ucs/keysymdef.h
SRC="node-keysym/data/keysyms.txt"
DST="out.h"
TMPL0=template0.txt
TMPL1=template1.txt
TMPL2=template2.txt
TMPL3=template3.txt
CLOSE="};"
KEYSYM=keysymdef.h

>$TMPL1
>$TMPL2
cat $TMPL0 > $DST
set -x
while read line
do

  if [[ $line =~ ^#.* ]] # ignore comments
  then
    echo "comment ignored"
  else
    if [ "$line" != "" ] # ignore whitespaces
    then
      third=`echo $line | awk {' print $3 '}`
      if [ "$third" != "d" ]            # ignore lines marked with 'd' sym.
      then
        utfcode=`echo $line | awk {' print $1 '}` 
        xsymcode=`echo $line | awk {' print $5 '}`
        symcode="XK_${xsymcode}"
        tst=`grep "define $symcode " $KEYSYM`
        if [ "$tst" != "" ]
        then
          echo "        ${utfcode}," >> $TMPL1
          echo "        ${symcode}," >> $TMPL2
        fi
      fi
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

