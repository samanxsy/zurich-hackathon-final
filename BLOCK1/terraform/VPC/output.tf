output "zurich_vpc_id" {
    value = aws_vpc.zurich_vpc.id
}

output "zurich_subnet_id" {
    value = aws_subnet.zurich_subnet.id
}

output "zurich_security_group" {
    value = aws_security_group.zurich_sg.id
}
