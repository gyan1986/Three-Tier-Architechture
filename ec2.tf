resource "aws_instance" "web" {
  count                       = 2
  ami                         = "ami-061fbd84f343c52d5"
  instance_type               = "t2.micro"
  key_name                    = "web_keypair"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  subnet_id                   = count.index == 0 ? aws_subnet.private01.id : aws_subnet.private02.id
  associate_public_ip_address = false
  user_data                   = file("user_data.sh")
  tags = {
    Name = "web_${count.index}"
  }
}