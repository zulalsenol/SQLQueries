SELECT
    "source"."OpportunityId" AS "Opportunity ID",
    "source"."AccountName" AS "Account Name",
    "source"."MembershipStatus" AS "Membership Status",
    "source"."OpportunityStatus" AS "Opportunity Status",
    "source"."RequestDate" AS "Request Date",
    "source"."PolicyStatus" AS "Policy Status",
    "source"."PolicyPricePercentage" AS "Policy Price %",
    "source"."EstimatedTurnover" AS "Estimated Turnover",
    "source"."Premium" AS "Premium",
    "source"."OfferDate" AS "Offer Date",
    "source"."Insurer" AS "Insurer",
    "source"."Requestor" AS "Requestor",
    "source"."FFLPolicyExist" AS "FFL Policy Exist",
    "source"."EndDate" AS "End Date",
    "source"."Tag" AS "Tag",
    "source"."LostReason" AS "Lost Reason",
    "source"."GainDate" AS "Gain Date",
    "source"."Description" AS "Description"
FROM (
    SELECT
        "o"."OpportunityId" AS "OpportunityId",
        "c"."CustomerShortName" AS "AccountName",
        "rm"."AccountStatus" AS "MembershipStatus",
        "os"."EngName" AS "OpportunityStatus",
        "o"."RequestDate" AS "RequestDate",
        "o"."PolicyStatus" AS "PolicyStatus",
        "o"."PolicyPrice" AS "PolicyPricePercentage",
        "o"."EstimatedRevenue" AS "EstimatedTurnover",
        "o"."ExpectedRevenue" AS "Premium",
        "o"."OfferDate" AS "OfferDate",
        "o"."Insurer" AS "Insurer",
        "o"."Requestor" AS "Requestor",
        "o"."FFLPolicyExist" AS "FFLPolicyExist",
        "o"."EndDate" AS "EndDate",
        "t"."TagValue" AS "Tag",
        "olr"."LostReasonType" AS "LostReason",
        "o"."GainDate" AS "GainDate",
        "o"."Description" AS "Description"
    FROM (
        SELECT
            "o"."OpportunityId",
            "o"."DynamicFieldSearchValues" #>> '{DynamicFieldId1}' AS "Requestor",
            CASE
                WHEN "o"."DynamicFieldSearchValues" #>> '{DynamicFieldId2,Name}' = 'Yeni' THEN 'New'
                WHEN "o"."DynamicFieldSearchValues" #>> '{DynamicFieldId2,Name}' = 'Yenileme' THEN 'Renewal'
                ELSE 'Empty'
            END AS "PolicyStatus",
            to_date("o"."DynamicFieldSearchValues" #>> '{DynamicFieldId3}', 'DD.MM.YYYY') AS "RequestDate",
            to_date(
                CASE
                    WHEN LENGTH("o"."DynamicFieldSearchValues" #>> '{DynamicFieldId4}') = 16 THEN
                        "o"."DynamicFieldSearchValues" #>> '{DynamicFieldId4}'
                    ELSE '1900-01-01'
                END,
                'YYYY-MM-DD'
            ) AS "EndDate",
            CASE
                WHEN "o"."DynamicFieldSearchValues" #>> '{DynamicFieldId5,Name}' = 'Yok' THEN 'Not Exist'
                WHEN "o"."DynamicFieldSearchValues" #>> '{DynamicFieldId5,Name}' = 'Var' THEN 'Exist'
                ELSE 'Unknown'
            END AS "FFLPolicyExist",
            "o"."DynamicFieldSearchValues" #>> '{DynamicFieldId6}' AS "Insurer",
            to_char("o"."DynamicFieldSearchValues" #>> '{DynamicFieldId7}', 'DD.MM.YYYY') AS "OfferDate",
            "o"."DynamicFieldSearchValues" #>> '{DynamicFieldId8,Name}' AS "RejectionReason",
            "o"."OpportunityId" AS "OpportunityId",
            "o"."OpportunityStatusId",
            "o"."OpportunityTypeId",
            "o"."OwnerId",
            "o"."CustomerId",
            "o"."TotalForOnceRevenue" AS "TotalForOnceRevenue",
            "o"."TotalMonthlyRevenue" AS "TotalMonthlyRevenue",
            "o"."ProductionAccountCodeFlag",
            "o"."Description"
        FROM
            "public"."Opportunity" o
        WHERE
            "o"."DeleteFlag" IS FALSE
    ) AS "o"
    LEFT JOIN "public"."Customer" c ON "o"."CustomerId" = "c"."CustomerId" AND "c"."DeleteFlag" IS FALSE
    LEFT JOIN "public"."OpportunityStatus" os ON "o"."OpportunityStatusId" = "os"."OpportunityStatusId"
    LEFT JOIN "public"."OpportunityLostReasonType" olr ON "o"."OpportunityLostReasonTypeId" = "olr"."OpportunityLostReasonTypeId"
    LEFT JOIN "public"."Tag" t ON "o"."OpportunityId" = "t"."OpportunityId"
    LEFT JOIN "public"."AccountStatus" rm ON "o"."AccountStatusId" = "rm"."AccountStatusId"
) AS "source"
ORDER BY
    "source"."OpportunityStatus" ASC,
    "source"."RequestDate" DESC;
