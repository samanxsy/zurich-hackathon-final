# Solution for Bock 2

### Problem
being able to efficiently scale a WebApp for uploading images into an S3 AWS bucket

### Solution
To create a scalable solution for a web application as well as a scalable answer to storing photos, I decided to design a 3-tier Serverless web app. The reason behind going serverless was to be able to provision the resources that are Highly available and Highly scalable by design, and have a more cost-effecitve approach. The solution includes:

- **Frontend & Content Access**
    - S3 Bucket for Hosting the static (HTML, CSS, JS) files, and serving as the Frontend
    - CloudFront, the Content Delivery service of AWS for caching the data next to the end users
    - Route53 to manage website domain
- **Backend**
    - Lambda functions to handle the application's backend logic. The number of Lambda functions depends on the web application's complexity. In the Diagaram I draw 4 to show the possibility.

- **Storage**
    - DynamoDB for storing the customer data as we did in the first phase
    - S3 bucket for storing the photos, Which is a Highly scalable storage solution by design.

### Why Amazon S3 for Photo Storage
**S3 as the photo storage**  
By choosing S3 as storage for photos, we leverage the built-in scalability and availability that S3 holds. To Make Our photo storage a more cost-effective and reliable solution I added the following features to it:  
- **Versioning**: I added versioning to avoid accidental deletion/overwriting of the objects(Photos), as well as to protect the objects from potential application failures. When Versioning is enabled, it keeps multiple versions of the photos, this makes the recovery much easier. For example, if a photo is accidentally deleted, it will not actually delete the photo, instead, it inserts a delete marker, and with that, we can always recover the previous version.

- **Logging**: Enabling Logging for our bucket will help to gain valuable insights about its capacity and operation behavior.

- **Lifecycle**: To manage costs as the number of photos will grow, and damage cases will be closed, therefore the photos may not be accessed as frequently as the cases were open, I defined a LifeCycle rule to move the photos to more cost-efficient storage after a period of time.  
I set the rules to move the photos to **S3 Glacier** after a year and eventually to **Deep Archive** after 720 days. This approach can help reduce the cost of storage.

- **Server Side Encryption**: By enabling serverside encryption, we can protect our data at rest. The encryption uses an AWS-managed service for storing the encryption keys. The key rotation also has been enabled to change the keys once in a period, to enhance security

### Why Lambda over EC2 instances
Lambda functions can scale automatically in response to high traffic. It's not only about scalibility, Lambda functions are more cost-efficient too. Instead of having EC2 servers constantly up and running, With Lambda we only pay for the compute time.  

### Why S3 as webserver
In this architecture, choosing S3 as web server is again a more cost-effectieve approach. It removes the overhead for provisioning Network, as well as the need to create EC2 instances to run webserver on them.

# Design and Diagram
The serverless solution I designed for this problem, is planned to work as below:  
1. The client (Users) send a request to the application domain (**Route53**)
2. The Content Delivery serivce (**CloudFront**) caches the website data (static files hosted by S3) in a location close to user
3. The cloudfront responses with the web app frontend
4. User interacts with the application, and the requests are sent to API GateWay
5. API GateWay sends the request to the Lambda Functions that have apporpriate RBAC rules attached to them.
6. Lambda functions interact with the DynamoDB to return customer data, or insert photos of the damaged cars into our Highly Scalable S3 Bucket.
7. The reponses from the lambda functions are then returned to the Client through the GateWayt

**Note**: Number of lambda functions in the Diagram is not fixed, and can be changed depending on the backend logic requirements

![finaldraw drawio](https://github.com/samanxsy/zurich-hackathon-final/assets/118216325/a937c0be-fa91-4439-b287-85346efab5d0)
- **White solid line** represents the Client Request
- **Blue dotted line** represents the Server Response
