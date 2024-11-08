

output "vpc_id" {
  description = "El ID de la VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Lista de IDs de las subredes privadas"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Lista de IDs de las subredes públicas"
  value       = module.vpc.public_subnets
}

output "nlb_security_group_id" {
  description = "ID del grupo de seguridad del NLB Externo"
  value       = aws_security_group.nlb_sg.id
}

output "launch_template_security_group_id" {
  description = "ID del grupo de seguridad de la plantilla de lanzamiento"
  value       = aws_security_group.lt_sg.id
}

output "rds_security_group_id" {
  description = "ID del grupo de seguridad de RDS"
  value       = aws_security_group.rds_sg.id
}

output "redis_security_group_id" {
  description = "ID del grupo de seguridad de Redis"
  value       = aws_security_group.redis_sg.id
}

output "memcached_security_group_id" {
  description = "ID del grupo de seguridad de Memcached"
  value       = aws_security_group.memcached_sg.id
}

output "efs_security_group_id" {
  description = "ID del grupo de seguridad de EFS"
  value       = aws_security_group.efs_sg.id
}


output "private_zone_id" {
  description = "ID de la zona DNS privada"
  value       = aws_route53_zone.private.zone_id
}

output "private_zone_name" {
  description = "Nombre de la zona DNS privada"
  value       = aws_route53_zone.private.name
}

output "db_dns_name" {
  description = "Nombre DNS del endpoint de la base de datos"
  value       = aws_route53_record.db.name
}

output "alb_dns_name" {
  description = "Nombre DNS del balanceador de carga"
  value       = aws_route53_record.alb.name
}

output "internal_alb_dns_name" {
  description = "Nombre DNS del ALB interno"
  value       = aws_lb.internal_alb.dns_name
}

output "redis_dns_name" {
  description = "Nombre DNS del endpoint de Redis"
  value       = aws_route53_record.redis.name
}

output "redis_endpoint" {
  description = "Endpoint primario del grupo de replicación de Redis"
  value       = aws_elasticache_replication_group.redis_cache.primary_endpoint_address
}

output "redis_reader_endpoint" {
  description = "Endpoint de lectura del grupo de replicación de Redis"
  value       = aws_elasticache_replication_group.redis_cache.reader_endpoint_address
}

output "redis_port" {
  description = "Número de puerto para las conexiones Redis"
  value       = aws_elasticache_replication_group.redis_cache.port
}

output "redis_subnet_group_name" {
  description = "Nombre del grupo de subredes de Redis"
  value       = aws_elasticache_subnet_group.redis_subnet_group.name
}

output "redis_subnet_group_ids" {
  description = "Lista de IDs de subredes en el grupo de subredes de Redis"
  value       = aws_elasticache_subnet_group.redis_subnet_group.subnet_ids
}

output "rds_endpoint" {
  description = "El endpoint de conexión para la instancia RDS"
  value       = aws_db_instance.rds.endpoint
}

output "rds_address" {
  description = "El nombre de host de la instancia RDS"
  value       = aws_db_instance.rds.address
}

output "rds_port" {
  description = "El puerto en el que escucha la instancia RDS"
  value       = aws_db_instance.rds.port
}

output "rds_database_name" {
  description = "El nombre de la base de datos por defecto"
  value       = aws_db_instance.rds.db_name
}

output "rds_instance_id" {
  description = "El identificador de la instancia RDS"
  value       = aws_db_instance.rds.identifier
}

output "db_subnet_group_name" {
  description = "El nombre del grupo de subredes de la base de datos"
  value       = aws_db_subnet_group.rds_subnet_group.name
}

output "db_subnet_group_arn" {
  description = "El ARN del grupo de subredes de la base de datos"
  value       = aws_db_subnet_group.rds_subnet_group.arn
}

output "launch_template_id" {
  description = "ID de la plantilla de lanzamiento creada"
  value       = aws_launch_template.Labfinal_LT.id
}

output "launch_template_latest_version" {
  description = "Última versión de la plantilla de lanzamiento"
  value       = aws_launch_template.Labfinal_LT.latest_version
}

output "launch_template_arn" {
  description = "ARN de la plantilla de lanzamiento"
  value       = aws_launch_template.Labfinal_LT.arn
}

output "iam_role_name" {
  description = "Nombre del rol IAM creado"
  value       = aws_iam_role.labfinal_roles.name
}

output "iam_role_arn" {
  description = "ARN del rol IAM"
  value       = aws_iam_role.labfinal_roles.arn
}

output "instance_profile_name" {
  description = "Nombre del perfil de instancia"
  value       = aws_iam_instance_profile.labfinal_roles.name
}

output "instance_profile_arn" {
  description = "ARN del perfil de instancia"
  value       = aws_iam_instance_profile.labfinal_roles.arn
}

