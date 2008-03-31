/**
 * process_db1bc.sas
 *
 * SAS macro to load and process a raw DB1B Coupon datset.
 *
 * Before this file is included, a data step should be started and
 * in infile statement should have been issued.  Furthermore,
 * the file 'db1bc_formats.sas' should have been included.
 *
 * Usage Example:
 *
 *     %include 'db1bc_formats.sas'
 *
 *     data db1bc;
 *         infile 'db1b_coupon-1993_1.csv' dsd firstobs=2;
 *         %include 'process_db1bc.sas'
 *         keep ItinID Year Quarter CpnOrigin CpnDest;
 *     run;
 *
 * Jason R. Blevins <jrblevin@sdf.lonestar.org>
 * Chapel Hill, January 15, 2007
 */

    /* Label the variables */
     attrib
        ItinID              length=7   label = 'Itinerary ID'
        MktID               length=7   label = 'Market ID'
        CpnSeqNum           length=3   label = 'Coupon Sequence Number'
        ItinCoupons         length=3   label = 'No. Coupons in Itinerary'
        Year                length=3   label = 'Year'
        Quarter             length=3   label = 'Quarter'
        CpnOrigin           length=$3  label = 'Origin Airport Code'
        CpnOriginAptInd     length=3   label = 'Multiple Airports at Origin'
        CpnOriginCityNum    length=4   label = 'Origin City Code'
        CpnOriginCountry    length=$2  label = 'Origin Country Code'
        CpnOriginStateFips  length=4   label = 'Origin State FIPS Code'
        CpnOriginState      length=$2  label = 'Origin State Code'
        CpnOriginStateName  length=$25 label = 'Origin State Name'
        CpnOriginWac        length=3   label = 'Origin World Area Code'
        CpnDest             length=$3  label = 'Dest. Airport Code'
        CpnDestAptInd       length=3   label = 'Multiple Airports at Dest.'
        CpnDestCityNum      length=4   label = 'Dest. City Code'
        CpnDestCountry      length=$2  label = 'Dest. Country Code'
        CpnDestStateFips    length=4   label = 'Dest. State FIPS Code'
        CpnDestState        length=$2  label = 'Dest. State Code'
        CpnDestStateName    length=$25 label = 'Dest. State Name'
        CpnDestWac          length=3   label = 'Dest. World Area Code'
        CpnBreak            length=$1  label = 'Trip Break Code'
        CpnType             length=$1  label = 'Coupon Type Code'
        CpnTkCarrier        length=$2  label = 'Coupon Ticketing Carrier'
        CpnOpCarrier        length=$2  label = 'Coupon Operating Carrier' 
        CpnRpCarrier        length=$2  label = 'Itinerary Reporting Carrier'
        CpnPassengers       length=4   label = 'No. Passengers on Coupon'
        CpnFareClass        length=$1  label = 'Coupon Fare Class'
        CpnDistance         length=6   label = 'Coupon Distance'
        CpnDistanceGrp      length=3   label = 'Coupon Distance Group'
        CpnGateway          length=3   label = 'Gateway Indicator'
        ItinGeoType         length=3   label = 'Itinerary Geography Type'
        CpnGeoType          length=3   label = 'Coupon Geography Type'
        ;

    /* Read the source CSV file */
    input
        ItinID MktID CpnSeqNum ItinCoupons Year Quarter CpnOrigin $
        CpnOriginAptInd CpnOriginCityNum CpnOriginCountry $ CpnOriginStateFips
        CpnOriginState $ CpnOriginStateName $ CpnOriginWac CpnDest $
        CpnDestAptInd CpnDestCityNum CpnDestCountry $ CpnDestStateFips
        CpnDestState $ CpnDestStateName $ CpnDestWac CpnBreak $ CpnType $
        CpnTkCarrier $ CpnOpCarrier $ CpnRpCarrier $ CpnPassengers
        CpnFareClass $ CpnDistance CpnDistanceGrp CpnGateway ItinGeoType
        CpnGeoType
        ;

    /* Associate variable labels */
    format
        CpnDistanceGrp    distgrp.
        CpnGateway        yesno.
        ItinGeoType       geotype.
        CpnGeoType        geotype.
        ;

