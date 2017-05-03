output "cluster_name" {
  value = "devkube.cloudlockng.com"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-devkube-cloudlockng-com.id}"]
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-devkube-cloudlockng-com.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.eu-central-1a-devkube-cloudlockng-com.id}"]
}

output "region" {
  value = "eu-central-1"
}

output "vpc_id" {
  value = "${aws_vpc.devkube-cloudlockng-com.id}"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_autoscaling_group" "master-eu-central-1a-masters-devkube-cloudlockng-com" {
  name                 = "master-eu-central-1a.masters.devkube.cloudlockng.com"
  launch_configuration = "${aws_launch_configuration.master-eu-central-1a-masters-devkube-cloudlockng-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1a-devkube-cloudlockng-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "devkube.cloudlockng.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-eu-central-1a.masters.devkube.cloudlockng.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-devkube-cloudlockng-com" {
  name                 = "nodes.devkube.cloudlockng.com"
  launch_configuration = "${aws_launch_configuration.nodes-devkube-cloudlockng-com.id}"
  max_size             = 10
  min_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1a-devkube-cloudlockng-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "devkube.cloudlockng.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.devkube.cloudlockng.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-devkube-cloudlockng-com" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "devkube.cloudlockng.com"
    Name                 = "a.etcd-events.devkube.cloudlockng.com"
    "k8s.io/etcd/events" = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-devkube-cloudlockng-com" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "devkube.cloudlockng.com"
    Name                 = "a.etcd-main.devkube.cloudlockng.com"
    "k8s.io/etcd/main"   = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_iam_instance_profile" "masters-devkube-cloudlockng-com" {
  name  = "masters.devkube.cloudlockng.com"
  roles = ["${aws_iam_role.masters-devkube-cloudlockng-com.name}"]
}

resource "aws_iam_instance_profile" "nodes-devkube-cloudlockng-com" {
  name  = "nodes.devkube.cloudlockng.com"
  roles = ["${aws_iam_role.nodes-devkube-cloudlockng-com.name}"]
}

resource "aws_iam_role" "masters-devkube-cloudlockng-com" {
  name               = "masters.devkube.cloudlockng.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.devkube.cloudlockng.com_policy")}"
}

resource "aws_iam_role" "nodes-devkube-cloudlockng-com" {
  name               = "nodes.devkube.cloudlockng.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.devkube.cloudlockng.com_policy")}"
}

resource "aws_iam_role_policy" "masters-devkube-cloudlockng-com" {
  name   = "masters.devkube.cloudlockng.com"
  role   = "${aws_iam_role.masters-devkube-cloudlockng-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.devkube.cloudlockng.com_policy")}"
}

resource "aws_iam_role_policy" "nodes-devkube-cloudlockng-com" {
  name   = "nodes.devkube.cloudlockng.com"
  role   = "${aws_iam_role.nodes-devkube-cloudlockng-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.devkube.cloudlockng.com_policy")}"
}

resource "aws_internet_gateway" "devkube-cloudlockng-com" {
  vpc_id = "${aws_vpc.devkube-cloudlockng-com.id}"

  tags = {
    KubernetesCluster = "devkube.cloudlockng.com"
    Name              = "devkube.cloudlockng.com"
  }
}

resource "aws_key_pair" "kubernetes-devkube-cloudlockng-com-bd9bece1ece1e1e20f1e29e7d3dbdedb" {
  key_name   = "kubernetes.devkube.cloudlockng.com-bd:9b:ec:e1:ec:e1:e1:e2:0f:1e:29:e7:d3:db:de:db"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.devkube.cloudlockng.com-bd9bece1ece1e1e20f1e29e7d3dbdedb_public_key")}"
}

resource "aws_launch_configuration" "master-eu-central-1a-masters-devkube-cloudlockng-com" {
  name_prefix                 = "master-eu-central-1a.masters.devkube.cloudlockng.com-"
  image_id                    = "ami-10f33e7f"
  instance_type               = "m3.medium"
  key_name                    = "${aws_key_pair.kubernetes-devkube-cloudlockng-com-bd9bece1ece1e1e20f1e29e7d3dbdedb.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-devkube-cloudlockng-com.id}"
  security_groups             = ["${aws_security_group.masters-devkube-cloudlockng-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-eu-central-1a.masters.devkube.cloudlockng.com_user_data")}"

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

resource "aws_launch_configuration" "nodes-devkube-cloudlockng-com" {
  name_prefix                 = "nodes.devkube.cloudlockng.com-"
  image_id                    = "ami-10f33e7f"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-devkube-cloudlockng-com-bd9bece1ece1e1e20f1e29e7d3dbdedb.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-devkube-cloudlockng-com.id}"
  security_groups             = ["${aws_security_group.nodes-devkube-cloudlockng-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.devkube.cloudlockng.com_user_data")}"

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
  route_table_id         = "${aws_route_table.devkube-cloudlockng-com.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.devkube-cloudlockng-com.id}"
}

resource "aws_route_table" "devkube-cloudlockng-com" {
  vpc_id = "${aws_vpc.devkube-cloudlockng-com.id}"

  tags = {
    KubernetesCluster = "devkube.cloudlockng.com"
    Name              = "devkube.cloudlockng.com"
  }
}

resource "aws_route_table_association" "eu-central-1a-devkube-cloudlockng-com" {
  subnet_id      = "${aws_subnet.eu-central-1a-devkube-cloudlockng-com.id}"
  route_table_id = "${aws_route_table.devkube-cloudlockng-com.id}"
}

resource "aws_security_group" "masters-devkube-cloudlockng-com" {
  name        = "masters.devkube.cloudlockng.com"
  vpc_id      = "${aws_vpc.devkube-cloudlockng-com.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "devkube.cloudlockng.com"
    Name              = "masters.devkube.cloudlockng.com"
  }
}

resource "aws_security_group" "nodes-devkube-cloudlockng-com" {
  name        = "nodes.devkube.cloudlockng.com"
  vpc_id      = "${aws_vpc.devkube-cloudlockng-com.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "devkube.cloudlockng.com"
    Name              = "nodes.devkube.cloudlockng.com"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-devkube-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.masters-devkube-cloudlockng-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-devkube-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.masters-devkube-cloudlockng-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-devkube-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.nodes-devkube-cloudlockng-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-devkube-cloudlockng-com.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-devkube-cloudlockng-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-devkube-cloudlockng-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-devkube-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.nodes-devkube-cloudlockng-com.id}"
  from_port                = 1
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-devkube-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.nodes-devkube-cloudlockng-com.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-devkube-cloudlockng-com.id}"
  source_security_group_id = "${aws_security_group.nodes-devkube-cloudlockng-com.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-devkube-cloudlockng-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-devkube-cloudlockng-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "eu-central-1a-devkube-cloudlockng-com" {
  vpc_id            = "${aws_vpc.devkube-cloudlockng-com.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "eu-central-1a"

  tags = {
    KubernetesCluster = "devkube.cloudlockng.com"
    Name              = "eu-central-1a.devkube.cloudlockng.com"
  }
}

resource "aws_vpc" "devkube-cloudlockng-com" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster = "devkube.cloudlockng.com"
    Name              = "devkube.cloudlockng.com"
  }
}

resource "aws_vpc_dhcp_options" "devkube-cloudlockng-com" {
  domain_name         = "eu-central-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "devkube.cloudlockng.com"
    Name              = "devkube.cloudlockng.com"
  }
}

resource "aws_vpc_dhcp_options_association" "devkube-cloudlockng-com" {
  vpc_id          = "${aws_vpc.devkube-cloudlockng-com.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.devkube-cloudlockng-com.id}"
}
