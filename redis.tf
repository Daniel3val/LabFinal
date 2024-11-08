
resource "aws_elasticache_replication_group" "redis_cache" {
  replication_group_id       = var.redis_config.replication_group_id
  description               = var.redis_config.description
  engine                    = var.redis_config.engine
  node_type                 = var.redis_config.node_type
  num_cache_clusters        = var.redis_config.num_cache_clusters
  port                      = var.redis_config.port
  
  subnet_group_name         = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids        = [aws_security_group.redis_sg.id]
  
  parameter_group_name      = var.redis_config.parameter_group_name
  
  automatic_failover_enabled = var.redis_config.automatic_failover
  multi_az_enabled          = var.redis_config.multi_az

  # Configuración de respaldo
  snapshot_retention_limit  = var.redis_config.snapshot_retention_limit
  snapshot_window          = var.redis_config.snapshot_window
  
  # Maintenance Windows
  maintenance_window       = var.redis_config.maintenance_window

  tags = merge(var.tags, { Name = var.redis_config.replication_group_id })
}

# Grupo de subnets de Redis
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = var.redis_subnet_group_name
  subnet_ids = module.vpc.private_subnets
  tags = merge(var.tags, { Name = var.redis_subnet_group_name })
}