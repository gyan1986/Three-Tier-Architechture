resource "aws_instance" "web" {
  count                       = 1
  ami                         = "ami-061fbd84f343c52d5"
  instance_type               = "t2.micro"
  key_name                    = "web_keypair"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  subnet_id                   = count.index == 0 ? aws_subnet.private01.id : aws_subnet.private02.id
  #associate_public_ip_address = true
  user_data = templatefile("user_data.sh", {
    rds_endpoint = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["endpoint"]
    rds_password = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"]
  })
  tags = {
    Name = "web_${count.index}"
  }

  depends_on = [
    aws_db_instance.rds01
  ]
}

resource "aws_instance" "jumpbox" {
  ami                         = "ami-0b3053411345882ee"
  instance_type               = "t2.small"
  key_name                    = "web_keypair"
  vpc_security_group_ids      = [aws_security_group.web_sg_public.id]
  subnet_id                   = aws_subnet.public01.id
  associate_public_ip_address = true
  tags = {
    Name = "Jumpbox"
  }

  depends_on = [
    aws_db_instance.rds01
  ]
}
