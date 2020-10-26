resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "mykey"
  public_key = "${tls_private_key.tls_key.public_key_openssh}"

  depends_on = [
    tls_private_key.tls_key
  ]
}

resource "local_file" "key-file" {
  content  = "${tls_private_key.tls_key.private_key_pem}"
  filename = "mykey.pem"

  depends_on = [
    tls_private_key.tls_key
  ]
}

resource "aws_security_group" "wp_sg" {
  name        = "wp-SG"
  vpc_id      = "${aws_vpc.itsvpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "sqlSG"
  vpc_id      = "${aws_vpc.itsvpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.wp_sg.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.wp_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "wp" {
  ami             = "${var.wordpress}"
  instance_type   = "${var.inst_type}"
  key_name        = "${aws_key_pair.generated_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.wp_sg.id}"]
  subnet_id       = "${aws_subnet.pub_sn.id}"

  depends_on = [
    aws_instance.mysql,
    aws_security_group.wp_sg
  ]
}


resource "aws_instance" "mysql" {
  ami             = "${var.mysql}"
  instance_type   = "${var.inst_type}"
  key_name        = "${aws_key_pair.generated_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.mysql_sg.id}"]
  subnet_id       = "${aws_subnet.pri_sn.id}"

  depends_on = [
    aws_security_group.mysql_sg,
    aws_key_pair.generated_key
  ]
}

