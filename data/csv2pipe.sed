s/\",\"/\|/g
s/\",/\|/g
s/,\"/\|/g
s/\([[:digit:]]\),/\1\|/g
s/,\([[:digit:]]\)/\|\1/g
s/,,/||/g
s/|,$/||/g
s/"$//g
s/\([[:alpha:]]\),\([[:alpha:]]\)/\1\|\2/g