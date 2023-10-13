#Following block will create AWS S3 Bucket
resource "aws_s3_bucket" "b" {
  bucket = "swfcppb21112021"
  depends_on = [
    aws_iam_role_policy_attachment.service_role_policy_attach
  ]
}

#Following block will attach below policy to s3 bucket
resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.b.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
       {
          "Sid": "AWSLogDeliveryWrite",
          "Effect": "Allow",
          "Principal": {"Service": "delivery.logs.amazonaws.com"},
          "Action": "s3:PutObject",
          "Resource": [aws_s3_bucket.b.arn,
          "${aws_s3_bucket.b.arn}/*"],
          "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
       },
       {
          "Sid": "AWSLogDeliveryAclCheck",
          "Effect": "Allow",
          "Principal": {"Service": "delivery.logs.amazonaws.com"},
          "Action": "s3:GetBucketAcl",
          "Resource": [aws_s3_bucket.b.arn,
          "${aws_s3_bucket.b.arn}/*"]
       },
       {
          "Sid": "codebuild",
          "Effect": "Allow",
          "Principal": {"Service": "codebuild.amazonaws.com"},
          "Action": "s3:GetBucketAcl",
          "Resource": [aws_s3_bucket.b.arn,
          "${aws_s3_bucket.b.arn}/*"]
       },
       {
          "Sid": "codepipeline",
          "Effect": "Allow",
          "Principal": {"Service": "codepipeline.amazonaws.com"},
          "Action": "s3:GetBucketAcl",
          "Resource": [aws_s3_bucket.b.arn,
          "${aws_s3_bucket.b.arn}/*"]
       }
    ]
})
depends_on = [
  aws_s3_bucket.b
]
}