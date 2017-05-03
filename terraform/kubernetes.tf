variable "USER" {}

output "cluster_name" {
  value = "${var.USER}kube.cloudlockng.com"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-cloudlockng-com.id}"]
}
        
output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-cloudlockng-com.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.eu-central-1a-cloudlockng-com.id}"]
}

output "region" {
  value = "eu-central-1"
}

output "vpc_id" {
  value = "${aws_vpc.cloudlockng-com.id}"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_autoscaling_group" "master-eu-central-1a-masters-cloudlockng-com" {
  name                 = "master-eu-central-1a.masters.${var.USER}.cloudlockng.com"
  launch_configuration = "${aws_launch_configuration.master-eu-central-1a-masters-cloudlockng-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1a-cloudlockng-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "${var.USER}.cloudlockng.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-eu-central-1a.masters.${var.USER}.cloudlockng.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-cloudlockng-com" {
  name                 = "nodes.${var.USER}.cloudlockng.com"
  launch_configuration = "${aws_launch_configuration.nodes-cloudlockng-com.id}"
  max_size             = 3
  min_size             = 3
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1a-cloudlockng-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "${var.USER}.cloudlockng.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.${var.USER}.cloudlockng.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-cloudlockng-com" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "${var.USER}.cloudlockng.com"
    Name                 = "a.etcd-events.${var.USER}.cloudlockng.com"
    "k8s.io/etcd/events" = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-cloudlockng-com" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "${var.USER}.cloudlockng.com"
    Name                 = "a.etcd-main.${var.USER}.cloudlockng.com"
    "k8s.io/etcd/main"   = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_iam_instance_profile" "masters-cloudlockng-com" {
  name  = "masters.${var.USER}.cloudlockng.com"
  roles = ["${aws_iam_role.masters-cloudlockng-com.name}"]
}

resource "aws_iam_instance_profile" "nodes-cloudlockng-com" {
  name  = "nodes.${var.USER}.cloudlockng.com"
  roles = ["${aws_iam_role.nodes-cloudlockng-com.name}"]
}

resource "aws_iam_role" "masters-cloudlockng-com" {
  name               = "masters.${var.USER}.cloudlockng.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.cloudlockng.com_policy")}"
}

resource "aws_iam_role" "nodes-cloudlockng-com" {
  name               = "nodes.${var.USER}.cloudlockng.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.cloudlockng.com_policy")}"
}

resource "aws_iam_role_policy" "masters-cloudlockng-com" {
  name   = "masters.${var.USER}.cloudlockng.com"
  role   = "${aws_iam_role.masters-cloudlockng-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.cloudlockng.com_policy")}"
}

resource "aws_iam_role_policy" "nodes-cloudlockng-com" {
  name   = "nodes.${var.USER}.cloudlockng.com"
  role   = "${aws_iam_role.nodes-cloudlockng-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.cloudlockng.com_policy")}"
}

resource "aws_internet_gateway" "cloudlockng-com" {
  vpc_id = "${aws_vpc.cloudlockng-com.id}"

  tags = {
    KubernetesCluster = "${var.USER}.cloudlockng.com"
    Name              = "${var.USER}.cloudlockng.com"
  }
}

resource "aws_key_pair" "kubernetes-cloudlockng-com-bd9bece1ece1e1e20f1e29e7d3dbdedb" {
  key_name   = "kubernetes.${var.USER}.cloudlockng.com-bd:9b:ec:e1:ec:e1:e1:e2:0f:1e:29:e7:d3:db:de:db"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.cloudlockng.com-bd9bece1ece1e1e20f1e29e7d3dbdedb_public_key")}"
}

resource "aws_launch_configuration" "master-eu-central-1a-masters-cloudlockng-com" {
  name_prefix                 = "master-eu-central-1a.masters.${var.USER}.cloudlockng.com-"
  image_id                    = "ami-10f33e7f"
  instance_type               = "m3.medium"
  key_name                    = "${aws_key_pair.kubernetes-cloudlockng-com-bd9bece1ece1e1e20f1e29e7d3dbdedb.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-cloudlockng-com.id}"
  security_groups             = ["${aws_security_group.masters-cloudlockng-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-eu-central-1a.masters.cloudlockng.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-cloudlockng-com" {
  name_prefix                 = "nodes.${var.USER}.cloudlockng.com-"
  image_id                    = "ami-10f33e7f"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-cloudlockng-com-bd9bece1ece1e1e20f1e29e7d3dbdedb.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-cloudlockng-com.id}"
  security_groups             = ["${aws_security_group.nodes-cloudlockng-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.cloudlockng.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.cloudlockng-com.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.cloudlockng-com.id}"
}

resource "aws_route_table" "cloudlockng-com" {
  vpc_id = "${aws_vpc.cloudlockng-com.id}"

  tags = {
    KubernetesCluster = "${var.USER}.cloudlockng.com"
    Name              = "${var.USER}.cloudlockng.com"
  }
}

resource "aws_route_table_association" "eu-central-1a-cloudlockng-com" {
  subnet_id      = "${aws_subnet.eu-central-1a-cloudlockng-com.id}"
  route_table_id = "${aws_route_table.cloudlockng-com.id}"
}

resource "aws_security_group" "masters-cloudlockng-com" {
  name        = "masters.${var.USER}.cloudlockng.com"
  vpc_id      = "${aws_vpc.cloudlockng-com.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "${var.USER}.cloudlockng.com"
    Name              = "masters.${var.USER}.cloudlockng.com"
  }
}

resource "aws_security_group" "nodes-cloudlockng-com" {
  name        = "nodes.${var.USER}.cloudlockng.com"
  vpc_id      = "${aws_vpc.cloudlockng-com.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "${var.USER}.cloudlockng.com"
    Name              = "nodes.${var.USER}.cloudlockng.com"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.masters-cloudlockng-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.masters-cloudlockng-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.nodes-cloudlockng-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-cloudlockng-com.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-cloudlockng-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-cloudlockng-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.nodes-cloudlockng-com.id}"
  from_port                = 1
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.nodes-cloudlockng-com.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.nodes-cloudlockng-com.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-cloudlockng-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-cloudlockng-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "eu-central-1a-cloudlockng-com" {
  vpc_id            = "${aws_vpc.cloudlockng-com.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "eu-central-1a"

  tags = {
    KubernetesCluster = "${var.USER}.cloudlockng.com"
    Name              = "eu-central-1a.${var.USER}.cloudlockng.com"
  }
}

resource "aws_vpc" "cloudlockng-com" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster = "${var.USER}.cloudlockng.com"
    Name              = "${var.USER}.cloudlockng.com"
  }
}

resource "aws_vpc_dhcp_options" "cloudlockng-com" {
  domain_name         = "eu-central-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "${var.USER}.cloudlockng.com"
    Name              = "${var.USER}.cloudlockng.com"
  }
}

resource "aws_vpc_dhcp_options_association" "cloudlockng-com" {
  vpc_id          = "${aws_vpc.cloudlockng-com.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.cloudlockng-com.id}"
}
