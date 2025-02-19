{{ config(
        alias ='events',
        materialized ='incremental',
        file_format ='delta',
        incremental_strategy='merge',
        unique_key='unique_trade_id'
        )
}}

SELECT blockchain,
project,
version,
block_time,
token_id,
collection,
amount_usd,
token_standard,
trade_type,
number_of_items,
trade_category,
evt_type,
seller,
buyer,
amount_original,
amount_raw,
currency_symbol,
currency_contract,
nft_contract_address,
project_contract_address,
aggregator_name,
aggregator_address,
block_number,
tx_hash,
tx_from,
tx_to,
platform_fee_amount_raw,
platform_fee_amount,
platform_fee_amount_usd,
platform_fee_percentage,
royalty_fee_amount_raw,
royalty_fee_amount,
royalty_fee_amount_usd,
royalty_fee_percentage,
royalty_fee_receive_address,
royalty_fee_currency_symbol,
unique_trade_id
FROM
(SELECT * FROM {{ ref('opensea_ethereum_events') }} 

                                UNION

SELECT blockchain,
project,
version,
block_time,
NULL::string as token_id,
NULL::string as collection,
amount_usd,
token_standard,
NULL::string as trade_type,
NULL::string as number_of_items,
NULL::string as trade_category,
evt_type,
NULL::string as seller,
NULL::string as buyer,
amount_original,
amount_raw,
currency_symbol,
currency_contract,
NULL::string as nft_contract_address,
project_contract_address,
NULL::string as aggregator_name,
NULL::string as aggregator_address,
block_number,
tx_hash,
NULL::string as tx_from,
NULL::string as tx_to,
NULL::double as platform_fee_amount_raw,
NULL::double as platform_fee_amount,
NULL::double as platform_fee_amount_usd,
NULL::string as platform_fee_percentage,
NULL::double as royalty_fee_amount_raw,
NULL::double as royalty_fee_amount,
NULL::double as royalty_fee_amount_usd,
NULL::string as royalty_fee_percentage,
NULL::double as royalty_fee_receive_address,
NULL::double as royalty_fee_currency_symbol,
unique_trade_id
FROM {{ ref('opensea_solana_events') }}) 

{% if is_incremental() %}
-- this filter will only be applied on an incremental run
WHERE block_time > now() - interval 2 days
{% endif %} 

