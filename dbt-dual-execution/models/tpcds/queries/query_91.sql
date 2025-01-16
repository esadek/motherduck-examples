select
    cc_call_center_id call_center,
    cc_name call_center_name,
    cc_manager manager,
    sum(cr_net_loss) returns_loss
from
    {{ ref("call_center") }},
    {{ ref("catalog_returns") }},
    {{ ref("date_dim") }},
    {{ ref("customer") }},
    {{ ref("customer_address") }},
    {{ ref("customer_demographics") }},
    {{ ref("household_demographics") }}
where
    cr_call_center_sk = cc_call_center_sk
    and cr_returned_date_sk = d_date_sk
    and cr_returning_customer_sk = c_customer_sk
    and cd_demo_sk = c_current_cdemo_sk
    and hd_demo_sk = c_current_hdemo_sk
    and ca_address_sk = c_current_addr_sk
    and d_year = 1998
    and d_moy = 11
    and (
        (cd_marital_status = 'M' and cd_education_status = 'Unknown')
        or (cd_marital_status = 'W' and cd_education_status = 'Advanced Degree')
    )
    and hd_buy_potential like 'Unknown%'
    and ca_gmt_offset = -7
group by cc_call_center_id, cc_name, cc_manager, cd_marital_status, cd_education_status
order by sum(cr_net_loss) desc
