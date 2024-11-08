# Launch template para las instancias EC2 del Auto Scaling Group
# AMI completamente configurada con WordPress
# El user data script:
# - Instala y monta EFS
# - Configura Apache para usar EFS como almacenamiento
# - Actualiza la configuración SSL con el DNS name del ALB

resource "aws_launch_template" "Labfinal_LT" {
  name_prefix   = var.launch_template_name_prefix
  image_id      = var.instance_ami
  instance_type = var.instance_type

  user_data = base64encode(<<-EOF
  #!/bin/bash
  yum install -y amazon-efs-utils
  mkdir -p ${var.mount_point}
  chmod 755 ${var.mount_point}
  sleep 10
  mount -t efs -o tls ${aws_efs_file_system.labfinal_efs.id}:/ ${var.mount_point}
  echo "${aws_efs_file_system.labfinal_efs.id}:/ ${var.mount_point} efs defaults,_netdev,tls 0 0" >> /etc/fstab
  ln -s ${var.mount_point} /var/www/html
  sed -i "s/ServerName .*/ServerName ${aws_lb.external_nlb.dns_name}/" /etc/httpd/conf.d/ssl.conf
  cd /var/www/html
  cat <<HEALTH_CHECK > /var/www/html/health.html
  ${var.health_check_content}
  HEALTH_CHECK
  systemctl restart httpd
  EOF
  )
  
  monitoring {
    enabled = var.enable_monitoring
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.labfinal_roles.name
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip
    security_groups = [aws_security_group.lt_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, { Name = "${var.resource_name_prefix}-instance" })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(var.tags, { Name = "${var.resource_name_prefix}-volume" })
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = merge(var.tags, { Name = "${var.resource_name_prefix}-eni" })
  }

  tags = merge(var.tags, { Name = "${var.resource_name_prefix}-template" })
}
