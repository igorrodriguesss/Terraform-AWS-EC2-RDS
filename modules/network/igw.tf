resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.projeto_tcb.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-igw"
    }
  )
}
