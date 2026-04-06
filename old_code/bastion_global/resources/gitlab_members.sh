#!/bin/bash
EC2USER="/home/ec2-user/.ssh/authorized_keys"
BASTION="/home/bastion/.ssh/authorized_keys"

echo "" > $EC2USER
echo "" > $BASTION

## !! Important ##
## This line should be filled wuth existing contents from /home/ec2-user/.ssh/authorized_keys.bak otherwise the PEM key file will no longer have ssh access##
echo "" >> $EC2USER 
#####################

# GitLab Configuration
GITLAB_URL="https://gitlab.com/api/v4"
ACCESS_TOKEN=$GITLAB_ACCESS_TOKEN
GROUP_ID="<gitlab-group-id>"
#SUBGROUP_ID=""
#TERTIARYGROUP_ID=""

# Fetch Group Members with inherited access
echo "Fetching group members..."
members=$(curl --silent --header "PRIVATE-TOKEN: $ACCESS_TOKEN" "$GITLAB_URL/groups/$GROUP_ID/members?per_page=500")

# Check if the request was successful
if [ -z "$members" ]; then
    echo "Failed to retrieve members. Check your access token or group ID."
    exit 1
fi

# Function to fetch SSH keys of a user
fetch_ssh_keys() {
    local user_id=$1
    curl --silent --header "PRIVATE-TOKEN: $ACCESS_TOKEN" "$GITLAB_URL/users/$user_id/keys"
}

# Loop through members

echo "$members" | jq -c '.[]' | while read -r member; do
    user_id=$(echo "$member" | jq -r '.id')
    username=$(echo "$member" | jq -r '.username')
    name=$(echo "$member" | jq -r '.name')
    access_level=$(echo "$member" | jq -r '.access_level')

    # Filter based on access level (modify as needed)
    if [[ "$access_level" -ge 50 ]]; then
        # Fetch and display SSH keys
        ssh_keys=$(fetch_ssh_keys "$user_id")
        if [[ -n "$ssh_keys" && "$ssh_keys" != "[]" ]]; then
            echo "$ssh_keys" | jq -r '.[].key' >> $EC2USER
            #echo "$member.access_level"
        else
            echo "No SSH keys found for $user_id.."
        fi
    else [[ "$access_level" -ge 30 ]];
        # Fetch and display SSH keys
        ssh_keys=$(fetch_ssh_keys "$user_id")
        if [[ -n "$ssh_keys" && "$ssh_keys" != "[]" ]]; then
            echo "$ssh_keys" | jq -r '.[].key' >> $BASTION
            echo "$member" | jq -r '.access_level'
        else
            echo "No SSH keys found for $user_id."
        fi
    fi
done
