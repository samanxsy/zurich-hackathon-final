# Block1 Solution

### Problem
Create and develop infrastructure using an IaC, only Terraform or Cloud Formation. The infrastructure should create 2 EC2 instances in the same virtual cloud and subnet. Both instances would host services in the future. These services would be running in ports: 443 using TCP, 1337 using TCP, and 3035 using TCP and UDP. Each instance should be accessed via SecureShell on the default port using a different key for each instance.


### Solution

#### VPC
1. I started with provisioning the Network by creating a Virtual Private cloud with an address range of [10.1.0.0/16]. A wide range allows us to scale the infrastructure in the future without being worried about IP addresses overlapping.

2. created a subnet from the original subnet, with a plan to be able to create more subnets in the future if needed. That's the reason behind choosing [10.1.1.0/24] CIDR block.

3. created a security group to define the inbound traffic rules. Allowed HTTPS connection by opening 443, as well as 1337, and 3035. Also, opened port 22 to allow SSH connection to the instances, but Limited the IP address to the address of the machine that created the infrastructure. So nobody else will not be able to connect and modify the servers. To achieve that, I wrote a shell script that fetches the current public IP of the device creating the infrastructure. Of course, choosing a defined range instead of one specific public IP is a more practical option, But I kept it tight due to not having a defined range.

4. Then Created an Internet Gateway to allow Internet connection to the subnets. Altho it was not mentioned whether the services that are going to be hosted by our instances will be public or not, The SSH connection definitely needed public internet access. So I created an Internet GateWay

5. Defined a route table and attached it to the subnet, with a route to the internet gateway, to allow internet access to our EC2 instances.

#### EC2 instances
1. generated two different SSH keys on my system by running `ssh-keygen` and deployed the public keys to the aws key pair to later utilize them for SSH connection

2. The Size and image type could be decided appropriately considering the future workloads require a **compute optimized** solution, **storage optimized** solution, or **graphic optimized**. I went with the minimum AMI to simplify and fasten my process for the purpose of this Hackathon.

3. For each instance, I declared the path to their respective private keys. I didn't push the private keys to the repo, neither intended to push the public key, but had to do that keys to test my GitHub Actions quickly).

4. When provisioned, the connection to instances can happen by running the command below:
```
ssh <path-to-private-key> ubuntu@<ec2-publicIp>
```


#### CI/CD & Jenkins
Due to panic time, I configured a CI pipeline in GitHub actions while we were in the Zurich office. The pipeline gets triggered by any change pushed to the master branch and starts running some basic formatting and tests, and eventually applies the infrastructure. Changes to the README file do not trigger the workflow. Also, I tried to bring the same pipeline functionality to a groovy syntax as well and tried it in a Jenkins running on docker, in an Azure VM, to be able to use an actual Payload URL.

For the security of the infrastructure, I've adopted **Snyk**, and it constantly monitors the code as I write it, as well as being integrated with my git repositories to scan the code base as it ages over time to be notified about the new vulnerabilities.


### Infrastructure Diagram
![block1 drawio](https://github.com/samanxsy/zurich-hackathon-final/assets/118216325/a1277b48-770c-4e9b-a478-d8b3cf4a54e8)

