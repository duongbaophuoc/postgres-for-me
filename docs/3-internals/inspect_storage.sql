-- Stage 3: Internals & Performance Inspection
-- Inspecting page structure and MVCC visibility

-- 1. Check page-level information (Requires pgstattuple extension)
CREATE EXTENSION IF NOT EXISTS pgstattuple;

SELECT * FROM pgstattuple('users');

-- 2. Inspect Tuple Visibility (xmin, xmax)
SELECT 
    ctid, 
    xmin, 
    xmax, 
    cmin, 
    cmax, 
    * 
FROM users 
LIMIT 10;

-- 3. Check Shared Buffers Usage
CREATE EXTENSION IF NOT EXISTS pg_buffercache;

SELECT 
    c.relname, 
    count(*) AS buffers
FROM pg_buffercache b
INNER JOIN pg_class c ON b.relkind = 'r' AND b.relfilenode = pg_relation_filenode(c.oid)
AND b.reldatabase IN (0, (SELECT oid FROM pg_database WHERE datname = current_database()))
GROUP BY c.relname
ORDER BY 2 DESC
LIMIT 10;
