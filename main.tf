provider "aws" {
    region = "us-east-1"
}

resource "aws_security_group" "new_sg" {
    name = "new_sg"
    description = "This SG is to created to connect the ec2-instance"
    vpc_id = "vpc-96cc57ec"
    tags = {
        Name = "new_sg"
    }
} 

resource "aws_vpc_security_group_ingress_rule" "new_ingress_rule_1" {
    security_group_id = aws_security_group.new_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443
}

resource "aws_vpc_security_group_ingress_rule" "new_ingress_rule_2" {
    security_group_id = aws_security_group.new_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "new_ingress_rule_3" {
    security_group_id = aws_security_group.new_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    ip_protocol = "tcp"
    to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "new_egress_rule1" {
    security_group_id = aws_security_group.new_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_instance" "new_os" {
    ami = "ami-0ae8f15ae66fe8cda"
    instance_type = "t2.micro"
    tags = {
        Environment = "PPRD"
        Name = "New_PPRD"
    }
    availability_zone = "us-east-1a"
    key_name = "new_key"
    security_groups = ["${aws_security_group.new_sg.name}"]
}

resource aws_ebs_volume "new_ebs_volume" {
    availability_zone = aws_instance.new_os.availability_zone
    size = 2
    tags = {
        Name = "New Volume for EC2"
    }
}

resource "aws_volume_attachment" "new_vol" {
    device_name = "/dev/sdc"
    instance_id = aws_instance.new_os.id
    volume_id = aws_ebs_volume.new_ebs_volume.id
}

//resource "null_resource" "null_re1" {
//    provisioner "remote-exec" {
//        inline = [
//            "sudo mkdir /new_vol",
//            "sudo mkfs.xfs /dev/xvdb",
//            "sudo mount /dev/xvdb /new_vol"
//        ]
//    }
// }

output new_output1 {
    value = aws_instance.new_os.id
}

output new_output2 {
    value = aws_instance.new_os.public_ip
}