#!/bin/sh
HOST0_LIST="/tmp/hosts0"
WHITE_LIST=${0%.*}.whitelist

TMP_DIR="/tmp/hosts0.d"

logger Starting adv blocking script at $(date)
if [ -e $TMP_DIR ]; then
    rm -rf $TMP_DIR
fi

mkdir -p $TMP_DIR

let i=0
for URL in "http://winhelp2002.mvps.org/hosts.txt" \
           "https://adaway.org/hosts.txt" \
           "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts" \
           "https://someonewhocares.org/hosts/zero/hosts" \
           "http://www.hostsfile.org/downloads/hosts.txt" ; do
    logger Downloading list: $URL ...
    curl -k $URL >> $TMP_DIR/$i
    if [ $? -eq 0 ]; then 
        logger found $(cat $TMP_DIR/$i | wc -l) hosts
        cat $TMP_DIR/$i | sed -e '/localhost/d;
            /^[[:space:]]*#/d;
            s/[[:space:]]*#.*$//g;' | awk '{print $2}' >> $TMP_DIR/just-hosts
        rm $TMP_DIR/$i
    else 
        logger Failed
    fi
    let i=i+1
done

logger Lists cleaned with  $(cat $TMP_DIR/just-hosts | wc -l) hosts
sort -u $TMP_DIR/just-hosts -o $TMP_DIR/uniq-hosts
logger Lists after dups removal contains $(cat $TMP_DIR/uniq-hosts | wc -l) hosts

logger Searching for whitelist file: $WHITE_LIST ...
if [ -s $WHITE_LIST ]; then
    logger Removing n $(cat $WHITE_LIST | wc -l) by $WHITE_LIST
    grep -F -v -f $WHITE_LIST $TMP_DIR/uniq-hosts > $TMP_DIR/whitelisted
    logger Lists whitelisted with $(cat $TMP_DIR/whitelisted | wc -l) hosts
    rm $TMP_DIR/uniq-hosts
    mv $TMP_DIR/whitelisted $TMP_DIR/uniq-hosts
fi

if [ -s $HOST0_LIST ]; then
    rm $HOST0_LIST
fi

cat $TMP_DIR/uniq-hosts | sed -e '/^$/d' | awk '{print "0.0.0.0\t"$1}' > $HOST0_LIST

logger Adding n $(cat $HOST0_LIST | wc -l) blocked dns to $HOST0_LIST

grep -q addn-hosts /tmp/dnsmasq.conf ||
        echo "addn-hosts=/tmp/hosts0" >>/tmp/dnsmasq.conf
logger Restarting dnsmasq
killall dnsmasq
dnsmasq --conf-file=/tmp/dnsmasq.conf

if [ -e $TMP_DIR ]; then
    rm -rf $TMP_DIR
fi

logger Script adv blocking done at $(date)
