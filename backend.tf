terraform {
  backend "s3" {
      bucket = "talent-academy-471202980415-tfstates"
      key = "sprint2/basic-vpc/ring_challenge.tfstates"
      region = "eu-west-1"
      #dynamodb_table = "terraform-lock"
  }
}



