/**
 * process_db1bm.sas
 *
 * SAS macro to load and process a raw DB1B Market datset.  It
 * is designed to be used within a DATA step. It defines the names 
 * and storage-efficient data types for the columns of the DB1BMarket
 * dataset.
 *
 * Jason R. Blevins <jrblevin@sdf.lonestar.org>
 * Chapel Hill, January 15, 2007
 */

    /* Define the internal representations and labels */
    attrib
        ItinID              length=7     label='Itinerary ID'
        MktID               length=7     label='Market ID'
        MktCoupons          length=3     label='No. Coupons in Market'
        Year                length=3     label='Year'
        Quarter             length=3     label='Quarter'
        MktOrigin           length=$3    label='Origin Airport Code'
        MktOriginAptInd     length=3     label='Multiple Airports at Origin'
        MktOriginCityNum    length=4     label='Origin City Code'
        MktOriginCountry    length=$2    label='Origin Country Code'
        MktOriginStateFips  length=4     label='Origin State FIPS Code'
        MktOriginState      length=$2    label='Origin State Code'
        MktOriginStateName  length=$25   label='Origin State Name'
        MktOriginWac        length=3     label='Origin World Area Code'
        MktDest             length=$3    label='Dest. Airport Code'
        MktDestAptInd       length=3     label='Multiple Airports at Dest'
        MktDestCityNum      length=4     label='Dest. City Code'
        MktDestCountry      length=$2    label='Dest. Country Code'
        MktDestStateFips    length=4     label='Dest. State FIPS Code'
        MktDestState        length=$2    label='Dest. State Code'
        MktDestStateName    length=$25   label='Dest. State Name'
        MktDestWac          length=3     label='Dest. World Area Code'
        MktAirportGrp       length=$30   label='Market Airport Group'
        MktWacGrp           length=$30   label='Market World Area Code Group'
        MktTkCarrierChg     length=3     label='Ticketing Carrier Change'
        MktTkCarrierGrp     length=$30   label='Ticketing Carrier Group'
        MktOpCarrierChg     length=3     label='Operating Carrier Change'
        MktOpCarrierGrp     length=$30   label='Operating Carrier Group'
        ItinRpCarrier       length=$2    label='Reporting Carrier Code'
        MktTkCarrier        length=$2    label='Ticketing Carrier (Market)'
        MktOpCarrier        length=$2    label='Operating Carrier (Market)'
        MktBulkFare         length=3     label='Bulk Fare Indicator (Market)'
        MktPassengers       length=4     label='Number of Passengers (Market)'
        MktFare             length=6     label='Market Fare'
        MktDistance         length=6     label='Market Distance'
        MktDistanceGrp      length=3     label='Market Distance Group'
        MktMilesFlown       length=6     label='Market Miles Flown'
        MktNonStopMiles     length=6     label='Non-Stop Market Miles'
        ItinGeoType         length=3     label='Itinerary Geography Type'
        MktGeoType          length=3     label='Market Geography Type'
        ;                   

    /* Read the source CSV file */
    input
        ItinID MktID MktCoupons Year Quarter MktOrigin $ MktOriginAptInd
        MktOriginCityNum MktOriginCountry $ MktOriginStateFips MktOriginState $
        MktOriginStateName $ MktOriginWac MktDest $ MktDestAptInd
        MktDestCityNum MktDestCountry $ MktDestStateFips MktDestState $
        MktDestStateName $ MktDestWac MktAirportGrp $ MktWacGrp $
        MktTkCarrierChg MktTkCarrierGrp $ MktOpCarrierChg MktOpCarrierGrp $
        ItinRpCarrier $ MktTkCarrier $ MktOpCarrier $ MktBulkFare
        MktPassengers MktFare MktDistance MktDistanceGrp MktMilesFlown
        MktNonStopMiles ItinGeoType MktGeoType
        ;

