
module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.0.0"
  
  name = "Labfinal_asg"
  
  # Launch template
  launch_template_id = aws_launch_template.Labfinal_LT.id
  launch_template_version = aws_launch_template.Labfinal_LT.latest_version
  create_launch_template = false
  
  # Seleccionar subnets privadas
  vpc_zone_identifier = module.vpc.private_subnets

  
  # Auto scaling group
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  wait_for_capacity_timeout = 0
  health_check_type        = "ELB"
  health_check_grace_period = var.health_check_grace_period
  
  # Politica de escalado para CPU
  scaling_policies = {
    cpu-policy = {
      policy_type               = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = var.cpu_target_value
      }
    }
  }

  # Mecanismo de actualizacion de instancias
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = var.min_healthy_percentage
    }
  }

  # Habilitar la recopilacion de metricas
  enable_monitoring = true

  tags = merge(var.tags, { Name = "Labfinal_asg" })
}



