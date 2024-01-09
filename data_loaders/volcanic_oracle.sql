UNLOAD ('SELECT * FROM mage_feature_sets.public.dbt_redshift_load_titanic')
TO 's3://tommy-test-copy/dbt_redshift_load_titanic/v8'
CREDENTIALS
'aws_access_key_id={{ env_var("AWS_ACCESS_KEY_ID") }};aws_secret_access_key={{ env_var("AWS_SECRET_ACCESS_KEY") }}'