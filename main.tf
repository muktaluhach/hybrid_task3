provider "aws" {
  profile = "default"
region = "us-east-1"
}

output "VPC" {
    value = "${aws_vpc.itsvpc.id}"
}

output "PublicSN" {
    value = "${aws_subnet.pub_sn.id}"
}

output "PrivateSN" {
    value = "${aws_subnet.pri_sn.id}"
}

output "DatabaseHost" {
  value = "${aws_instance.mysql.private_dns}"
}

output "WP_DNS" {
  value = "${aws_instance.wp.public_dns}"
}

resource "null_resource" "open_wordpress_site" {
  provisioner "local-exec" {
    command = "start chrome ${aws_instance.wp.public_dns}"
  }
}
