
resource "aws_iam_role" "lakefs" {
  name = local.resource_name_default
  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Action : "sts:AssumeRole"
        Principal : {
          Service : "ec2.amazonaws.com"
        }
        Effect : "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "lakefs" {
  name = local.resource_name_default
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow"
        "Action" : "s3:*"
        "Resource" : [
          aws_s3_bucket.lakefs.arn,
          "${aws_s3_bucket.lakefs.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lakefs" {
  policy_arn = aws_iam_policy.lakefs.arn
  role       = aws_iam_role.lakefs.name
}

resource "aws_iam_instance_profile" "test_profile" {
  name = aws_iam_role.lakefs.name
  role = aws_iam_role.lakefs.name
}

resource "aws_security_group" "lakefs" {
  vpc_id = var.vpc_id
  ingress {
    # Allow SSH from my public IP
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = [
      "${local.public_ip}/32"
    ]
  }
  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = [
      "${local.public_ip}/32"
    ]
  }
  egress {
    # Allow all egress
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_instance" "lakefs" {
  ami                         = data.aws_ami.terraform.id
  instance_type               = "t3a.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.test_profile.name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids = [
    aws_security_group.lakefs.id
  ]
  tags = {
    Name : local.resource_name_default
  }
}
