data "aws_availability_zones" "available" {}

resource "aws_subnet" "private_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.projeto_tcb.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 1) # desloca para não conflitar com públicas
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-subnet-1${substr(data.aws_availability_zones.available.names[count.index], length(data.aws_region.current.region), -1)}"
    }
  )
}

