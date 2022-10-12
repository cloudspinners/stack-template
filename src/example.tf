resource "aws_ssm_parameter" "example" {
  name  = "spin_example_stack"
  type  = "String"
  value = "hello"
}
