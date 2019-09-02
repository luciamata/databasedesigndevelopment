-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab6.sql
--  Lab Assignment: Lab #6
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2018
-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab6.sql
--
-- ------------------------------------------------------------------

-- Call library files.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql

-- Open log file.
SPOOL apply_oracle_lab6.txt

-- ... insert lab 6 commands here ...

-- STEP 1 --

ALTER TABLE RENTAL_ITEM
    ADD RENTAL_ITEM_PRICE NUMBER(22);
    
ALTER TABLE RENTAL_ITEM
    ADD RENTAL_ITEM_TYPE NUMBER(22);

SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

-- STEP 2 --

CREATE TABLE price (
    PRICE_ID            NUMBER(22)  NOT NULL,
    ITEM_ID             NUMBER(22)  NOT NULL,
    PRICE_TYPE          NUMBER(22),
    ACTIVE_FLAG         VARCHAR2(1) NOT NULL,
    START_DATE          DATE        NOT NULL,
    END_DATE            DATE,
    AMOUNT              NUMBER(22)  NOT NULL,
    CREATED_BY          NUMBER(22)  NOT NULL,
    CREATION_DATE       DATE        NOT NULL,
    LAST_UPDATED_BY     NUMBER(22)  NOT NULL,
    LAST_UPDATE_DATE    DATE        NOT NULL,
    CONSTRAINT YN_PRICE 
    CHECK (ACTIVE_FLAG IN ('Y', 'N' ))
    );
        
        
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'PRICE'
ORDER BY 2;

COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';

-- STEP 3.a --

ALTER TABLE ITEM
    RENAME COLUMN ITEM_RELEASE_DATE TO RELEASE_DATE;
    
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

-- STEP 3.b --

INSERT INTO item 
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_s1.nextval
,'24543-5615'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_FULL_SCREEN')
,'Tron'
,'Attack of the Clones'
,'PG'
,(TRUNC(SYSDATE) - 15)
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item 
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_s1.nextval
,'24543-5615'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_FULL_SCREEN')
,'Enders Game'
,'Attack of the Clones'
,'PG'
,(TRUNC(SYSDATE) - 15)
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item 
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_s1.nextval
,'24543-5615'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_FULL_SCREEN')
,'Elysium'
,'Attack of the Clones'
,'PG'
,(TRUNC(SYSDATE) - 15)
, 1001
, SYSDATE
, 1001
, SYSDATE);

SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

-- STEP 3.c --

-- Member --

INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MEMBER'
    AND      common_lookup_type = 'GROUP')
  , 'US00011'
  , '6011-0000-0000-0078'
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MEMBER'
    AND      common_lookup_type = 'DISCOVER_CARD')
  , 1001
  , SYSDATE
  , 1001 
  , SYSDATE );
  
  -- Harry Potter -- 

  /* Insert into the contact table. */
  INSERT INTO contact
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'CONTACT'
    AND      common_lookup_type = 'CUSTOMER')
  , 'Harry'
  , NULL
  , 'Potter'
  , 1001
  , SYSDATE
  , 1001  
  , SYSDATE );  

  /* Insert into the address table. */
  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = 'HOME')
  , 'Provo'
  , 'Utah'
  , '84604'
  , 1001
  , SYSDATE
  , 1001  
  , SYSDATE );  

  /* Insert into the street_address table. */
  INSERT INTO street_address
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , '900 E 300 N'
  , 1001
  , SYSDATE
  , 1001
  , SYSDATE );  

  /* Insert into the telephone table. */
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id                         -- ADDRESS_TYPE
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = 'HOME')
  , '1'                                   -- COUNTRY_CODE
  , '801'                                     -- AREA_CODE
  , '333-3333'                              -- TELEPHONE_NUMBER
  , 1001                                     -- CREATED_BY
  , SYSDATE                                  -- CREATION_DATE
  , 1001                                 -- LAST_UPDATED_BY
  , SYSDATE);                             -- LAST_UPDATE_DATE

 -- Ginny Potter --
 
  /* Insert into the contact table. */
  INSERT INTO contact
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'CONTACT'
    AND      common_lookup_type = 'CUSTOMER')
  , 'Ginny'
  , NULL
  , 'Potter'
  , 1001
  , SYSDATE
  , 1001
  , SYSDATE );  

  /* Insert into the address table. */
  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = 'HOME')
  , 'Provo'
  , 'Utah'
  , '84604'
  , 1001
  , SYSDATE
  , 1001  
  , SYSDATE );  

  /* Insert into the street_address table. */
  INSERT INTO street_address
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , '900 E 300 N'
  , 1001
  , SYSDATE
  , 1001  
  , SYSDATE );  

  /* Insert into the telephone table. */
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id                         -- ADDRESS_TYPE
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = 'HOME')
  , '1'                                   -- COUNTRY_CODE
  , '801'                                     -- AREA_CODE
  , '333-3333'                              -- TELEPHONE_NUMBER
  , 1001                                    -- CREATED_BY
  , SYSDATE                                  -- CREATION_DATE
  , 1001                                 -- LAST_UPDATED_BY
  , SYSDATE);                             -- LAST_UPDATE_DATE

  -- Lily Potter --
  
  /* Insert into the contact table. */
  INSERT INTO contact
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'CONTACT'
    AND      common_lookup_type = 'CUSTOMER')
  , 'Lily'
  , 'Luna'
  , 'Potter'
  , 1001
  , SYSDATE
  , 1001 
  , SYSDATE );  

  /* Insert into the address table. */
  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = 'HOME')
  , 'Provo'
  , 'Utah'
  , '84604'
  , 1001
  , SYSDATE
  , 1001
  , SYSDATE );  

  /* Insert into the street_address table. */
  INSERT INTO street_address
  VALUES
  ( street_address_s1.NEXTVAL
  , address_s1.CURRVAL
  , '900 E 300 N'
  , 1001
  , SYSDATE
  , 1001
  , SYSDATE );  

  /* Insert into the telephone table. */
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id                         -- ADDRESS_TYPE
    FROM     common_lookup
    WHERE    common_lookup_context = 'MULTIPLE'
    AND      common_lookup_type = 'HOME')
  , '1'                                   -- COUNTRY_CODE
  , '801'                                     -- AREA_CODE
  , '333-3333'                              -- TELEPHONE_NUMBER
  , 1001                                    -- CREATED_BY
  , SYSDATE                               -- CREATION_DATE
  , 1001                               -- LAST_UPDATED_BY
  , SYSDATE);                               -- LAST_UPDATE_DATE
  
