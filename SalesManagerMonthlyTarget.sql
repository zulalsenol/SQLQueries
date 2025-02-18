WITH SalesManagerMonthlyTarget AS (
    SELECT DISTINCT ON (SystemUserId)
        SystemUserId,
        SalesManager,
        VisitKpi,
        MailKpi
    FROM (
             VALUES
                 ('USER_ID_1'::uuid, 'SalesManager1', 15, 20),
                 ('USER_ID_2'::uuid, 'SalesManager1', 20, 20),
                 ('USER_ID_3'::uuid, 'SalesManager1', 20, 20),
                 ('USER_ID_4'::uuid, 'SalesManager1', 20, 20),
                 ('USER_ID_5'::uuid, 'SalesManager5', 10, 10),
                 ('USER_ID_6'::uuid, 'SalesManager6', 20, 20),
                 ('USER_ID_7'::uuid, 'SalesManager7', 15, 20),
                 ('USER_ID_8'::uuid, 'SalesManager8', 15, 15),
                 ('USER_ID_9'::uuid, 'SalesManager9', 20, 20),
                 ('USER_ID_10'::uuid, 'SalesManager10', 20, 20),
                 ('USER_ID_11'::uuid, 'SalesManager11', 20, 20),
                 ('USER_ID_12'::uuid, 'SalesManager12', 10, 10),
                 ('USER_ID_13'::uuid, 'SalesManager13', 20, 20),
                 ('USER_ID_14'::uuid, 'SalesManager14', 20, 20)
         ) AS unique_sales_managers(SystemUserId, SalesManager, VisitKpi, MailKpi)
),
     Activities AS (
         SELECT
             t."ActivityId",
             t."ActivityTypeId",
             DATE_TRUNC('month', COALESCE(t."ActualStartDate", t."PlanningStartDate")) AS "Month",
             t."CreatedBy" AS "SystemUserId",
             su."DisplayName" AS "SystemUserFullName",
             so."Name" AS "SalesOrganizationName",
             so."SalesOrganizationId",
             acsv."DisplayName" AS "AccountStatusName"
         FROM
             "ActivityTable" t
                 JOIN
             "UserTable" su ON t."CreatedBy" = su."SystemUserId"
                 JOIN
             "AccountTable" ac ON t."AccountId" = ac."AccountId" AND ac."DeleteFlag" = false
                 JOIN
             "SalesOrganizationTable" so ON ac."SalesOrganizationId" = so."SalesOrganizationId" AND so."DeleteFlag" = false
                 LEFT JOIN
             "SalesRouteDefinitionTable" srd ON ac."SalesRouteDefinitionId" = srd."SalesRouteDefinitionId" AND srd."DeleteFlag" = false
                 LEFT JOIN
             "AccountStatusTable" acs ON acs."AccountStatusId" = ac."AccountStatusId" AND acs."DeleteFlag" = false
                 LEFT JOIN
             "AccountStatusViewTable" acsv ON acsv."AccountStatusId" = acs."AccountStatusId" AND acsv."SalesOrganizationId" = ac."SalesOrganizationId"
         WHERE
             t."DeleteFlag" = false
           AND EXTRACT(YEAR FROM COALESCE(t."ActualStartDate", t."PlanningStartDate")) = EXTRACT(YEAR FROM NOW())
           AND COALESCE(t."ActualStartDate", t."PlanningStartDate") >= DATE_TRUNC('year', NOW())
           AND COALESCE(t."ActualStartDate", t."PlanningStartDate") < DATE_TRUNC('year', NOW()) + INTERVAL '1 year'
           AND t."ActivityStatusId" = 'ACTIVITY_STATUS_ID_1'
           AND acs."AccountStatusId" IN (
                                         'ACCOUNT_STATUS_ID_1',
                                         'ACCOUNT_STATUS_ID_2',
                                         'ACCOUNT_STATUS_ID_3',
                                         'ACCOUNT_STATUS_ID_4',
                                         'ACCOUNT_STATUS_ID_5',
                                         'ACCOUNT_STATUS_ID_6',
                                         'ACCOUNT_STATUS_ID_7',
                                         'ACCOUNT_STATUS_ID_8',
                                         'ACCOUNT_STATUS_ID_9'
             )
     ),
     SystemUserActivities AS (
         SELECT
             smt.SystemUserId AS "SystemUserId",
             smt.SalesManager AS "SystemUserFullName",
             a."Month"                              as "Date",
                                     CASE 
                                       WHEN EXTRACT(MONTH FROM a."Month") = 1 THEN 'Ocak'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 2 THEN 'Şubat'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 3 THEN 'Mart'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 4 THEN 'Nisan'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 5 THEN 'Mayıs'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 6 THEN 'Haziran'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 7 THEN 'Temmuz'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 8 THEN 'Ağustos'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 9 THEN 'Eylül'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 10 THEN 'Ekim'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 11 THEN 'Kasım'
                                       WHEN EXTRACT(MONTH FROM a."Month") = 12 THEN 'Aralık'
                                                                        END as "Month",
             COUNT(CASE WHEN a."SystemUserId" = smt.SystemUserId THEN a."ActivityId" END) AS "TotalActivity",
             COUNT(CASE WHEN a."SystemUserId" = smt.SystemUserId AND a."ActivityTypeId" = 'ACTIVITY_TYPE_ID_1' THEN a."ActivityId" END) AS "TotalVisit",
             COUNT(CASE WHEN a."SystemUserId" = smt.SystemUserId AND a."ActivityTypeId" = 'ACTIVITY_TYPE_ID_2' THEN a."ActivityId" END) AS "TotalVideoConference",
             COUNT(CASE WHEN a."SystemUserId" = smt.SystemUserId AND a."ActivityTypeId" = 'ACTIVITY_TYPE_ID_3' THEN a."ActivityId" END) AS "TotalMail",
             COUNT(CASE WHEN a."SystemUserId" = smt.SystemUserId AND (a."ActivityTypeId" = 'ACTIVITY_TYPE_ID_1' OR a."ActivityTypeId" = 'ACTIVITY_TYPE_ID_2') THEN a."ActivityId" END) AS "Total_Video_Visit",
             COUNT(CASE WHEN a."SystemUserId" = smt.SystemUserId AND a."ActivityTypeId" = 'ACTIVITY_TYPE_ID_4' THEN a."ActivityId" END) AS "TotalPhone",
             COUNT(CASE WHEN a."SystemUserId" = smt.SystemUserId AND a."ActivityTypeId" = 'ACTIVITY_TYPE_ID_5' THEN a."ActivityId" END) AS "TotalEvent"
         FROM
             Activities a
                 CROSS JOIN
             SalesManagerMonthlyTarget smt
         GROUP BY
             smt.SystemUserId,
             smt.SalesManager,
             a."Month"
     )
