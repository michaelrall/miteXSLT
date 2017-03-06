#!/bin/bash

BASE_URL=https://johndebug.mite.yo.lk
USER=john@debug.de
PASS=jonny123
CUSTOMER_ID=12345

#curl -u $USER:$PASS -o customers.xml "$BASE_URL/customers.xml"

curl -u $USER:$PASS -o customer.xml "$BASE_URL/customers/$CUSTOMER_ID.xml"
curl -u $USER:$PASS -o entries.xml "$BASE_URL/time_entries.xml?customer_id=$CUSTOMER_ID&at=last_month"
xsltproc -o entries.xml entries_sort.xsl entries.xml
xsltproc -o stundenliste.html entries_format.xsl entries.xml
wkhtmltopdf stundenliste.html stundenliste.pdf

rm entries.xml
rm customer.xml
rm stundenliste.html
