{{ config(materialized='table') }}

WITH tripadvisor__review__source_name AS (
    SELECT *
    FROM {{ source('raw_tripadvisor', 'source_tripadvisor__scrape_info') }}
)

, tripadvisor__review__rename_column AS (
    SELECT 
        location_id
        , location_url
        , address_from_url AS location_address
        , google_maps_link AS location_map
        , lat AS latitude
        , long AS longitude
        , tel AS phone_number
        , open_hour AS open_hour
        , price_range 
        , c.element AS cuisine
        , ranking AS location_rank
        , rating AS location_overall_rate
        , review_count 
        , review_count_scraped
        , e.element.rating AS location_rating
        , e.element.review_date AS review_date
        , e.element.review_type AS review_type
        , e.element.text AS review_description
        , e.element.title AS review_title
        , e.element.user AS user
    FROM tripadvisor__review__source_name
    , UNNEST(reviews.list) AS e
    , UNNEST(cuisine.list) AS c
)

SELECT *
FROM tripadvisor__review__rename_column