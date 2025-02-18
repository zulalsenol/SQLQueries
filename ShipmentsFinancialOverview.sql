SELECT
"Customer"."CustomerShortName" AS "Customer Name",
"Opportunity"."Code" AS "ID",
"Opportunity"."Name" AS "Shipment Request Name",
"OpportunityStatusView"."DisplayName" AS "Shipment Request Status",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId1','Name']::text[])::text AS "Supplier",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId2','Name']::text[])::text AS "Delivery Type",
to_char(to_timestamp("Opportunity"."DynamicFieldSearchValues"->>'DynamicFieldId3', 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'DD-MM-YYYY') AS "Offer Validity Date",
CAST("Opportunity"."DynamicFieldSearchValues"->>'DynamicFieldId4' AS text) AS "Gross KG",
CAST("Opportunity"."DynamicFieldSearchValues"->>'DynamicFieldId5' AS text) AS "Number of Cups",
CAST("Opportunity"."DynamicFieldSearchValues"->>'DynamicFieldId6' AS text) AS "Volumetric KG",
CAST("Opportunity"."DynamicFieldSearchValues"->>'DynamicFieldId7' AS text) AS "CBM",
to_char(to_timestamp("Opportunity"."DynamicFieldSearchValues"->>'DynamicFieldId8', 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'DD-MM-YYYY') AS "File Closing Date",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId9','Name']::text[])::text AS "Origin Airport",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId10','Name']::text[])::text AS "Destination Airport",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId11','Name']::text[])::text AS "Origin Port",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId12','Name']::text[])::text AS "Destination Port",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId13']::text[]) AS "Exit Customs",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId14']::text[]) AS "Destination Customs",
INITCAP(("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId15']::text[])) AS "Loading Address",
INITCAP(("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId16']::text[])) AS "Delivery Address",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId17']::text[]) AS "Exit Depot",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId18']::text[]) AS "Warehouse",
"Opportunity"."DynamicFieldSearchValues"->'DynamicFieldId19'->>'Name' AS "Stacking Status",
INITCAP(("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId20']::text[])) AS "Sender",
INITCAP(("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId21']::text[])) AS "Receiver",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId22']::text[]) AS "Origin Country",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId23']::text[]) AS "Destination Country",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId24']::text[]) AS "AWB No",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId25']::text[]) AS "BL No",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId26']::text[]) AS "Container No",
("Opportunity"."DynamicFieldSearchValues" #>> array ['DynamicFieldId27']::text[]) AS "Plate No",
"Service"."Name" AS "Service",
"ServiceUnit"."Name" AS "Unit",
"OpportunityInfo"."Metric" AS "Quantity",
"OpportunityInfo"."Revenue" AS "Revenue",
"TransactionCurrency"."CurrencySymbol" AS "Currency",
"Opportunity"."TotalForOnceRevenue" AS "One-time Revenue",
"Opportunity"."TotalMonthlyRevenue" AS "Monthly Revenue",
"Opportunity"."LocalTotalForOnceRevenue" AS "One-time TL Revenue",
"Opportunity"."LocalTotalMonthlyRevenue" AS "Monthly TL Revenue"
FROM "Opportunity"
LEFT JOIN "Account" ON "Account"."AccountId" = "Opportunity"."AccountId" AND NOT "Account"."DeleteFlag"
LEFT JOIN "Customer" ON "Customer"."CustomerId" = "Account"."CustomerId" AND NOT "Customer"."DeleteFlag"
LEFT JOIN "OpportunityInfo" ON "Opportunity"."OpportunityId" = "OpportunityInfo"."OpportunityId" AND NOT "OpportunityInfo"."DeleteFlag"
LEFT JOIN "Service" ON "Service"."ServiceId" = "OpportunityInfo"."ServiceId" AND NOT "Service"."DeleteFlag"
LEFT JOIN "ServiceUnit" ON "ServiceUnit"."ServiceUnitId" = "OpportunityInfo"."ServiceUnitId" AND NOT "ServiceUnit"."DeleteFlag"
LEFT JOIN "Map_ServiceMainService" ON "Map_ServiceMainService"."ServiceId" = "Service"."ServiceId" AND NOT "Map_ServiceMainService"."DeleteFlag"
LEFT JOIN "ServiceMain" ON "ServiceMain"."ServiceMainId" = "Map_ServiceMainService"."ServiceMainId" AND NOT "ServiceMain"."DeleteFlag"
LEFT JOIN "OpportunityType" ON "OpportunityType"."OpportunityTypeId" = "Opportunity"."OpportunityTypeId" AND NOT "OpportunityType"."DeleteFlag"
LEFT JOIN "OpportunityTypeView" ON "OpportunityTypeView"."OpportunityTypeId" = "OpportunityType"."OpportunityTypeId" 
LEFT JOIN "OpportunityStatus" ON "OpportunityStatus"."OpportunityStatusId" = "Opportunity"."OpportunityStatusId" AND NOT "OpportunityStatus"."DeleteFlag"
LEFT JOIN "OpportunityStatusView" ON "OpportunityStatus"."OpportunityStatusId" = "OpportunityStatusView"."OpportunityStatusId" AND "Account"."SalesOrganizationId" = "OpportunityStatusView"."SalesOrganizationId"
LEFT JOIN "TransactionCurrency" ON "OpportunityInfo"."TransactionCurrencyId" = "TransactionCurrency"."TransactionCurrencyId" AND NOT "TransactionCurrency"."DeleteFlag"
WHERE "Opportunity"."DeleteFlag" = false;
