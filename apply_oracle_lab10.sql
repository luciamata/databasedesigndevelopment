-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab10.sql
--  Lab Assignment: Lab #10
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
--   sql> @apply_oracle_lab10.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql

SPOOL apply_oracle_lab10.txt

-- Step 1 -- 

SELECT DISTINCT
    r.rental_id
,   c.contact_id
,   tu.check_out_date AS check_out_date
,   tu.return_date AS return_date
,   1001 AS created_by
,   TRUNC(SYSDATE) AS creation_date
,   1001 AS last_updated_by
,   TRUNC(SYSDATE) AS last_update_date
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id
INNER JOIN transaction_upload tu
ON c.first_name = tu.first_name
AND NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND c.last_name = tu.last_name
AND m.account_number = tu.account_number
LEFT JOIN rental r
ON c.contact_id = r.customer_id
AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
AND TRUNC(tu.return_date) = TRUNC(r.check_out_date);


INSERT INTO rental
SELECT   NVL(r.rental_id,rental_s1.NEXTVAL) AS rental_id
,        r.contact_id
,        r.check_out_date
,        r.return_date
,        r.created_by
,        r.creation_date
,        r.last_updated_by
,        r.last_update_date
FROM (SELECT DISTINCT
    r.rental_id
,   c.contact_id
,   tu.check_out_date AS check_out_date
,   tu.return_date AS return_date
,   1001 AS created_by
,   TRUNC(SYSDATE) AS creation_date
,   1001 AS last_updated_by
,   TRUNC(SYSDATE) AS last_update_date
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id
INNER JOIN transaction_upload tu
ON c.first_name = tu.first_name
AND NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND c.last_name = tu.last_name
AND m.account_number = tu.account_number
LEFT JOIN rental r
ON c.contact_id = r.customer_id
AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
AND TRUNC(tu.return_date) = TRUNC(r.check_out_date)) r;

COL rental_count FORMAT 999,999 HEADING "Rental|after|Count"
SELECT   COUNT(*) AS rental_count
FROM     rental;

-- Step 2 --

SELECT
    ri.rental_item_id
,   r.rental_id
,   tu.item_id
,   cl.common_lookup_id AS rental_item_type
,   r.return_date - r.check_out_date AS rental_item_price
,   1001 AS created_by
,   TRUNC(SYSDATE) AS creation_date
,   1001 AS last_updated_by
,   TRUNC(SYSDATE) AS last_update_date
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id
INNER JOIN transaction_upload tu
ON c.first_name = tu.first_name
AND NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND c.last_name = tu.last_name
AND m.account_number = tu.account_number
LEFT JOIN rental r
ON c.contact_id = r.customer_id
AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
AND TRUNC(tu.return_date) = TRUNC(r.return_date)
INNER JOIN common_lookup cl
ON cl.common_lookup_table = 'RENTAL_ITEM'
AND cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
AND cl.common_lookup_type = tu.rental_item_type
LEFT JOIN rental_item ri 
ON r.rental_id = ri.rental_id;

COL rental_item_count FORMAT 999,999 HEADING "Rental|Item|Before|Count"
SELECT   COUNT(*) AS rental_item_count
FROM     rental_item;

INSERT INTO rental_item
(SELECT   NVL(ri.rental_item_id,rental_item_s1.NEXTVAL)
 ,         r.rental_id
 ,        tu.item_id
 ,        1001 AS created_by
 ,        TRUNC(SYSDATE) AS creation_date
 ,        1001 AS last_updated_by
 ,        TRUNC(SYSDATE) AS last_update_date
 ,        cl.common_lookup_id AS rental_item_type
 ,        r.return_date - r.check_out_date AS rental_item_price
 FROM     member m INNER JOIN contact c
 ON       m.member_id = c.member_id 
 INNER JOIN transaction_upload tu
 ON       c.first_name = tu.first_name
 AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
 AND      c.last_name = tu.last_name
 AND      tu.account_number = m.account_number
 LEFT JOIN rental r
 ON c.contact_id = r.customer_id
 AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
 AND TRUNC(tu.return_date) = TRUNC(r.return_date)
 INNER JOIN common_lookup cl
 ON cl.common_lookup_table = 'RENTAL_ITEM'
 AND cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
 AND cl.common_lookup_type = tu.rental_item_type
 LEFT JOIN rental_item ri 
 ON r.rental_id = ri.rental_id);
 
 COL rental_item_count FORMAT 999,999 HEADING "Rental|Item|after|Count"
SELECT   COUNT(*) AS rental_item_count
FROM     rental_item;

-- Step 3 --

SELECT 
    t.transaction_id
