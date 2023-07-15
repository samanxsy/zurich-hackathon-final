# Block1 Solution

### Problem
Create and develop an infrastucture using an IaC, only Terraform or Cloud Formation. The infrastructure should create 2 EC2 instances in the same virtual cloud and subnet. Both instances would host services in the future. These services would be running in ports: 443 using TCP, 1337 using TCP and 3035 using TCP and UDP. Each instance should be accessed via SecureShell on the default port using a different key for each instance.


### Solution

#### VPC
1. I started with provisioning the Network by creating a Virtual Private cloud with an address range of [10.1.0.0/16]. A wide range that allows to scale the infrastructure in the future without being worry about IP addresses over lapping.

2. created a subnet from the original subnet, with a plan to be able to create more subnets in the future if needed. Thats the reason behind chosing [10.1.1.0/24] cidr block.

3. created a security group to define the inbout traffic rules. Allowed HTTPS connection by opening 443, as well as 1337, and 3035. Also, opened port 22 to allow SSH connection to the instances, but Limited the IP address to the address of the machine that created the infrastructure. So nobody else will not be able to connect and modify the servers. (Of course, choosing a defined range would be a more practical option, for example when multiple people are allowed to modify the servers remotely)

4. Then Created an Internet Gateway to allow internet connection to the subnets. Altho it was not mentioned that the services that are going to be hosted by our instances will be public or no, The SSH connection definetly needed public internet access. So I created an Internet GateWay

5. Defined a route table and attached it to the subnet, with a route to the internet gateway, to allow internet access to our EC2 instances.

#### EC2 instances
1. generated two different SSH keys on my system by running `ssh-keygen` and deployed the public keys to the aws key pair to later utilize them for SSH connection

2. The Size and image type could be decided appropriately considering the future workloads require a **compute optimized** solution, **storage optimized** solution, or **graphic optimized**. I went with the minimum AMI to simplify and fasten my process for the purpose of this Hackathon.

3. For each instance, I declared the path to their respective private keys. (Not pushed to the repo because it just feels bad, even the public key hurts).

4. When provisioned, the connection to instances can happen by running the command below:
```
ssh <path-to-private-key> ubuntu@<ec2-publicIp>
```
