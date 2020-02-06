output "arn" {
 value = aws_vpc.this.arn
}

output "id" {
 value = aws_vpc.this.id
}

output "cidr_block" {
 value = aws_vpc.this.cidr_block
}

output "main_route_table" {
 value = aws_vpc.this.main_route_table_id
}