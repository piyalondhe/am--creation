#Following code will create AWS Code Build Project
resource "aws_codebuild_project" "code_build" {
  name                          = "${var.cbname}"
  description                   = "TestProject"
  build_timeout                 = "15"
  service_role                  = "${aws_iam_role.role.arn}"
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }

  source {
    type                          = "CODEPIPELINE"
    buildspec                     = "${file("${path.module}/buildspec.yml")}"
  }

  source_version = "${var.branch}"


  artifacts {
    type = "CODEPIPELINE"
  }

  tags = {
    Name                          = "Priyanka"
    Owner                         = "Priyanka.londhei@t-systems.com"
    TeamId                        = "P"
  }
}