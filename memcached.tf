
resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = var.memcached_config.cluster_id
  engine              = var.memcached_config.engine
  node_type           = var.memcached_config.node_type
  num_cache_nodes     = var.memcached_config.num_cache_nodes
  port                = var.memcached_config.port
  
  subnet_group_name    = aws_elasticache_subnet_group.memcached_subnet_group.name
  security_group_ids   = [aws_security_group.memcached_sg.id]
  
  parameter_group_name = var.memcached_config.parameter_group
  
  az_mode             = var.memcached_config.az_mode
  preferred_availability_zones = var.availability_zones

  maintenance_window  = var.memcached_config.maintenance_window

  tags = merge(var.tags, { Name = var.memcached_config.cluster_id })
}

# Grupo de subnets de Memcached
resource "aws_elasticache_subnet_group" "memcached_subnet_group" {
  name       = var.memcached_subnet_group_name
  subnet_ids = module.vpc.private_subnets
  tags = merge(var.tags, { Name = var.memcached_subnet_group_name })
}