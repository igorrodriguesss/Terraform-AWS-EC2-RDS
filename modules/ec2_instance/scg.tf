resource "aws_security_group" "ec2_security_group" {
  name        = "${var.project_name}-ec2-security-group"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
     protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}


  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ec2-security-group"
    }
  )
}