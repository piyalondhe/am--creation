#Following Block will create codepipeline which will be triggered once codecommit repository status changes
resource "aws_codepipeline" "codepipeline" {
  name     = "BuilidingAMI"
  role_arn = aws_iam_role.prole.arn

  artifact_store {
    location = aws_s3_bucket.b.bucket
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "FetchCode"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName       = "${var.CCRepo}"
        BranchName           = "${var.branch}"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "AMI"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.code_build.name}"
      }
    }
  }
/*
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ActionMode     = "REPLACE_ON_FAILURE"
        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        OutputFileName = "CreateStackOutput.json"
        StackName      = "MyStack"
        TemplatePath   = "build_output::sam-templated.yaml"
      }
    }
  }*/
  depends_on = [
    aws_iam_role.prole,
    aws_iam_role.role
  ]
}