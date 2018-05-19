#!/bin/bash

ipset="whitelist"
fwcmd="/usr/bin/firewall-cmd"
gdocurl="/opt/fwdgdoc/etc/whitelist.gdoc"
tmpfile="/var/tmp/fw.whitelist.tmp"
xmlfile="/etc/firewalld/ipsets/${ipset}.xml"
fwreload=0

if [[ ! -x ${fwcmd} ]]; then
  echo "Error: ${fwcmd} not found."
  exit 1
fi

if [[ ! -f ${gdocurl} ]]; then
  echo "Error: ${gdocurl} not found."
  exit 1
fi

curl -s `cat ${gdocurl}` > ${tmpfile}.1

if [[ -z `head -1 ${tmpfile}.1 | grep -i ${ipset}` ]]; then
  echo "Error: ${ipset} not found in header." 
  exit 1
fi

if [[ ! -f ${xmlfile} ]]; then
  cmd="${fwcmd} --permanent --new-ipset=whitelist --type=hash:ip"
  echo ${cmd}" "; ${cmd}
  cmd="${fwcmd} --permanent --add-rich-rule='rule source ipset=whitelist service name=ssh accept'"
  echo ${cmd}" "; ${cmd}
  cmd="${fwcmd} --permanent --remove-service ssh"
  echo ${cmd}" "; ${cmd}
  fwreload=1
fi

cat ${tmpfile}.1 \
  | cut -d',' -f1 \
  | egrep -v '[a-zA-Z]' \
  | sort > ${tmpfile}.2

cat ${xmlfile} \
  | grep 'entry' \
  | awk -F'>' '{print $2}' \
  | awk -F'<' '{print $1}' \
  | sort > ${tmpfile}.3

for ipaddr in `diff ${tmpfile}.2 ${tmpfile}.3 \
  | egrep '<|\>' | sed 's/ /,/g'`; do

  if [[ -n `echo ${ipaddr} | cut -c1 | grep '<'` ]]; then
    ipaddr=`echo ${ipaddr} | cut -c3-`
    cmd="${fwcmd} --permanent --ipset=${ipset} --add-entry=${ipaddr}"
    echo ${cmd}" "; ${cmd}
    fwreload=1
  fi

  if [[ -n `echo ${ipaddr} | cut -c1 | grep '>'` ]]; then
    ipaddr=`echo ${ipaddr} | cut -c3-`
    cmd="${fwcmd} --permanent --ipset=${ipset} --remove-entry=${ipaddr}"
    echo ${cmd}" "; ${cmd}
    fwreload=1
  fi

done

if [[ ${fwreload} -gt 0 ]]; then
  cmd="${fwcmd} --reload"
  echo ${cmd}" "; ${cmd}
fi

rm -f ${tmpfile}.*
    
exit 0

