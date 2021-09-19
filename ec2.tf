resource "aws_instance" "alessandro_instance" {
  ami           = "ami-0210560cedcb09f07" # Amazon Linux AMI
  instance_type = "t2.micro" # Should be enough for this purpose
  user_data = "${file("ec2_user_data.sh")}"
  iam_instance_profile = aws_iam_instance_profile.alessandro_instance_profile.id

  credit_specification {
    cpu_credits = "unlimited"
  }

  subnet_id = aws_subnet.alessandro_subnet_a.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  
  # Uncomment the attribute below if you need SSH access to the instance
  # key_name = aws_key_pair.alessandro_key.key_name
  
  associate_public_ip_address = true
}

# Uncomment the resource below if you need SSH access to the instance
# resource "aws_key_pair" "alessandro_key" {
#   key_name   = "alessandro-key"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5/bIvZqcB+p9LEHu5Vrxjc3O3lHZXrjDtRWL56c0yiMar2rPlpdDitLMc1+RqH/Oqu7Pst2xJoCoatq076psJf2OTiqi4pzevjZ52mrwlslGJm48vL7Wjmsb6Cf6RR92eEI8CXaBkHJLOE+A5isMtSYi/LXeCvm4AmKBtwNYs5wifgW6iNXzIKlVpTFXtTwTODIFlSdgFiTYErtTPt3KuEvKRQXL6gSjgMvJ5TjW20cgIxg9D7nayiUa3egyR20+R5dsBk7WevokzWFSVasTvO/PQJmETItqw++bjjUa/tSpMAHEH7REoX784cMJrHMJ4+4vGEiCbzbne3UFIkpfjNie/o7RErZ3/BuUv/XGq49HRgX37OBILROpqTwvS9tZ4kIXDqlBNTLIYz3yI71LcxAYtN2vbKlg4bjgGyJtHlnhcmWJxvXpYj8TdlxZm8eCAFaC0SAsHqd8vWhQLiAVKxwhU5Y3uvrdwyfN5vqkupBVgKmDM5CTlKWp2hpHu7PM= alessandro@alessandro-PC-7B93"
# }