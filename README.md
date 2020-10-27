# Provisioning EC2 instances using Packer
There are two builds installed with AWS Linux images prebuilt with Docker
for prometheus and Grafana post configuration/ setup.

The builds also includes SSH keys added to the EC2 instances.

The EC2 instances are built on two separate networks with the VPC being 10.8.0.0/16 CIDR block. 
  - Promsvr1 is on 10.8.1.0/24 and is a private network only accessible via the local network.
  - Grafsvr1 is on the 10.8.2.0/24 network and is a public network accessible over the internet.
  
 Security groups have also been configured to effect the network accessibilities described above.
