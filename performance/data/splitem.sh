counter=100
jq -c '.[]' users.json | while read -r item; do echo "$item" > "user_${counter}.json"; let counter=counter+1; done
