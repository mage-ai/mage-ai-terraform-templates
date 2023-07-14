# networking.tf | Network Configuration

# us-west-2a
data "aws_subnet" "subnet_1" {
  id = "subnet-0b196fcc05bfd0b0b"
}

# us-west-2b
data "aws_subnet" "subnet_2" {
  id = "subnet-0ab32913852640bf3"
}
