# Getting all the necessary IDs
output "vpc_id" {
  value = aws_vpc.Nov-Cohort-VPC.id
}

output "vpc_cidr_block" {
  value = aws_vpc.Nov-Cohort-VPC.id
}

output "Prod-pub-sub1_id" {
  value = aws_subnet.Prod-pub-sub1.id
}

output "Prod-pub-sub2_id" {
  value = aws_subnet.Prod-pub-sub2.id
}

output "Prod-priv-sub1_id" {
  value = aws_subnet.Prod-priv-sub1.id
}

output "Prod-priv-sub2_id" {
  value = aws_subnet.Prod-priv-sub2.id
}

output "Prod-pub-route-table_id" {
  value = aws_route_table.Prod-pub-route-table.id
}

output "Prod-priv-route-table_id" {
  value = aws_route_table.Prod-priv-route-table.id
}

output "Prod-igw_id" {
  value = aws_internet_gateway.Prod-igw.id
}

output "Prod-Nat-gateway_id" {
  value = aws_nat_gateway.Prod-Nat-gateway.id
}

