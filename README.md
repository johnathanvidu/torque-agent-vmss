### Torque agent installation instructions on VMSS 

this guide describes how to install torque agent on a new VMSS, but you can tweak it to your specific use case

#### Prerequisites
1. torque agent 
    1. go to Manage, then Agents
    2. click on New Agent in the top right corner
    3. select vCenter, then Docker and give it a name (**keep the name**, we'll use it later on)
    4. click "skip for now"
2. torque long token 

![](/img/token.gif)

#### VMSS
go to [portal.azure.com](https://portal.azure.com) and search for VMSS.

click on Create 
![](/img/create.png)

select your image (make sure it ships with docker pre-installed) 
![](/img/image.png)

then jump to the Advanced tab and paste the [script](https://raw.githubusercontent.com/QualiTorque/torque-agent-vmss/main/agent-install.sh) in the **Custom data** section under Custom data and cloud init 
![](/img/customdata.png)

replace *TOKEN* with the token you generated earlier in torque, and *AGENT* with the name of the torque agent you wish to use
continue with creating the VMSS

log into the machine (we used ssh in this example) and run the following:
```
sudo docker ps -a
```

if all successful you should see two containers 
![](/img/containers.png)

make sure that you see your agent in active state back in the agents page in torque

#### Troubleshooting
if you can't see the containers, you can start by examining the cloud-init log file
```
sudo cat /var/log/cloud-init-output.log
```
we'd be happy to assist!
