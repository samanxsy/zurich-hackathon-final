# zurich-hackathon-final
[![Terraform CI](https://github.com/samanxsy/zurich-hackathon-final/actions/workflows/tfcicd.yml/badge.svg)](https://github.com/samanxsy/zurich-hackathon-final/actions/workflows/tfcicd.yml)


# THANK YOU SO MUCH ❤️
It was an INCREDIBLE experience for me. I can not put my feelings into words. It was a great pleasure and honor to be among the finalists and have the chance to meet everyone from Zurich & NUWE as well as other finalists. It meant A LOT To me.


### Solutions
I divided the solutions and they can be found in `BLOCK1/` & `BLOCK2/` Directories. Also, the **README** files for each Block are placed in their respective directories

### on CI/CD
During the competition, I provisioned a CI pipeline in GitHub Action that performs basic formatting and runs a terraform plan to check for bugs, and potential infrastructure changes, due to the infrastructure complexity, I commented out the `terraform apply` step. For Jenkis, I tried to clone the same functionality of my GitHub Action pipeline and turn it into Groovy syntax. The Jenkins code can be found in the `BLOCK1/Jenkins/Jenkinsfile`

I also tried to provision a quick VM in Azure, create a Virtual Network allowing SSH and port 8080(Jenkins default) connections, installed docker on it via Ansible, pulled a Jenkins image to run, and tried to kick off the Jenkins pipeline with an actual webhook. The Azure infrastructure can be found in the AzureExtra directory.


### Final Word
Once again, I would like to appreciate the unique opportunity and experience, and Thank you both NUWE and Zurich for organizing this. Looking forward to future meetings.  

Sincerely,  
Saman
