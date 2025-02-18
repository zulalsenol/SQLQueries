WITH json_data AS (
    SELECT
        jsonb_array_elements("Opportunity"."DynamicFieldValues"::jsonb) AS data,
        "OPPORTUNITY_ID" AS "OpportunityId",  -- Placeholder for OpportunityId
        "Code"
    FROM "Opportunity"
    WHERE "DeleteFlag" IS FALSE
      AND "OpportunityStatus" = 'Active'
),
invoice AS (
    SELECT
        "OpportunityId",
        "Code",
        data ->> 'Index' AS Index,
        data ->> 'DynamicFieldId' AS DynamicFieldId,
        COALESCE(
            data -> 'NameValue' ->> 'Name',
            data ->> 'TextValue',
            data ->> 'DateValue',
            data ->> 'NumberValue'
        ) AS Value
    FROM json_data
    WHERE data ->> 'Index' IS NOT NULL
),
invoiceDetails AS (
    SELECT
        "OpportunityId",
        "Code",
        MAX(CASE WHEN DynamicFieldId = 'DYNAMIC_FIELD_KEY_1' THEN Value END) AS "Fatura Eden Firma",  -- Placeholder for DynamicFieldId
        MAX(CASE WHEN DynamicFieldId = 'DYNAMIC_FIELD_KEY_2' THEN Value END) AS "Fatura Tipi",
        MAX(CASE WHEN DynamicFieldId = 'DYNAMIC_FIELD_KEY_3' THEN Value END) AS "Fatura No",
        MAX(CASE WHEN DynamicFieldId = 'DYNAMIC_FIELD_KEY_4' THEN Value END) AS "Fatura Tarihi",
        MAX(CASE WHEN DynamicFieldId = 'DYNAMIC_FIELD_KEY_5' THEN Value END) AS "Döviz Tutar",
        MAX(CASE WHEN DynamicFieldId = 'DYNAMIC_FIELD_KEY_6' THEN Value END) AS "Döviz Cinsi",
        MAX(CASE WHEN DynamicFieldId = 'DYNAMIC_FIELD_KEY_7' THEN Value::numeric END) AS "TL Tutar"
    FROM invoice
    GROUP BY "OpportunityId", Index, "Code"
),
details AS (
    SELECT
        "OpportunityId",
        "Fatura Tipi",
        "TL Tutar"
    FROM invoiceDetails
),
source AS (
    SELECT
        "OpportunityId",
        SUM(CASE WHEN "Fatura Tipi" = 'Satış Faturası' THEN "TL Tutar" ELSE 0 END) AS SalesInvoiceTotal,
        SUM(CASE WHEN "Fatura Tipi" = 'Alış Faturası' THEN "TL Tutar" ELSE 0 END) AS PurchaseInvoiceTotal,
        SUM(CASE WHEN "Fatura Tipi" = 'Satış Faturası' THEN "TL Tutar" ELSE 0 END) -
        SUM(CASE WHEN "Fatura Tipi" = 'Alış Faturası' THEN "TL Tutar" ELSE 0 END) AS InvoiceDifference
    FROM details
    GROUP BY "OpportunityId"
)
SELECT
    "source"."salesinvoicetotal",
    "source"."purchaseinvoicetotal",
    "source"."invoicedifference",
    CAST(extract(year FROM "Opportunity"."ExpectedStartMonth") AS integer) AS "Year",
    "Opportunity"."Code" AS "OpportunityCode",
    "Opportunity"."Name" AS "OpportunityName",
    ("Opportunity"."DynamicFieldSearchValues" #>> array['DYNAMIC_FIELD_KEY']::text[])::timestamp AS "OpportunityCloseDate",  -- Placeholder for DynamicFieldSearchValues key
    "Customer"."CustomerShortName"
FROM source
LEFT JOIN "public"."Opportunity" ON "source"."OpportunityId" = "Opportunity"."OPPORTUNITY_ID"
LEFT JOIN "public"."Account" ON "Opportunity"."ACCOUNT_ID" = "Account"."ACCOUNT_ID"
LEFT JOIN "public"."Customer" ON "Account"."CUSTOMER_ID" = "Customer"."CUSTOMER_ID"
LEFT JOIN "public"."OpportunityInfo" ON "Opportunity"."OPPORTUNITY_ID" = "OpportunityInfo"."OPPORTUNITY_ID"
LEFT JOIN "public"."Service" ON "OpportunityInfo"."SERVICE_ID" = "Service"."SERVICE_ID"
WHERE "OpportunityInfo"."DeleteFlag" = FALSE
  AND "Account"."DeleteFlag" = FALSE;