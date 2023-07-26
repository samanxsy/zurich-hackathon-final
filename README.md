# Zurich Cloud Hackathon - ON-SITE FINAL | Barcelona, July 2023 | 2ND PLACE 🥈
[![Terraform CI](https://github.com/samanxsy/zurich-hackathon-final/actions/workflows/tfcicd.yml/badge.svg)](https://github.com/samanxsy/zurich-hackathon-final/actions/workflows/tfcicd.yml)

**Zurich cloud hackathon, Powered by NUWE**  
This project was created for the **ON-SITE FINAL** in the **Zurich Technology Delivery Center** office  

**The pre-selection project**: [Zurich-Cloud-Hackathon-PreSelection](https://github.com/samanxsy/zurich-cloud-hackathon)

---
**SOLUTION SECTION**  

# THANK YOU SO MUCH ❤️
It was an INCREDIBLE experience for me. I can not put my feelings into words. It was a great pleasure and honor to be among the finalists and have the chance to meet everyone from Zurich & NUWE as well as other finalists. It meant A LOT To me.

### Objectives
**BLOCK1**
1. Create and develop an EC2 infrastructure using an IaC, only Terraform or Cloud Formation.
2. Create and automated a CI/CD pipeline using Jenkins and Gogs.

**BLOCK2**  
1. Design an infrastructure to scale efficiently the deployment of the WebApp as well as the storage of the images in the S3 AWS Bucket.
2. Implement the infrastructure of Block 2 - Part 1 using an IaC (Terraform or Cloud Formation)
3. Create a Report designed for the stakeholders of the company.

### Solutions
I divided the solutions and they can be found in `BLOCK1/` & `BLOCK2/` Directories. Also, the **README** files for each Block are placed in their respective directories

### on CI/CD
During the competition, I provisioned a CI pipeline in GitHub Action that performs basic formatting and runs a terraform plan to check for bugs, and potential infrastructure changes, due to the infrastructure complexity, I commented out the `terraform apply` step. For Jenkis, I tried to clone the same functionality of my GitHub Action pipeline and turn it into Groovy syntax. The Jenkins code can be found in the `BLOCK1/Jenkins/Jenkinsfile`

I also tried to provision a quick VM in Azure, create a Virtual Network allowing SSH and port 8080(Jenkins default) connections, installed docker on it via Ansible, pulled a Jenkins image to run, and tried to kick off the Jenkins pipeline with an actual webhook. The Azure infrastructure can be found in the AzureExtra directory.


### Final Word
Once again, I would like to appreciate the unique opportunity and experience, and Thank you both NUWE and Zurich for organizing this. Looking forward to future meetings.  

Sincerely,  
Saman Saybani
