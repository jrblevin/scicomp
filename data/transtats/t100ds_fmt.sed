# t100ds_fmt.sed
#
# removes the quoting and changes the delimiter to a pipe. The
# file can then be processed by a field-aware tool such as awk?
#
# Jason R. Blevins <jrblevin@sdf.lonestar.org>
# Durham, January 18, 2007
#
# Usage:
#
#    $ cat t100d_segment-1993.csv | sed -f t100ds_fmt.sed
s/\",\"/\|/g
s/\",/\|/g
s/,\"/\|/g
s/\([[:digit:]]\),/\1\|/g
s/,\([[:digit:]]\)/\|\1/g

