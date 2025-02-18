SELECT 
 "public"."Card"."CardId" AS "CardId",
 "Card"."Name" AS "Employee",
 ("public"."Card"."DynamicFieldSearchValues"#>>array['DynamicFieldId1']::text[])::text AS "Title",
 ("public"."Card"."DynamicFieldSearchValues"#>>array['DynamicFieldId2']::text[])::text AS "Manager",
 ("public"."Card"."DynamicFieldSearchValues" #>>array['DynamicFieldId3']::text[])::date AS "XOOIJoinDate",
 ("public"."Card"."DynamicFieldSearchValues"#>>array['DynamicFieldId4']::text[])::date AS "Birthday",
 CAST(CONCAT(
    CAST(extract(year from NOW()) AS integer), '-',
    CAST(extract(month from("public"."Card"."DynamicFieldSearchValues" #>>array['DynamicFieldId4']::text[])::date) AS integer), '-',
    CAST(extract(day from ("public"."Card"."DynamicFieldSearchValues"#>>array['DynamicFieldId4']::text[])::date) AS integer)) AS date
    ) AS "BirthdayReminder",
    
CASE 
        WHEN EXTRACT(year FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) = 0 
            AND EXTRACT(month FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) = 0 
            THEN EXTRACT(day FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) || ' days'
            
        WHEN (EXTRACT(year FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) = 0 
            AND EXTRACT(month FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) > 0) 
            THEN EXTRACT(month FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) || ' months ' || 
            EXTRACT(day FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) || ' days' 
            
        WHEN (EXTRACT(year FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) > 0 
            AND EXTRACT(month FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) = 0) 
            THEN EXTRACT(year FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) || ' years ' 
        
        WHEN (EXTRACT(year FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) = 0 
            AND EXTRACT(month FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) > 0) 
            THEN EXTRACT(month FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) || ' months ' 
            
        WHEN (EXTRACT(year FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) > 0 
            AND EXTRACT(month FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) > 0) 
            THEN EXTRACT(year FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) || ' years ' || 
            EXTRACT(month FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) || ' months'
        ELSE 
            EXTRACT(year FROM age(NOW(), ("public"."Card"."DynamicFieldSearchValues" #>> array['DynamicFieldId3']::text[])::date)) || ' year'
    END AS passed_time
FROM "Card"
LEFT JOIN "BoardInfo" ON "Card"."BoardInfoId" = "BoardInfo"."BoardInfoId" AND NOT "BoardInfo"."DeleteFlag"
LEFT JOIN "Board" ON "Board"."BoardId" = "BoardInfo"."BoardId" AND NOT "Board"."DeleteFlag"
WHERE "Board"."BoardId" = '13c7b4a4-4fe2-4fc2-ab41-2b3609e29f6a'
  AND "Card"."CardStatusId" = '3b3ca9f2-d281-11eb-b8bc-0242ac130003'
  AND NOT "Card"."DeleteFlag"
  AND "Card"."ParentCardId" IS NULL
  AND "BoardInfo"."BoardInfoId"='e8c87a9b-b566-40bc-bd66-66e4a12b32a4'
ORDER BY "Card"."Name";
