#! /bin/bash

member_script="/gitlab_members.sh"

yum update -y
yum upgrade -y
yum install fail2ban jq -y

adduser bastion
mkdir /home/bastion/.ssh
touch /home/bastion/.ssh/authorized_keys

touch $member_script
chmod 766 $member_script

# Copy the authorized to bak file to prevent overwriting the default access.
cp "/home/ec2-user/.ssh/authorized_keys" "/home/ec2-user/.ssh/authorized_keys.bak"


set +e
crontab -l > mycron
echo "*/10 * * * * /gitlab_members.sh" >> mycron
crontab mycron
rm mycron
set -e

cat > $member_script << 'EOL'
#!/bin/bash
EC2USER="/home/ec2-user/.ssh/authorized_keys"
BASTION="/home/bastion/.ssh/authorized_keys"

# GitLab Configuration
GITLAB_URL="https://gitlab.com/api/v4"
ACCESS_TOKEN="<gitlab-access-token>"
GROUP_ID="<gitlab-group-id>"

echo "" > $EC2USER
echo "" > $BASTION

## !! Important ##
## This line should be filled wuth existing contents from /home/ec2-user/.ssh/authorized_keys.bak otherwise the PEM key file will no longer have ssh access##
cat "/home/ec2-user/.ssh/authorized_keys.bak"  >> $EC2USER 
#####################

# Fetch Group Members with inherited access
echo "Fetching group members..."
members=$(curl --silent --header "PRIVATE-TOKEN: $ACCESS_TOKEN" "$GITLAB_URL/groups/$GROUP_ID/members/all?per_page=500")

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
        else
            echo "No SSH keys found for $user_id.."
        fi
    else [[ "$access_level" -ge 30 ]];
        # Fetch and display SSH keys
        ssh_keys=$(fetch_ssh_keys "$user_id")
        if [[ -n "$ssh_keys" && "$ssh_keys" != "[]" ]]; then
            echo "$ssh_keys" | jq -r '.[].key' >> $BASTION
        else
            echo "No SSH keys found for $user_id."
        fi
    fi
done

EOL

bash $member_script