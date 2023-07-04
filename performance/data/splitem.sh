counter=100
jq -c '.[]' billing_account.json | while read -r item; do echo "$item" > "billing_account/billing_account_${counter}.json"; let counter=counter+1; done
