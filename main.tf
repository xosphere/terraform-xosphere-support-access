resource "aws_iam_role" "xosphere_support_access_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": { "AWS": "770759415832" },
      "Condition": {"StringEquals": {"sts:ExternalId": "${var.external_id}"}},
      "Effect": "Allow",
      "Sid": "AllowXosphereSupportTrustPolicy"
    }
  ]
}
EOF
  name = "xosphere-instance-orchestrator-support-access-role"
  path = "/"
  tags = var.tags
}

resource "aws_iam_role_policy" "xosphere_support_access_policy" {
  name = "xosphere-support-access-policy"
  role = aws_iam_role.xosphere_support_access_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Sid": "AllowReadOperationsOnXosphereLogGroups",
      "Effect": "Allow",
      "Action": [
        "logs:DescribeLogStreams",
        "logs:FilterLogEvents",
        "logs:GetLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:/aws/lambda/xosphere-*",
        "arn:aws:logs:*:*:log-group:/aws/lambda/xosphere-*:log-stream:*"
      ]
  }]
}
EOF
}

output "external_id" {
  value = var.external_id
}