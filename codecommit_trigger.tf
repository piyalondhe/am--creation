#Following Block create cloudwatch event rule to monitor changes to CodeCommit Repository
resource "aws_cloudwatch_event_rule" "codecommit_activity" {
  name_prefix = "CCactivity"
  description = "Detect commits to CodeCommit repo"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [
    "arn:aws:codecommit:eu-central-1:057871779523:testmigrate"
  ],
  "detail": {
    "referenceType": [
      "branch"
    ],
    "referenceName": [
      "master"
    ]
  }
}
PATTERN
}

#Following code will create Cloudwatch Event Trigger which will call AWS Code Pipeline to start execution
resource "aws_cloudwatch_event_target" "cloudwatch_triggers_pipeline" {
  target_id = "Codecommits-trigger-pipeline"
  rule = aws_cloudwatch_event_rule.codecommit_activity.name
  arn = aws_codepipeline.codepipeline.arn
  role_arn = aws_iam_role.cloudwatch_ci_role.arn
  depends_on = [
    aws_codepipeline.codepipeline
  ]
}

#Following block will create cloudwatch event rule to send pipeline activity notifications to Users
resource "aws_cloudwatch_event_rule" "Notification" {
  name_prefix = "PipelineActivity"
  description = "Inform Users of Pipeline Activities"

  event_pattern = <<PATTERN
{
  "source": ["aws.codebuild", "aws.codecommit", "aws.codedeploy", "aws.codepipeline"]
}
PATTERN
}

#Following block will create sns topic named user_updates
resource "aws_sns_topic" "user_updates" {
  name = "user-updates-topic"
}

#Following block will create sns subscriptions i.e users who will be notified
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = "priyanka.londhe@t-systems.com"
}

#Following block will create code start notifications rule which will link to sns and provide updates on pipeline status
resource "aws_codestarnotifications_notification_rule" "alerts" {
  detail_type    = "BASIC"
  event_type_ids = [
    "codepipeline-pipeline-action-execution-succeeded",
    "codepipeline-pipeline-action-execution-failed",
    "codepipeline-pipeline-action-execution-started",
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-stage-execution-started",
    "codepipeline-pipeline-stage-execution-succeeded",
    "codepipeline-pipeline-stage-execution-failed"
  ]
  name     = "Pipeline-build-notifs"
  resource = aws_codepipeline.codepipeline.arn

  target {
    address = aws_sns_topic.user_updates.arn
  }
  depends_on = [
    aws_codepipeline.codepipeline
  ]
}
