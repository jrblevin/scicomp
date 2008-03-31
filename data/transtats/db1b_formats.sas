/**
 * db1b_formats.sas
 *
 * SAS proc format labels for the DB1B data sets.
 *
 * Jason R. Blevins <jrblevin@sdf.lonestar.org>
 * Durham, January 16, 2007
 */

/* Define value formats */
proc format;

    value geotype
        1 = 'Non-contiguous Domestic'
        2 = 'Contiguous Domestic'
        ;

    value yesno
        0 = 'No'
        1 = 'Yes'
        ;

    value distgrp
        1 = "1-500 mi."
        2 = "500-999 mi."
        3 = "1000-1499 mi."
        4 = "1500-1999 mi."
        5 = "2000-2499 mi."
        6 = "2500-2999 mi."
        7 = "3000-3499 mi."
        8 = "3500-3999 mi."
        9 = "4000-4499 mi."
        10 = "4500-4999 mi."
        11 = "5000-5499 mi."
        12 = "5500-5999 mi."
        13 = "6000-6499 mi."
        14 = "6500-6999 mi."
        15 = "7000-7499 mi."
        16 = "7500-7999 mi."
        17 = "8000-8499 mi."
        18 = "8500-8999 mi."
        19 = "9000-9499 mi."
        20 = "9500-9999 mi."
        21 = "10000-10499 mi."
        22 = "10500-10999 mi."
        23 = "11000-11499 mi."
        24 = "11500-11999 mi."
        25 = "12000+ mi."
        ;

    value $cpntype
        'A' = 'US Reporting Carrier Flying Between Two U.S. Points'
        'D' = 'US Non-Reporting Carrier Flying Within N. America Or Surface Traffic'
        'E' = 'Foreign Carrier Flying Between Two U.S. Points (Cabotage)'
        ;

run;

