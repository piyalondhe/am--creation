#Create Code Build Policy
resource "aws_iam_policy" "policy" {
  name        = "codebuildpolicy1"
  path        = "/"
  description = "To allow integration to vode build"
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:eu-central-1:*:log-group:/aws/codebuild/${var.cbname}",
                "arn:aws:logs:eu-central-1:*:log-group:/aws/codebuild/${var.cbname}:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::swfcppb21112021"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:codecommit:eu-central-1:*:${var.CCRepo}"
            ],
            "Action": [
                "codecommit:GitPull"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::swfcppb21112021",
                "arn:aws:s3:::swfcppb21112021/*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": [
                "arn:aws:codebuild:eu-central-1:*:report-group/CodeReview-*"
            ]
        }
    ]
}  )
}

#Following code will create packer policy
resource "aws_iam_policy" "policyp" {
  name        = "packerpolicy1"
  path        = "/"
  description = "To allow integration to vode build"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CopyImage",
                "ec2:CreateImage",
                "ec2:CreateKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteKeyPair",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSnapshot",
                "ec2:DeleteVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeRegions",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSnapshots",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
                "ec2:GetPasswordData",
                "ec2:ModifyImageAttribute",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifySnapshotAttribute",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": "*"
        },
        {
            "Sid": "PackerIAMPassRole",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "iam:GetInstanceProfile"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "codebuild.amazonaws.com"
                }
            }
        },
        {
            "Sid": "PackerIAMCreateRole",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "iam:CreateInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:GetRole",
                "iam:GetInstanceProfile",
                "iam:DeleteRolePolicy",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:PutRolePolicy",
                "iam:AddRoleToInstanceProfile"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "codebuild.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "*"
        }
    ]
 })
 depends_on = [
   aws_s3_bucket.b
 ]
}

#Create Code Build Role
resource "aws_iam_role" "role" {
  name = "CodeBuildRole1"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
depends_on = [
  aws_iam_policy.policy
]
}
# Attach Previously created policy to Above created role
resource "aws_iam_role_policy_attachment" "service_role_policy_attach" {
   role       = "${aws_iam_role.role.name}"
   policy_arn = "${aws_iam_policy.policy.arn}"
depends_on = [
  aws_iam_role.role
]
}

resource "aws_iam_role_policy_attachment" "inspector_policy_attach" {
   role       = "${aws_iam_role.role.name}"
   policy_arn = "arn:aws:iam::aws:policy/AmazonInspectorFullAccess"
depends_on = [
  aws_iam_role.role
]
}
/*
#Attach AWS Codebuild Developer Access to code build Role
resource "aws_iam_role_policy_attachment" "service_role_policy_attach1" {
   role       = "${aws_iam_role.role.name}"
   policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
depends_on = [
  aws_iam_role.role
]
}*/
#Following block will attach packer policy to the code build role
resource "aws_iam_role_policy_attachment" "service_role_policy_attach2" {
   role       = "${aws_iam_role.role.name}"
   policy_arn = "${aws_iam_policy.policyp.arn}"
depends_on = [
  aws_iam_role.role
]
}
#Following block will attache AWS Code Build Admin Access to code build role
resource "aws_iam_role_policy_attachment" "service_role_policy_attach3" {
   role       = "${aws_iam_role.role.name}"
   policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
depends_on = [
  aws_iam_role.role
]
}
