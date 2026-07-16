resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.project_name}-key"
  public_key = file("~/.ssh/minha-chave-ec2.pub")

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-key"
    }
  )
}
