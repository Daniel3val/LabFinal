
resource "aws_route53_zone" "private" {
  name = var.route53_config.zone_name

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = merge(var.tags, { Name = var.route53_config.zone_tags })
}

# Crear los registros DNS de la base de datos
resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.dns_records.db.name
  type    = var.dns_records.db.type
  ttl     = var.dns_records.db.ttl
  records = [aws_db_instance.rds.address]
}

# Crear el registro DNS del ALB EXTERNO
resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.dns_records.nlb.name
  type    = var.dns_records.nlb.type
  ttl     = var.dns_records.nlb.ttl
  records = [aws_lb.external_nlb.dns_name]
}

# Crear el registro DNS del ALB interno
resource "aws_route53_record" "internal_alb" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.dns_records.internal_alb.name
  type    = var.dns_records.internal_alb.type
  ttl     = var.dns_records.internal_alb.ttl
  records = [aws_lb.internal_alb.dns_name]
}

# Crear el registro DNS de Redis
resource "aws_route53_record" "redis" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.dns_records.redis.name
  type    = var.dns_records.redis.type
  ttl     = var.dns_records.redis.ttl
  records = [aws_elasticache_replication_group.redis_cache.primary_endpoint_address]
}

# Crear el registro DNS de EFS  
resource "aws_route53_record" "efs" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.dns_records.efs.name
  type    = var.dns_records.efs.type
  ttl     = var.dns_records.efs.ttl
  records = [aws_efs_file_system.labfinal_efs.dns_name]
}

# Crear el registro DNS de Memcached
resource "aws_route53_record" "memcached" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.dns_records.memcached.name
  type    = var.dns_records.memcached.type
  ttl     = var.dns_records.memcached.ttl
  records = [aws_elasticache_cluster.memcached.cache_nodes[0].address]
}