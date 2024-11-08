# Grupo de seguridad del NLB externo
resource "aws_security_group" "nlb_sg" {
  name        = var.security_groups.nlb.name
  description = var.security_groups.nlb.description
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = var.security_groups.nlb.ingress.description
    from_port   = var.security_groups.nlb.ingress.port
    to_port     = var.security_groups.nlb.ingress.port
    protocol    = var.security_groups.nlb.ingress.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = var.egress_config.description
    from_port   = var.egress_config.from_port
    to_port     = var.egress_config.to_port
    protocol    = var.egress_config.protocol
    cidr_blocks = var.egress_config.cidr_blocks
  }

  tags = merge(var.tags, { Name = var.security_groups.nlb.name })
}

# Grupo de seguridad del ALB interno
resource "aws_security_group" "internal_alb_sg" {
  name        = var.security_groups.internal_alb.name
  description = var.security_groups.internal_alb.description
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = var.security_groups.internal_alb.ingress.description
    from_port       = var.security_groups.internal_alb.ingress.port
    to_port         = var.security_groups.internal_alb.ingress.port
    protocol        = var.security_groups.internal_alb.ingress.protocol
    security_groups = [aws_security_group.nlb_sg.id]
  }

  egress {
    description = var.egress_config.description
    from_port   = var.egress_config.from_port
    to_port     = var.egress_config.to_port
    protocol    = var.egress_config.protocol
    cidr_blocks = var.egress_config.cidr_blocks
  }

  tags = merge(var.tags, { Name = var.security_groups.internal_alb.name })
}

# Grupo de seguridad del Launch Template
resource "aws_security_group" "lt_sg" {
  name        = var.security_groups.lt.name
  description = var.security_groups.lt.description
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = var.security_groups.lt.ingress.description
    from_port       = var.security_groups.lt.ingress.port
    to_port         = var.security_groups.lt.ingress.port
    protocol        = var.security_groups.lt.ingress.protocol
    security_groups = [aws_security_group.internal_alb_sg.id]
  }

  egress {
    description = var.egress_config.description
    from_port   = var.egress_config.from_port
    to_port     = var.egress_config.to_port
    protocol    = var.egress_config.protocol
    cidr_blocks = var.egress_config.cidr_blocks
  }

  tags = merge(var.tags, { Name = var.security_groups.lt.name })
}

# Grupo de seguridad de RDS
resource "aws_security_group" "rds_sg" {
  name        = var.security_groups.rds.name
  description = var.security_groups.rds.description
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = var.security_groups.rds.ingress.description
    from_port       = var.security_groups.rds.ingress.port
    to_port         = var.security_groups.rds.ingress.port
    protocol        = var.security_groups.rds.ingress.protocol
    security_groups = [aws_security_group.lt_sg.id]
  }

  egress {
    description = var.egress_config.description
    from_port   = var.egress_config.from_port
    to_port     = var.egress_config.to_port
    protocol    = var.egress_config.protocol
    cidr_blocks = var.egress_config.cidr_blocks
  }

  tags = merge(var.tags, { Name = var.security_groups.rds.name })
}

# Grupo de seguridad de Redis
resource "aws_security_group" "redis_sg" {
  name        = var.security_groups.redis.name
  description = var.security_groups.redis.description
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = var.security_groups.redis.ingress.description
    from_port       = var.security_groups.redis.ingress.port
    to_port         = var.security_groups.redis.ingress.port
    protocol        = var.security_groups.redis.ingress.protocol
    security_groups = [aws_security_group.lt_sg.id]
  }

  egress {
    description = var.egress_config.description
    from_port   = var.egress_config.from_port
    to_port     = var.egress_config.to_port
    protocol    = var.egress_config.protocol
    cidr_blocks = var.egress_config.cidr_blocks
  }

  tags = merge(var.tags, { Name = var.security_groups.redis.name })
}

# Grupo de seguridad de EFS
resource "aws_security_group" "efs_sg" {
  name        = var.security_groups.efs.name
  description = var.security_groups.efs.description
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = var.security_groups.efs.ingress.description
    from_port   = var.security_groups.efs.ingress.port
    to_port     = var.security_groups.efs.ingress.port
    protocol    = var.security_groups.efs.ingress.protocol
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = var.egress_config.description
    from_port   = var.egress_config.from_port
    to_port     = var.egress_config.to_port
    protocol    = var.egress_config.protocol
    cidr_blocks = var.egress_config.cidr_blocks
  }

  tags = merge(var.tags, { Name = var.security_groups.efs.name })
}

# Grupo de seguridad de Memcached
resource "aws_security_group" "memcached_sg" {
  name        = var.security_groups.memcached.name
  description = var.security_groups.memcached.description
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = var.security_groups.memcached.ingress.description
    from_port       = var.security_groups.memcached.ingress.port
    to_port         = var.security_groups.memcached.ingress.port
    protocol        = var.security_groups.memcached.ingress.protocol
    security_groups = [aws_security_group.lt_sg.id]
  }

  egress {
    description = var.egress_config.description
    from_port   = var.egress_config.from_port
    to_port     = var.egress_config.to_port
    protocol    = var.egress_config.protocol
    cidr_blocks = var.egress_config.cidr_blocks
  }

  tags = merge(var.tags, { Name = var.security_groups.memcached.name })
}



