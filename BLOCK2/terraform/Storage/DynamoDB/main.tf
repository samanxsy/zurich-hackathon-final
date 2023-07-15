################################################
############### D Y N A M O D B ################

# DynamoDB Table
resource "aws_dynamodb_table" "webapp_table" {
    name = "cloud-hackathon-table"
    billing_mode = "PAY_PER_REQUEST"
    deletion_protection_enabled = true
    hash_key = "id"

    point_in_time_recovery {
      enabled = true
    }

    attribute {
        name = "id"
        type = "S"
    }

    tags = {
        Name = "webapp-DB-table"
    }
}
