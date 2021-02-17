# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "consul-join"
  assume_role_policy = file("C:\\path\\assume-role.json")
}

# Create the policy
resource "aws_iam_policy" "consul-join" {
  name        = "consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = file("C:\\path\\describe-instances.json")
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "consul-join"
  roles      = [aws_iam_role.consul-join.name]
  policy_arn = aws_iam_policy.consul-join.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name = "consul-join"
  role = aws_iam_role.consul-join.name
}