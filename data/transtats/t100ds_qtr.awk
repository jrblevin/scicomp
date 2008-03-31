# t100ds_qtr.awk
#
# The following awk? script aggregates a (monthly) T100 Domestic
# Segment dataset to the quarter level for matching with other
# quarterly datasets such as the Airline Origin and Destination
# Survey. This script presumes that the file that has already been
# processed into separate fields (for example, by using by the
# t100ds_fmt.sed script). Only departures scheduled, departures
# performed, seats, and passengers are aggregated, but adding
# additional variables is straightforward.
#
# Usage:
# 
#     $ cat t100d_segment-1993.csv | sed -f t100ds_fmt.sed | awk -F\| -f t100ds_qtr.awk
#
# Example output:
#
#     SFO DFW AA 4 728 709 128723 77447
#     CMH FAR NW 3 1 1 100 81
#     BOS MCO DL 3 276 276 48546 42182
#     DTW MKE TW 2 2 2 268 52
#     DFW OMA AA 2 364 361 51237 28839
#     IND BNA AA 1 168 165 16003 8250
#     SJC BUR QQ 4 89 88 12320 2439
#
# Jason R. Blevins <jrblevin@sdf.lonestar.org>
# Durham, January 18, 2007
BEGIN {
}
NR > 1 {                                          # Strip headers
# origin dest carrier quarter distance dep_sched dep_perf seats passengers
    origin=$4;
    dest=$11;
    carrier=$23;
    quarter=$2;
    distance=$27;
    dep_sched=$33;
    dep_perf=$34;
    seats=$36;
    passengers=$37;

    odcq_dep_sched[origin " " dest " " carrier " " quarter]+=dep_sched;
    odcq_dep_perf[origin " " dest " " carrier " " quarter]+=dep_perf;
    odcq_seats[origin " " dest " " carrier " " quarter]+=seats;
    odcq_passengers[origin " " dest " " carrier " " quarter]+=passengers;
}
END {
    for (i in odcq_dep_sched) {
        print i, odcq_dep_sched[i], odcq_dep_perf[i], odcq_seats[i], odcq_passengers[i];
    }
}

