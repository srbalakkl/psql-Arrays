
--ARRAY IN PSQL--
CREATE TEMP TABLE shopping_cart
(
    cart_id  serial PRIMARY KEY,
    products text ARRAY --(or) TEXT[]
);

-- DROP TABLE shopping_cart;

-- INSERTING INTO ARRAY --
INSERT INTO shopping_cart(products)
VALUES
    --'{"product_a", "product_bz"}',
    -- OR the another way to insert is
    (ARRAY ['prod 1','prod 2']),
    (ARRAY ['prod 3','prod 4']);

SELECT *
FROM shopping_cart;

--UN-NESTING THE ARRAY.--
-- used to unnest the array for specific rows,
-- used to JOIN with some other table
-- or To perform other operation on the list basis.
SELECT cart_id,
       UNNEST(products) AS products
FROM shopping_cart;


--ACCESSING ARRAY ITEMS BASED ON INDEX --

-- Note: Indexing in PostgresSQL Arrays starts at 1, not at 0,
-- which may differ from what you are used to in other programming languages.

-- eg 1:    using index position,
-- In this example,We are getting the 1st element by using its index position 1.
SELECT cart_id,
       products[1] AS first_product -- indexing starts at 1
FROM shopping_cart
WHERE cart_id IN (1, 2);

-- eg2:     using slice works with start & end indexing,
--Note: CARDINALITY keyword will return the number of
-- items in the array as an integer
SELECT cart_id,
       products[0:1] AS first_two_products
FROM shopping_cart
WHERE CARDINALITY(products) >= 2;


--FILTER BY AN ARRAY ELEMENT--
-- eg 1:
-- any() or some() functions are used to do filter operation in array values.
SELECT
    cart_id,
    products
FROM
    shopping_cart
WHERE
        'prod 1' = ANY (products);--or some(products)

-- eg 2:
-- The Contains operator
-- another way to filter an array
SELECT
    cart_id,
    products
FROM
    shopping_cart
WHERE
        products  @> ARRAY['product_a', 'product_b'];

-- Updating the Array
UPDATE
    shopping_cart
SET
    products = ARRAY['product_a','product_b','product_e']
WHERE
        cart_id = 1;

-- PREPEND AND APPEND --
-- ARRAY_APPEND is used to insert the value to the end position of the array.
-- ARRAY_APPEND is used to insert the value to the start position of the array.
UPDATE
    shopping_cart
SET
    products = ARRAY_APPEND(products, 'product_x')
WHERE
    cart_id = 1;

-- REMOVING ARRAY ITEMS --
-- This allows you to either remove an item from the Arrays for all rows or
-- just one specific item when used with a WHERE clause.

UPDATE
    shopping_cart
SET
    products = array_remove(products, 'product_a')
WHERE cart_id = 1;


-- CONCAT ARRAYS --
-- concatenate PostgresSQL Arrays into one larger Array with ARRAY_CAT as follows:
-- this will show all the array with the given value.
SELECT
    cart_id,
    ARRAY_CAT(products, ARRAY['promo_product_1', 'promo_product_2','show bala'])
FROM shopping_cart
ORDER BY cart_id;