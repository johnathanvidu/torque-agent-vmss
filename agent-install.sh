#!/bin/bash
TOKEN=<Torque API Token>
AGENT=vmss-agent

# install docker
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install docker-compose
curl -SL https://github.com/docker/compose/releases/download/v2.17.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo apt-get install jq unzip -y

# download deployment file
curl -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -X POST -d '{"host_name": "'"$AGENT"'", "host_type": "vcenter"}' https://portal.qtorque.io/api/settings/executionhosts/deployment/url | jq -r '("https://portal.qtorque.io/api/settings/executionhosts/deployment/" + .token + "/" + .fileName)' | xargs -I {} curl -H "Authorization: Bearer $TOKEN" {} -o deployment.zip
unzip deployment.zip

# run permission
cd deployment
chmod +x ./deploy_torque_agent.sh
chmod +x ./deploy_agent.sh

# deploy agent
./deploy_agent.sh $AGENT "{}"

# cleanup
rm -f ../deployment.zip
rm -rf ../deployment/
