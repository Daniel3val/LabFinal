# Dashboard de CloudWatch para monitorizar las metricas clave   

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "dashboard-metricas"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name]
          ]
          period = var.metric_period
          stat   = "Average"
          region = var.aws_region
          title  = "CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name],
            ["AWS/EC2", "StatusCheckFailed_Instance", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name],
            ["AWS/EC2", "StatusCheckFailed_System", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name]
          ]
          period = var.metric_period
          stat   = "Sum"
          region = var.aws_region
          title  = "Instance Health Status"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkIn", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name],
            ["AWS/EC2", "NetworkOut", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name],
            ["AWS/EC2", "NetworkPacketsIn", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name],
            ["AWS/EC2", "NetworkPacketsOut", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "Network Traffic"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.external_nlb.arn_suffix],
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.external_nlb.arn_suffix],
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "Load Balancer Metrics"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "EBSReadOps", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name],
            ["AWS/EC2", "EBSWriteOps", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name],
            ["AWS/EC2", "EBSReadBytes", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name],
            ["AWS/EC2", "EBSWriteBytes", "AutoScalingGroupName", module.autoscaling.autoscaling_group_name]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "EBS Metrics"
        }
      }
    ]
  })
}

# Alarma de CloudWatch para el uso de CPU alto
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period             = var.metric_period
  statistic          = "Average"
  threshold          = var.cpu_alarm_threshold
  alarm_description  = "Esta metrica monitoriza el uso de CPU en las instancias"
  alarm_actions      = []

  dimensions = {
    AutoScalingGroupName = module.autoscaling.autoscaling_group_name
  }
}

# Alarma de CloudWatch para el estado de salud de las instancias
resource "aws_cloudwatch_metric_alarm" "instance_health" {
  alarm_name          = "instance-health-check"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.instance_health_evaluation_periods
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period             = var.metric_period
  statistic          = "Maximum"
  threshold          = "0"
  alarm_description  = "Esta metrica monitoriza el estado de salud de las instancias"
  alarm_actions      = []

  dimensions = {
    AutoScalingGroupName = module.autoscaling.autoscaling_group_name
  }
}