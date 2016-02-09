resource "aws_security_group" "log_security_group" {
  name = "LogSecurityGroup"
  description = "Enable td-agent access"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 24224
    to_port = 24224
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port = 24224
    to_port = 24224
    protocol = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_security_group_rule" "shared_security_group_inbound_rule_fluentd" {
    type = "ingress"
    from_port = 24224
    to_port = 24224
    protocol = "tcp"
    security_group_id = "${var.shared_security_group}"
    source_security_group_id = "${aws_security_group.log_security_group.id}"
}

resource "aws_security_group_rule" "shared_security_group_inbound_rule_heartbeat" {
    type = "ingress"
    from_port = 24224
    to_port = 24224
    protocol = "udp"
    security_group_id = "${var.shared_security_group}"
    source_security_group_id = "${aws_security_group.log_security_group.id}"
}

resource "aws_instance" "log_server" {
  ami = "${var.log_image}"
  instance_type = "${var.log_instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.log_security_group.id}", "${var.shared_security_group}"]
  subnet_id = "${element(split(", ", var.subnet_ids), 0)}"
  associate_public_ip_address = true
  tags {
    Name = "LogServer"
  }
}

output "cluster_addresses" {
  value = "${aws_instance.log_server.private_ip}"
}

output "consul_addresses" {
  value = "${aws_instance.log_server.public_ip}"
}
