/**
 * process_db1bt.sas
 *
 * SAS macro to load and process a raw DB1B Ticket datset.  This script is
 * designed to be used inside a SAS DATA step to process rows from a DB1B
 * Ticket dataset.
 *
 * Jason R. Blevins <jrblevin@sdf.lonestar.org>
 * Chapel Hill, January 15, 2007
 */

    /* Define the internal representations and labels */
    attrib
        ItinID              length=7     label='Itinerary ID'
        Coupons             length=3     label='No. Coupons in Itinerary'
        Year                length=3     label='Year'
        Quarter             length=3     label='Quarter'
        ItinOrigin          length=$3    label='Itinerary Origin Airport'
        ItinOriginAptInd    length=3     label='Multiple Airports at Origin'
        ItinOriginCityNum   length=4     label='Itinerary Origin City Code'
        ItinOriginCountry   length=$2    label='Itinerary Origin Country Code'
        ItinOriginStateFips length=4     label='Itinerary Origin State FIPS'
        ItinOriginState     length=$2    label='Itinerary Origin State Code'
        ItinOriginStateName length=$25   label='Itinerary Origin State Name'
        ItinOriginWac       length=3     label='Itinerary Origin WAC'
        ItinRoundTrip       length=3     label='Round Trip Itinerary'
        ItinOnLine          length=3     label='OnLine Itinerary'
        ItinDollarCred      length=3     label='Itinerary Fare Credibility'
        ItinYield           length=6     label='Total Itinerary Yield'
        ItinRpCarrier       length=$2    label='Itinerary Reporting Carrier'
        ItinPassengers      length=4     label='No. Passengers (Itinerary)'
        ItinFare            length=6     label='Total Itinerary Fare'
        ItinBulkFare        length=3     label='Bulk Fare (Itinerary)'
        ItinDistance        length=6     label='Itinerary Distance'
        ItinDistanceGrp     length=3     label='Itinerary Distance Group'
        ItinMilesFlown      length=6     label='Itinerary Miles Flown'
        ItinGeoType         length=3     label='Itinerary Geography Type'
        ;

    /* Read the source CSV file */
    input
        ItinID Coupons Year Quarter ItinOrigin $ ItinOriginAptInd
        ItinOriginCityNum ItinOriginCountry $ ItinOriginStateFips
        ItinOriginState $ ItinOriginStateName $
        ItinOriginWac ItinRoundTrip ItinOnLine ItinDollarCred ItinYield
        ItinRpCarrier $ ItinPassengers ItinFare ItinBulkFare ItinDistance
        ItinDistanceGrp ItinMilesFlown ItinGeoType
        ;