SELECT 
    sua."Month" AS "Tarih",
    sua."SystemUserFullName" AS "Satış Yöneticisi",
    COALESCE("Total_Video_Visit", 0) + COALESCE("TotalMail", 0) + COALESCE("TotalEvent", 0) + COALESCE("TotalPhone", 0) AS "Toplam Aktivite",
    COALESCE("TotalVisit", 0) AS "Ziyaret",
    COALESCE("TotalVideoConference", 0) AS "Video Konferans", 
    COALESCE("TotalPhone", 0) AS "Telefon",
    COALESCE("TotalMail", 0) AS "E-Posta", 
    COALESCE("Total_Video_Visit", 0) + COALESCE("TotalMail", 0) AS "Gerçekleşen",
    COALESCE(smmt.VisitKpi, 0) + COALESCE(smmt.MailKpi, 0) AS "Hedeflenen",
        ROUND((
        (((CAST(COALESCE(sua."Total_Video_Visit", 0) AS DECIMAL) * 0.8) / COALESCE(smmt.VisitKpi, 1))  + (CAST(COALESCE(sua."TotalMail", 0) AS DECIMAL) * 0.2 / COALESCE(smmt.MailKpi, 1)))), 2) AS "Gerçekleşen %"
            FROM SystemUserActivities sua
            LEFT JOIN SalesManagerMonthlyTarget smmt ON sua."SystemUserId" = smmt.SystemUserId
            /*WHERE 1=1
         [[AND smmt.SalesManager = {{SalesManager}}]]
         [[AND {{Date}}=sua."Month"]] */ --Filtering for metabase
ORDER BY sua."SystemUserFullName";