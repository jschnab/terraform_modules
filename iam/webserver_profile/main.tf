data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "webserver_policy" {
  statement {
    sid    = "RDSDataAccess"
    effect = "Allow"
    actions = [
      "rds-data:ExecuteSql",
      "rds-data:ExecuteStatement",
      "rds-data:BatchExecuteStatement",
      "rds-data:BeginTransaction",
      "rds-data:CommitTransaction",
      "rds-data:RollbackTransaction",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "RDSDescribeAll"
    effect    = "Allow"
    actions   = ["rds:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "webserver_role" {
  name               = "webserver_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "webserver_policy" {
  name   = "webserver_policy"
  policy = data.aws_iam_policy_document.webserver_policy.json
}

resource "aws_iam_role_policy_attachment" "webserver_role_policy_attach" {
  role       = aws_iam_role.webserver_role.name
  policy_arn = aws_iam_policy.webserver_policy.arn
}

resource "aws_iam_instance_profile" "webserver_profile" {
  name = "webserver_profile"
  role = aws_iam_role.webserver_role.name
}
