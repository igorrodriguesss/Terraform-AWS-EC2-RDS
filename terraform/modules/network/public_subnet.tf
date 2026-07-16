resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.projeto_tcb.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, 0)
  availability_zone       = "${data.aws_region.current.region}a"
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-subnet-1a"
    }
  )
}


resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}