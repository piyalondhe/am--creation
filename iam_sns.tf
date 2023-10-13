#Following block will create SNS Policy Document
data "aws_iam_policy_document" "notif_access" {
  statement {
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["codestar-notifications.amazonaws.com", "inspector.amazonaws.com"]
    }

    resources = [aws_sns_topic.user_updates.arn]
  }
}
#Following block will create sns policy
resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.user_updates.arn
  policy = data.aws_iam_policy_document.notif_access.json
}

/*
#Following block will attach sns policy to Code Pipeline Role
resource "aws_iam_role_policy_attachment" "service_role_policy_attach_sns" {
   role       = "${aws_iam_role.prole.name}"
   policy_arn = "${aws_sns_topic_policy.default.arn}"
depends_on = [
  aws_sns_topic_policy.default
]
}*/