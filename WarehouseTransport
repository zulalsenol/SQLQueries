WITH WarehouseTransport AS (
    SELECT * FROM (VALUES
        ('e7b5b7b2-bc6e-4f76-a1c9-3cdd9c1d9479', 'New York', 'Boston', 15),
        ('cb5f1d3e-f2f7-4b6b-9a60-872d924ae6d7', 'New York', 'Chicago', 20),
        ('a9424e26-f846-4579-9380-85b5ff819802', 'Boston', 'Philadelphia', 8),
        ('5c246682-2aa9-4ab2-b2f1-06d45218e164', 'Chicago', 'Philadelphia', 12),
        ('9a5d839e-d530-45ef-8e80-3b5e897c94e6', 'Philadelphia', 'Atlanta', 25),
        ('d03aab9e-68b2-468d-8e13-7c5e46b07fc9', 'Atlanta', 'Miami', 10),
        ('64a4ad2f-b7a1-4e94-a6a7-0a8d973c33c3', 'Miami', 'Houston', 5),
        ('ddc3b718-196d-4f4f-9b2f-41df8e1a1594', 'New York', 'Miami', 18),
        ('3e8e3a0e-3ab4-4f1c-b121-e1b80d2fbb6f', 'Boston', 'Houston', 7),
        ('b187ba73-bab4-4f1c-98d5-0df0e8940b5e', 'Chicago', 'Atlanta', 22),
        ('43d9a245-c246-44a5-8e11-e506f918d212', 'Houston', 'Dallas', 3),
        ('6e77de7e-0549-4857-a7a4-813d97e9c4b4', 'Dallas', 'Austin', 9),
        ('0eb1a058-3b63-4f58-b4c9-93f3a8b89e7d', 'Austin', 'Denver', 11),
        ('bfe709d3-c1f3-4e17-b5d8-e9bc28eac638', 'Denver', 'Phoenix', 6),
        ('2a2952c1-df4f-417f-8c48-5b8dc4e2360e', 'Phoenix', 'Las Vegas', 14),
        ('a7e35449-3781-48d7-bccf-4fd20e5dbf98', 'Las Vegas', 'Los Angeles', 13),
        ('768f3ae9-c146-46ad-a2db-55a4fd8a36d9', 'Los Angeles', 'San Francisco', 17),
        ('29e4d90e-2086-4081-a4ed-c3f65a3d9508', 'San Francisco', 'Seattle', 21),
        ('1c597edb-f66a-4113-8f3f-b3261cc05b41', 'Seattle', 'Portland', 16),
        ('d1c6c64d-1e64-4a89-a7a1-36a5a6e972c3', 'Portland', 'Vancouver', 19)
    ) AS data("RecordId", "OriginCity", "DestinationCity", "VehicleCount")
)
SELECT * 
FROM WarehouseTransport;

/* This SQL code uses a Common Table Expression (CTE) to define a temporary dataset called `WarehouseTransport`. 
Each row represents transport data between city warehouses, including a unique `ID` (GUID), origin city, destination city
and vehicle count. The `VALUES` clause provides the data for the table, and the column names are specified as 
`RecordId`, `OriginCity`, `DestinationCity`, and `VehicleCount`. The final `SELECT *` query retrieves all the rows from the CTE for display.
*/
