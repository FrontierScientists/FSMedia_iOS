#!/bin/bash

## Aaron Andrews
## 6/4/14
## 
## This script is to be run as a chronjob, 
## and converts .sql files into .xml files 
## so that the Frontier Scientists iPhone 
## app can parse the .xml files for its data

PATH=$PATH:/usr/local/mysql/bin/
export PATH

for f in *.sql;
do
    echo "editing $f, "
    mysql -u root sqlTest < "$f"
#sqlTest is the name of the folder, and can be changed as needed.
#Also, this line converts the tables from the database into xml files
    mysql -u root --xml -e 'SELECT * FROM sqlTest.'${f%.*}'' > "${f%.*}".xml
done

echo "Done"
exit 0 # Must have this or the script won't catch the exit code! (It will just hang)
