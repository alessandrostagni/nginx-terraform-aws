resource "aws_instance" "alessandro_instance" {
  ami           = "ami-0d2f34c92aa48cd95" # Debian 10 AMI. Something lighter than Ubuntu.
  instance_type = "t2.micro" # Should be enough for this purpose
  user_data = "${file("ec2_user_data.sh")}"
  #security_group = "" # TODO

  network_interface {
    network_interface_id = aws_network_interface.alessandro_network_interface.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}