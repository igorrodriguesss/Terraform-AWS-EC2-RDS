resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name = aws_key_pair.ec2_key.key_name

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ec2-instance"
    }
  )
}

