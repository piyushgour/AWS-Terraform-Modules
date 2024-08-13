# outputs.tf

# Output the VPC ID
output "web_vpc_id" {
  description = "The ID of the Web VPC"
  value       = aws_vpc.web_vpc.id
}

# Output the VPC CIDR Block
output "web_vpc_cidr_block" {
  description = "The CIDR block of the Web VPC"
  value       = aws_vpc.web_vpc.cidr_block
}

# Output the Subnet IDs
output "web_vpc_subnet_ids" {
  description = "The IDs of the subnets in the Web VPC"
  value       = aws_subnet.web_vpc_subnet[*].id
}

# Output the Subnet CIDR Blocks
output "web_vpc_subnet_cidr_blocks" {
  description = "The CIDR blocks of the subnets in the Web VPC"
  value       = aws_subnet.web_vpc_subnet[*].cidr_block
}