output "efs_id" {
  description = "ID del sistema de archivos EFS"
  value       = aws_efs_file_system.labfinal_efs.id
}

output "efs_arn" {
  description = "ARN del sistema de archivos EFS"
  value       = aws_efs_file_system.labfinal_efs.arn
}

output "efs_dns_name" {
  description = "Nombre DNS del sistema de archivos EFS"
  value       = aws_efs_file_system.labfinal_efs.dns_name
}

output "efs_mount_targets" {
  description = "IDs of the EFS mount targets"
  value       = aws_efs_mount_target.efs_mount[*].id
}

output "efs_mount_target_dns_names" {
  description = "DNS names of the EFS mount targets"
  value       = [for mt in aws_efs_mount_target.efs_mount : mt.dns_name]
}

output "autoscaling_group_id" {
  description = "ID del grupo de auto escalado"
  value       = module.autoscaling.autoscaling_group_id
}

output "autoscaling_group_name" {
  description = "Nombre del grupo de auto escalado"
  value       = module.autoscaling.autoscaling_group_name
}

output "autoscaling_group_arn" {
  description = "ARN del grupo de auto escalado"
  value       = module.autoscaling.autoscaling_group_arn
}

output "autoscaling_group_min_size" {
  description = "Tamaño mínimo del grupo de auto escalado"
  value       = module.autoscaling.autoscaling_group_min_size
}

output "autoscaling_group_max_size" {
  description = "Tamaño máximo del grupo de auto escalado"
  value       = module.autoscaling.autoscaling_group_max_size
}

output "autoscaling_group_desired_capacity" {
  description = "Capacidad deseada del grupo de auto escalado"
  value       = module.autoscaling.autoscaling_group_desired_capacity
}

output "ec2_private_ips" {
  description = "Lista de IPs privadas de las instancias EC2 en el grupo de auto escalado"
  value       = data.aws_instances.asg_instances.private_ips
}

output "ec2_public_ips" {
  description = "Lista de IPs públicas de las instancias EC2 en el grupo de auto escalado"
  value       = data.aws_instances.asg_instances.public_ips
}

output "internal_alb_id" {
  description = "El ID del balanceador de carga interno"
  value       = aws_lb.internal_alb.id
}

output "internal_alb_arn" {
  description = "El ARN del balanceador de carga interno"
  value       = aws_lb.internal_alb.arn
}

output "internal_alb_zone_id" {
  description = "El ID de la zona del balanceador de carga interno"
  value       = aws_lb.internal_alb.zone_id
}

output "internal_target_group_arn" {
  description = "El ARN del grupo objetivo interno"
  value       = aws_lb_target_group.internal_tg.arn
}


output "certificate_arn" {
  description = "ARN del certificado SSL"
  value       = aws_acm_certificate.ssl_certificate.arn
}

output "certificate_status" {
  description = "Estado del certificado SSL"
  value       = aws_acm_certificate.ssl_certificate.status
}
output "external_nlb_dns_name" {
  description = "DNS name del Network Load Balancer externo"
  value       = aws_lb.external_nlb.dns_name
}

output "external_nlb_arn" {
  description = "ARN del Network Load Balancer externo"
  value       = aws_lb.external_nlb.arn
}

output "external_nlb_zone_id" {
  description = "Zone ID del Network Load Balancer externo"
  value       = aws_lb.external_nlb.zone_id
}

output "external_target_group_arn" {
  description = "ARN del target group externo del NLB"
  value       = aws_lb_target_group.external_nlb_tg.arn
}

output "external_target_group_name" {
  description = "Nombre del target group externo del NLB"
  value       = aws_lb_target_group.external_nlb_tg.name
}
output "memcached_cluster_id" {
  description = "ID del cluster de Memcached"
  value       = aws_elasticache_cluster.memcached.cluster_id
}

output "memcached_configuration_endpoint" {
  description = "Endpoint de configuración del cluster de Memcached"
  value       = aws_elasticache_cluster.memcached.configuration_endpoint
}

output "memcached_cluster_address" {
  description = "Dirección DNS del cluster de Memcached"
  value       = aws_elasticache_cluster.memcached.cluster_address
}

output "memcached_cache_nodes" {
  description = "Lista de nodos del cluster de Memcached"
  value       = aws_elasticache_cluster.memcached.cache_nodes
}

output "memcached_port" {
  description = "Puerto del cluster de Memcached"
  value       = aws_elasticache_cluster.memcached.port
}

output "memcached_az_mode" {
  description = "Modo de zona de disponibilidad del cluster de Memcached"
  value       = aws_elasticache_cluster.memcached.az_mode
}

output "memcached_security_group_ids" {
  description = "IDs de los grupos de seguridad asociados al cluster de Memcached"
  value       = aws_elasticache_cluster.memcached.security_group_ids
}