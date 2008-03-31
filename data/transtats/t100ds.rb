#! /usr/bin/ruby
#
# Loads and processes a T100 Domestic Segment CSV file from Transtats.
#
# Usage: ruby t100ds.rb t100ds_2005.csv
#
# Jason R. Blevins <jrblevin@sdf.lonestar.org>,
# Durham, February 19, 2007

require 'csv'

# Take the filename as a command-line argument
filename = ARGV[0]

# Initialize counters
count = 0

# Process the CSV file row by row
CSV.open(filename, 'r') do |row|
  count += 1                         # Count rows
  next if (count == 1)               # Skip the header

  # Construct a hash with the row information
  entry = {
    :year                 => row[0].to_i,
    :quarter              => row[1].to_i,
    :month                => row[2].to_i,
    :origin               => row[3],
    :dest                 => row[10],
    :carrier              => row[22],
    :distance             => row[26].to_i,
    :distance_group       => row[27].to_i,
    :service_class        => row[28],
    :aircraft             => row[30].to_i,
    :aircraft_config      => row[31].to_i,
    :departures_scheduled => row[32].to_i,
    :departures_performed => row[33].to_i,
    :payload              => row[34].to_i,
    :seats                => row[35].to_i,
    :passengers           => row[36].to_i,
    :freight              => row[37].to_i,
    :mail                 => row[38].to_i,
    :ramp_to_ramp         => row[39].to_i,
    :air_time             => row[40].to_i
  }

  # Process the entry hash here
  # ...

end

puts "Read #{count} rows"
