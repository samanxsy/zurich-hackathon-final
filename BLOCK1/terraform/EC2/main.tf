#############################################
########### E C 2 I N S T A N C E ###########

# INSTANCE A
resource "aws_key_pair" "ssh_pair_instance_a" {
  key_name = "instance-a-key"
  public_key = file("EC2/keys/instance-A.pub")
}

resource "aws_instance" "instance_a" {
  ami                         = var.machine_image
  instance_type               = var.instance_type
  availability_zone           = var.zurich_instance_azs
  subnet_id                   = var.zurich_subnet_id
  security_groups = [var.zurich_security_group]
  # associate_public_ip_address = true

  root_block_device {
    volume_size = 50
    encrypted = true
  }

  key_name                    = aws_key_pair.ssh_pair_instance_a.key_name

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("EC2/instance-A")
  }

  tags = {
    Name  = "instance-A"
  }
}

resource "aws_key_pair" "ssh_pair_instance_b" {
  key_name = "instance-B-key"
  public_key = file("EC2/keys/instance-B.pub")
}

# INSTANCE B
resource "aws_instance" "instance_b" {
  ami                         = var.machine_image
  instance_type               = var.instance_type
  availability_zone           = var.zurich_instance_azs
  subnet_id                   = var.zurich_subnet_id
  security_groups = [var.zurich_security_group]
  # associate_public_ip_address = true

  root_block_device {
    volume_size = 50
    encrypted = true
  }

  key_name                    = aws_key_pair.ssh_pair_instance_b.key_name

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("EC2/instance-B")
  }

  tags = {
    Name  = "instance-B"
  }
}


#  AUTO SCALING CONFIGS
