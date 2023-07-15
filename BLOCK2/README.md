# Solution for Bock 2

### Problem
being able to efficiently scale a WebApp for uploading images into an S3 AWS bucket

### Solution
To create the a scalable solution for a web application as well as a scalable answer to storing Photoes, I decided to design a 3-tier Serverless web app. The reason behind going serverless was to be able to provision the resources that are Highly available and Highly scalable by design. The solution includes:

- **Frontend & Content Access**
    - S3 Bucket for Hosting the static (HTML,CSS,JS) files, and serving as the Frontend
    - CloudFront, the Content Delivery service of the AWS for caching the data next to the end users
    - Route53 to manage website domain
- **Backend**
    - Lambda functions to handle the application backend logic. The number of Lambda function depends on the web application complexity. In the Diagaram I draw 4 to show the possibility.

- **Storage**
    - DynamoDB for storing the customer data like we did in the first phase
    - S3 bucket for storing the photoes, Which is a Highly scalable storage solutuion by design.

### Reasons for choosing S3
**S3 as the photo storage**  
By choosing S3 as storage for photoes, we leverage the built in scalability and availablity that S3 holds. To Make Our photo storage a more cost effective and reliable solution I added the following features to it:  
- **Versioning**: I added versioning to avoid accidental deletion/overrwriting of the objects(Photoes), as well as to protect the objects from potential application failures. When Versioning is enabled, it keeps multiple version of the photoes, this makes the recovery much easier. For example, if a photo is accidently deleted, it will not actually delete the photo, instead it inserts a delete marker, and with that, we can always recover the previous version.

- **Logging**: Enabling Logging for our bucket will help to gain valuable insights about it's capacity and operation behavior.

- **Lifecycle**: To manage costs as number of photoes will grow, and damage cases will be closed, therefore the photoes may not be accessed as frequently as the cases were open, I defined a LifeCycle rule to move the photoes to a cheaper storage after a period of time.  
I set the rules to move the photoes to **S3 Glacier** after a year, and eventually to **Deep Archive** after 720 days. This approach can help reducing the cost of storage.

- **Server Side Encryption**: By enabling serverside encryption, we can protect our data at rest. The encryption uses an AWS managed service for storing the encryption keys. The key rotation is also enabled to change the keys once in a period, to enhance security


# Diagram
![serverless-arch](https://github.com/samanxsy/zurich-hackathon-final/assets/118216325/d817bbbe-7e51-46cd-b941-4f372a7e1c29)

