#!/bin/bash

docname="$(basename $1)"
dirname="$(dirname $1)"
sitedir="."
while [ "$dirname" != "." ]; do
  dirname="$(dirname $dirname)"
  sitedir="$sitedir/.."
done

sed \
  -e '/^<body.*>$/ r body-start.html' \
  -e 's|^<title>\(.*\)</title>$|<title>chrony – \1</title>|' \
  -e '/^<link.*nodir/d' \
| sed \
  -e '/href=".*\/'$docname'.html"/s|\('$docname'.html"\)|\1 class="disabled"|' \
  -e 's|@SITEDIR@|'$sitedir'|g' \
  -e 's|@SYSCONFDIR@|/etc|g' \
  -e 's|@BINDIR@|/usr/local/bin|g' \
  -e 's|@SBINDIR@|/usr/local/sbin|g' \
  -e 's|@CHRONYSOCKDIR@|/var/run/chrony|g' \
  -e 's|@CHRONYRUNDIR@|/var/run/chrony|g' \
  -e 's|@CHRONYVARDIR@|/var/lib/chrony|g' \
  -e 's|@DEFAULT_HWCLOCK_FILE@||g' \
  -e 's|@DEFAULT_USER@|root|g'
