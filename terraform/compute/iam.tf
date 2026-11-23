resource "aws_iam_role" "ec2_ssm" {
  name = "lab-common-ec2-ssm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "lab-common-ec2"
  role = aws_iam_role.ec2_ssm.name
}

resource "aws_iam_role_policy" "pritunl_routes" {
  name = "lab-pritunl-route-advertisement"
  role = aws_iam_instance_profile.ec2.role

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeRouteTables"
        ]
        Resource = "*"
      },
      {
        Sid    = "ManageCommonVpnReturnRoutes"
        Effect = "Allow"
        Action = [
          "ec2:CreateRoute",
          "ec2:ReplaceRoute",
          "ec2:DeleteRoute"
        ]
        Resource = "arn:aws:ec2:eu-central-1:768814603451:route-table/*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Project" = "aws-lab"
            "aws:ResourceTag/Name"    = "lab-common-public-rt"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZonesByName"
        ]
        Resource = "*"
      }
    ]
  })
}
