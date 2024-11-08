
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = module.vpc.private_subnets
  tags = merge(var.tags, { Name = var.db_subnet_group_name })
}

# Crear el secreto de Secrets Manager para las credenciales de la base de datos
resource "aws_secretsmanager_secret" "db_credentials" {
  name = var.secret_name
  tags = merge(var.tags, { Name = var.secret_name })
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.username
    password = var.password
  })
}

# Crear la instancia de RDS
resource "aws_db_instance" "rds" {
  identifier = var.rds_config.identifier
  
  # Opciones de motor
  engine            = var.rds_config.engine
  engine_version    = var.rds_config.engine_version
  instance_class    = var.rds_config.instance_class
  storage_encrypted = var.rds_config.storage_encrypted
  deletion_protection = var.rds_config.deletion_protection
  
  # Almacenamiento
  allocated_storage     = var.rds_config.allocated_storage
  max_allocated_storage = var.rds_config.max_allocated_storage
  storage_type         = var.rds_config.storage_type
  
  # Credenciales
  db_name  = var.rds_config.db_name
  username = jsondecode(aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
  password = jsondecode(aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
  port     = var.rds_config.port
  
  # Red
  multi_az               = var.rds_config.multi_az
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  # Backup
  backup_retention_period = var.rds_config.backup_retention
  backup_window          = var.rds_config.backup_window
  maintenance_window     = var.rds_config.maintenance_window
  
  # Monitoring
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs
  
  # Parameter group
  parameter_group_name = var.rds_config.parameter_group
  
  # Final snapshot
  skip_final_snapshot = var.rds_config.skip_final_snapshot
  
  # Snapshot configuration
  snapshot_identifier = var.snapshot_identifier
  
  tags = merge(var.tags, { Name = var.rds_config.identifier })
}