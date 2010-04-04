#!/usr/bin/perl

# Parses Rust's (1987) bus engine replacement data files and generates a
# panel dataset with a single row for each replacement.
#
# Copyright (C) 2008 Jason Blevins <jrblevin@sdf.lonestar.org>
# All rights reserved.
#
# This software may be modified and distributed under the terms
# of the BSD license.  See the LICENSE file for details.
#
# Durham, May 7, 2008

sub parse_file {
    my ($filename, $group, $make, $model, $n_bus, $n_month) = @_;

    open DATA, "< $filename";

    for (1..$n_bus) {
        # Read the 11 header lines for each bus.
        my @lines = ();
        for (1..11) {
            my $line = <DATA>;
            $line =~ s/^\s+|\s+$//g;   # Remove whitespace
            push @lines, $line;
        }

        # Store each element in a named variable
        my ($num, $purchase_mo, $purchase_yr, $month1, $year1, $miles1,
            $month2, $year2, $miles2, $month0, $year0) = @lines;

        # Indicate missing values
        $miles1 = '.' if ($year1 == 0);
        $miles2 = '.' if ($year2 == 0);

        # Print the first replacement
        printf "%8d %8d %8s %8s %8s\n",
          $group, $num, $make, $model, $miles1;

        # Print the second replacement if there was a first
        printf "%8d %8d %8s %8s %8s\n",
          $group, $num, $make, $model, $miles2 if ($year1 > 0);

        for (1..$n_month) {
            my $mileage = <DATA>;
        }
    }

    close DATA;
}

# Print column names
printf "%8s %8s %8s %8s %8s\n",
  "group", "number", "make", "model", "miles";

# Parse and print each data file
parse_file("g870.asc", 1, "Grumman", "870", 15, 25);
parse_file("rt50.asc", 2, "Chance", "RT50", 4, 49);
parse_file("t8h203.asc", 3, "GMC", "T8H203", 48, 70);
parse_file("a530875.asc", 4, "GMC", "A5308", 37, 117);
parse_file("a530874.asc", 5, "GMC", "A5308", 12, 126);
parse_file("a452374.asc", 6, "GMC", "A4523", 10, 126);
parse_file("a530872.asc", 7, "GMC", "A5308", 18, 126);
parse_file("a452372.asc", 8, "GMC", "A4523", 18, 126);