COLUMN account_number  FORMAT A10  HEADING "Account|Number"
COLUMN full_name       FORMAT A16  HEADING "Name|(Last, First MI)"
COLUMN street_address  FORMAT A14  HEADING "Street Address"
COLUMN city            FORMAT A10  HEADING "City"
COLUMN state           FORMAT A10  HEADING "State"
COLUMN postal_code     FORMAT A6   HEADING "Postal|Code"
SELECT   m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN
             ' ' || c.middle_name || ' '
         END AS full_name
,        sa.street_address
,        a.city
,        a.state_province AS state
,        a.postal_code
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';
  
-- STEP 3.d --

INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 1
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 3
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Star Wars I'
  AND      i.item_subtitle = 'Phantom Menace'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);


INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Star Wars II'
  AND      i.item_subtitle = 'Attack of the Clones'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Ginny')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'The Hunt for Red October'
  AND      i.item_subtitle = 'Special Collector''s Edition'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Lily')
,(SELECT   i.item_id
  FROM     item i
  ,        common_lookup cl
  WHERE    i.item_title = 'Star Wars III'
  AND      i.item_subtitle = 'Revenge of the Sith'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);


COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;

-- STEP 4.a --

DROP INDEX common_lookup_n1;
DROP INDEX common_lookup_u2;

COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';

-- STEP 4.b --

ALTER TABLE common_lookup
    ADD common_lookup_table VARCHAR2(30)
    ADD common_lookup_column VARCHAR2(30)
    ADD common_lookup_code VARCHAR2(30);
    
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- STEP 4.c --

UPDATE common_lookup
SET common_lookup_table = 
    CASE
      WHEN common_lookup_context <> 'MULTIPLE' THEN
         common_lookup_context
      ELSE
        'ADDRESS'
       END -- end case statement
,   common_lookup_column = 
    CASE
      WHEN common_lookup_context <> 'MULTIPLE' THEN
         common_lookup_context || '_TYPE'
      ELSE
        'ADDRESS_TYPE'
       END;



COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

-- STEP 4.d --

ALTER TABLE common_lookup
DROP CONSTRAINT nn_clookup_1;

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, NULL
, 'HOME'
, 'Home'
, 1001, SYSDATE, 1001, SYSDATE
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'HOME');

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, NULL
, 'WORK'
, 'Work'
, 1001, SYSDATE, 1001, SYSDATE
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'WORK');

COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;

-- STEP 4.e --
ALTER TABLE common_lookup
DROP COLUMN common_lookup_context;

ALTER TABLE common_lookup
MODIFY common_lookup_table CONSTRAINT nn_clookup_8 NOT NULL
MODIFY common_lookup_column CONSTRAINT nn_clookup_9 NOT NULL;

CREATE UNIQUE INDEX common_lookup_u2
  ON common_lookup(common_lookup_table,common_lookup_column,common_lookup_type);

  
  SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

COLUMN constraint_name   FORMAT A22  HEADING "Constraint Name"
COLUMN search_condition  FORMAT A36  HEADING "Search Condition"
COLUMN constraint_type   FORMAT A10  HEADING "Constraint|Type"
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('common_lookup')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   UI.index_name
,        uic.column_position
,        uic.column_name
FROM     user_indexes UI INNER JOIN user_ind_columns uic
ON       UI.index_name = uic.index_name
AND      UI.table_name = uic.table_name
WHERE    UI.table_name = UPPER('common_lookup')
ORDER BY UI.index_name
,        uic.column_position;

-- STEP 4.f --

UPDATE telephone
SET telephone_type = 
CASE
  WHEN telephone_type = (
     SELECT common_lookup_id
     FROM common_lookup
     WHERE common_lookup_table = 'ADDRESS'
     AND common_lookup_column = 'ADDRESS_TYPE'
     AND common_lookup_type = 'HOME') 
  THEN (
     SELECT common_lookup_id
     FROM common_lookup
     WHERE common_lookup_table = 'TELEPHONE'
     AND common_lookup_column = 'TELEPHONE_TYPE'
     AND common_lookup_type = 'HOME')
  ELSE (
     SELECT common_lookup_id
     FROM common_lookup
     WHERE common_lookup_table = 'TELEPHONE'
     AND common_lookup_column = 'TELEPHONE_TYPE'
     AND common_lookup_type = 'WORK')
  END;
  
  COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;
  
SPOOL OFF
