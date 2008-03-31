/**
 * process_t100.sas
 * SAS macro to load raw T100 Domestic Segment data.
 *
 * Jason R. Blevins <jrblevin@sdf.lonestar.org>
 * Durham, January 16, 2007
 *
 * This script processes a T100 Domestic Segment data set, storing 
 * the variables as efficiently as possible by using the attrib statement
 * to declare the data types.
 *
 * This SAS code is designed to be used within a DATA step to assist in
 * naming the variables and setting the proper data types. Example:
 *
 *    filename t100ds 't100d_segment-1993.csv';
 *
 *    data t100ds;
 *        infile t100ds dsd firstobs=2 lrecl=8192;
 *
 *        %include 'process_t100ds.sas';
 * 
 *        keep
 *            year quarter month origin dest unique_carrier distance
 *            departures_performed seats passengers
 *            ;
 *    run;
 */

    attrib
        year                   length=3    label=''
        quarter                length=3    label=''
        month                  length=3    label=''
        origin                 length=$3   label=''
        origin_city_name       length=$40  label=''
        origin_city_num        length=4    label=''
        origin_state_abr       length=$2   label=''
        origin_state_fips      length=4    label=''
        origin_state_name      length=$40  label=''
        origin_wac             length=3    label=''
        dest                   length=$3   label=''
        dest_city_name         length=$40  label=''
        dest_city_num          length=4    label=''
        dest_state_abr         length=$2   label=''
        dest_state_fips        length=4    label=''
        dest_state_name        length=$40  label=''
        dest_wac               length=3    label=''
        airline_id             length=4    label=''
        unique_carrier         length=$2   label=''
        unique_carrier_name    length=$40  label=''
        unique_carrier_entity  length=$10  label=''
        carrier_region         length=$1   label=''
        carrier                length=$2   label=''
        carrier_name           length=$40  label=''
        carrier_group          length=3    label=''
        carrier_group_new      length=3    label=''
        distance               length=6    label=''
        distance_group         length=3    label=''
        class                  length=$1   label=''
        aircraft_group         length=3    label=''
        aircraft_type          length=3    label=''
        aircraft_config        length=3    label=''
        departures_scheduled   length=4    label=''
        departures_performed   length=4    label=''
        payload                length=6    label=''
        seats                  length=6    label=''
        passengers             length=6    label=''
        freight                length=6    label=''
        mail                   length=6    label=''
        ramp_to_ramp           length=6    label=''
        air_time               length=6    label=''
        ;

    input
        year quarter month origin $ origin_city_name $ origin_city_num
        origin_state_abr $ origin_state_fips origin_state_name $ origin_wac
        dest $ dest_city_name $ dest_city_num dest_state_abr $ dest_state_fips
        dest_state_name $ dest_wac airline_id unique_carrier $
        unique_carrier_name $ unique_carrier_entity $ carrier_region $
        carrier $ carrier_name $ carrier_group carrier_group_new distance
        distance_group class $ aircraft_group aircraft_type aircraft_config
        departures_scheduled departures_performed payload seats passengers
        freight mail ramp_to_ramp air_time
        ;

