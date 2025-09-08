select i_product_name, i_brand, i_class, i_category, avg(inv_quantity_on_hand) qoh
from {{ ref("inventory") }}, {{ ref("date_dim") }}, {{ ref("item") }}
where
    inv_date_sk = d_date_sk
    and inv_item_sk = i_item_sk
    and d_month_seq between 1200 and 1200 + 11
group by rollup (i_product_name, i_brand, i_class, i_category)
order by
    qoh nulls first,
    i_product_name nulls first,
    i_brand nulls first,
    i_class nulls first,
    i_category nulls first
limit 100
