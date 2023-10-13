#Following block will create cloudwatch events role
resource "aws_iam_role" "cloudwatch_ci_role" {
  name_prefix = "cloudwatchEve"

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}
#Following block will create cloudwatch policy document to allow access to various resources and specifically
#Allow Cloudwatch to trigger AWS Code Pipeline
data "aws_iam_policy_document" "cloudwatch_ci_iam_policy" {
  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    # Allow CloudWatch to start the Pipeline
    actions = [
      "codepipeline:StartPipelineExecution"
    ]
    resources = [
        "*"
    ]
  }
  depends_on = [
    aws_codepipeline.codepipeline
  ]
}

#Following block will create IAM Policy for above document
resource "aws_iam_policy" "cloudwatch_ci_iam_policy" {
  name_prefix = "CWEEventPol"
  policy = data.aws_iam_policy_document.cloudwatch_ci_iam_policy.json
}
#Following block will attach above policy to cloudwatch role
resource "aws_iam_role_policy_attachment" "cloudwatch_ci_iam" {
  policy_arn = aws_iam_policy.cloudwatch_ci_iam_policy.arn
  role = aws_iam_role.cloudwatch_ci_role.name
}