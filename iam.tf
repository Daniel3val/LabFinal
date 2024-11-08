

resource "aws_iam_role" "labfinal_roles" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = merge(var.tags, { Name = "labfinal-roles" })
}


# Asignar políticas usando un único recurso con dynamic block
resource "aws_iam_role_policy_attachment" "policies" {
  for_each = var.iam_policies
  
  role       = aws_iam_role.labfinal_roles.name
  policy_arn = each.value
}

# Crear el Instance Profile con todos los permisos
resource "aws_iam_instance_profile" "labfinal_roles" {
  name = var.instance_profile_name
  role = aws_iam_role.labfinal_roles.name
  tags = merge(var.tags, { Name = var.instance_profile_name })
}