,   tu.payment_account_number AS transaction_account
,   cl1.common_lookup_id AS transaction_type
,   tu.transaction_date
,   (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
,   r.rental_id
,   cl2.common_lookup_id AS payment_method_type
,   m.credit_card_number AS payment_account_number
,   1001 AS created_by
,   SYSDATE AS creation_date
,   1001 AS last_updated_by
,   SYSDATE AS last_update_date
 FROM     member m INNER JOIN contact c
 ON       m.member_id = c.member_id 
 INNER JOIN transaction_upload tu
 ON       c.first_name = tu.first_name
 AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
 AND      c.last_name = tu.last_name
 AND      tu.account_number = m.account_number
 LEFT JOIN rental r
 ON c.contact_id = r.customer_id
 AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
 AND TRUNC(tu.return_date) = TRUNC(r.return_date)
 INNER JOIN common_lookup cl1
 ON cl1.common_lookup_table = 'TRANSACTION'
 AND cl1.common_lookup_column = 'TRANSACTION_TYPE'
 AND cl1.common_lookup_type = tu.transaction_type
 INNER JOIN common_lookup cl2
 ON cl2.common_lookup_table = 'TRANSACTION'
 AND cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
 AND cl2.common_lookup_type = tu.payment_method_type
 LEFT JOIN transaction t
 ON t.transaction_account = tu.payment_account_number
 AND t.rental_id = r.rental_id
 AND t.transaction_type = cl1.common_lookup_id
 AND t.transaction_date = tu.transaction_date
 AND t.payment_method_type = cl2.common_lookup_id
 AND t.payment_account_number = m.credit_card_number
 GROUP BY t.transaction_id
,   tu.payment_account_number 
,   cl1.common_lookup_id 
,   tu.transaction_date
,   r.rental_id
,   cl2.common_lookup_id 
,   m.credit_card_number 
,   1001
,   TRUNC(SYSDATE) 
,   1001
,   TRUNC(SYSDATE);

INSERT INTO TRANSACTION
SELECT   NVL(t.transaction_id,transaction_s1.NEXTVAL) transaction_id
,        t.transaction_account
,        t.transaction_type
,        t.transaction_date
,        t.transaction_amount
,        t.rental_id
,        t.payment_method_type
,        t.payment_account_number
,        t.created_by
,        t.creation_date
,        t.last_updated_by
,        t.last_update_date
FROM    (SELECT   t.transaction_id
         ,        tu.payment_account_number AS transaction_account
         ,        cl1.common_lookup_id AS transaction_type
         ,        tu.transaction_date
         ,       (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
         ,        r.rental_id
         ,        cl2.common_lookup_id AS payment_method_type
         ,        m.credit_card_number AS payment_account_number
         ,        1001 AS created_by
         ,        TRUNC(SYSDATE) AS creation_date
         ,        1001 AS last_updated_by
         ,        TRUNC(SYSDATE) AS last_update_date
        FROM     member m INNER JOIN contact c
            ON       m.member_id = c.member_id 
            INNER JOIN transaction_upload tu
            ON       c.first_name = tu.first_name
            AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
            AND      c.last_name = tu.last_name
            AND      tu.account_number = m.account_number
            LEFT JOIN rental r
            ON c.contact_id = r.customer_id
            AND TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
            AND TRUNC(tu.return_date) = TRUNC(r.return_date)
            INNER JOIN common_lookup cl1
            ON cl1.common_lookup_table = 'TRANSACTION'
            AND cl1.common_lookup_column = 'TRANSACTION_TYPE'
            AND cl1.common_lookup_type = tu.transaction_type
            INNER JOIN common_lookup cl2
            ON cl2.common_lookup_table = 'TRANSACTION'
            AND cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
            AND cl2.common_lookup_type = tu.payment_method_type
            LEFT JOIN transaction t
            ON t.transaction_account = tu.payment_account_number
            AND t.rental_id = r.rental_id
            AND t.transaction_type = cl1.common_lookup_id
            AND t.transaction_date = tu.transaction_date
            AND t.payment_method_type = cl2.common_lookup_id
            AND t.payment_account_number = m.credit_card_number
         GROUP BY t.transaction_id
         ,        tu.payment_account_number
         ,        cl1.common_lookup_id
         ,        tu.transaction_date
         ,        r.rental_id
         ,        cl2.common_lookup_id
         ,        m.credit_card_number
         ,        1001
         ,        TRUNC(SYSDATE)
         ,        1001
         ,        TRUNC(SYSDATE)) t;

COL transaction_count FORMAT 999,999 HEADING "Transaction|After|Count"
SELECT   COUNT(*) AS transaction_count
FROM     TRANSACTION;

SPOOL OFF
