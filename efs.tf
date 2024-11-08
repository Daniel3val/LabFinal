
resource "aws_efs_file_system" "labfinal_efs" {
  creation_token = var.efs_name
  performance_mode = var.efs_performance_mode
  encrypted      = var.efs_encrypted

  lifecycle_policy {
    transition_to_ia = var.efs_transition_to_ia
  }

  tags = merge(var.tags, { Name = "labfinal-efs" })
}

# EFS Mount Target con Multi-AZ
resource "aws_efs_mount_target" "efs_mount" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.labfinal_efs.id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}