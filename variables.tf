variable "tags" {
  description = "Tags to apply to all resources"
  type = map(string)
  default = {
    Owner = "IT"
    Environment = "Test"
    Project = "Hack-A-Boss"
    
  }
}

variable "username" {
  description = "Nombre de usuario de la base de datos"
  type        = string
  default     = "labfinaluser"
  sensitive   = true
}


variable "password" {
  description = "Contraseña de la base de datos"
  type        = string
  default     = "1[it~R*d5brJu6PH>$k~2e*o8EdO"
  sensitive   = true
}


variable "alb_name" {
  description = "Nombre para el ALB EXTERNO"
  type        = string
  default     = "labfinal-alb"
}



# AUTOSCALING 

variable "asg_name" {
  description = "Nombre del Auto Scaling Group"
  type        = string
  default     = "Labfinal_asg"
}

variable "asg_min_size" {
  description = "Número mínimo de instancias en el ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Número máximo de instancias en el ASG"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Capacidad deseada de instancias en el ASG"
  type        = number
  default     = 2
}

variable "cpu_target_value" {
  description = "Valor objetivo de CPU para la política de escalado"
  type        = number
  default     = 70.0
}

variable "health_check_grace_period" {
  description = "Período de gracia para el health check en segundos"
  type        = number
  default     = 60
}

variable "min_healthy_percentage" {
  description = "Porcentaje mínimo de instancias saludables durante el refresh"
  type        = number
  default     = 50
}

# CLOUDWATCH

variable "dashboard_name" {
  description = "Nombre del dashboard de CloudWatch"
  type        = string
  default     = "dashboard-metricas"
}

variable "metric_period" {
  description = "Período de las métricas en segundos"
  type        = number
  default     = 300
}

variable "aws_region" {
  description = "Región de AWS para las métricas"
  type        = string
  default     = "us-east-1"
}

variable "cpu_alarm_threshold" {
  description = "Umbral para la alarma de CPU"
  type        = number
  default     = 80
}

variable "cpu_evaluation_periods" {
  description = "Períodos de evaluación para la alarma de CPU"
  type        = string
  default     = "2"
}

variable "instance_health_evaluation_periods" {
  description = "Períodos de evaluación para la alarma de salud de instancias"
  type        = string
  default     = "1"
}

#EFS

variable "efs_name" {
  description = "Nombre del sistema de archivos EFS"
  type        = string
  default     = "labfinal-efs"
}

variable "efs_performance_mode" {
  description = "Modo de rendimiento para EFS"
  type        = string
  default     = "generalPurpose"
  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.efs_performance_mode)
    error_message = "El modo de rendimiento debe ser 'generalPurpose' o 'maxIO'"
  }
}

variable "efs_encrypted" {
  description = "Habilitar el cifrado para EFS"
  type        = bool
  default     = true
}

variable "efs_transition_to_ia" {
  description = "Política de transición a IA para EFS"
  type        = string
  default     = "AFTER_30_DAYS"
  validation {
    condition     = contains(["AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS"], var.efs_transition_to_ia)
    error_message = "El valor debe ser uno de: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS"
  }
}

#IAM
variable "iam_role_name" {
  description = "Nombre del rol IAM principal"
  type        = string
  default     = "labfinal-roles"
}

variable "instance_profile_name" {
  description = "Nombre del perfil de instancia"
  type        = string
  default     = "labfinal_roles_profile"
}

variable "iam_policies" {
  description = "Mapa de políticas IAM a adjuntar"
  type        = map(string)
  default     = {
    ssm        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    secrets    = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
    kms        = "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"
    s3         = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    efs        = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
    cloudwatch = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }
}

#Launch template

variable "launch_template_name_prefix" {
  description = "Prefijo para el nombre de la Launch Template"
  type        = string
  default     = "Labfinal-template"
}

variable "instance_ami" {
  description = "ID de la AMI para las instancias EC2"
  type        = string
  default     = "ami-0726f52fbb729a727"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "enable_monitoring" {
  description = "Habilitar monitoreo detallado de CloudWatch"
  type        = bool
  default     = true
}

variable "associate_public_ip" {
  description = "Asociar IP pública a las instancias"
  type        = bool
  default     = false
}

variable "resource_name_prefix" {
  description = "Prefijo para los nombres de los recursos"
  type        = string
  default     = "Labfinal"
}

variable "mount_point" {
  description = "Punto de montaje para EFS"
  type        = string
  default     = "/mnt/efs"
}

variable "health_check_content" {
  description = "Contenido HTML para la página de health check"
  type        = string
  default     = "<html>\n<h1>El servicio funciona</h1>\n</html>"
}

#Load Balancer

variable "lb_names" {
  description = "Nombres para los load balancers"
  type = object({
    internal_alb = string
    external_nlb = string
  })
  default = {
    internal_alb = "labfinal-internal-alb"
    external_nlb = "labfinal-external-nlb"
  }
}

variable "target_group_names" {
  description = "Nombres para los target groups"
  type = object({
    internal = string
    external = string
  })
  default = {
    internal = "labfinal-internal-tg"
    external = "labfinal-external-nlb-tg"
  }
}

variable "health_check_settings" {
  description = "Configuración de health check para los target groups"
  type = object({
    enabled             = bool
    healthy_threshold   = number
    unhealthy_threshold = number
    interval            = number
    matcher            = string
    path               = string
    port               = string
    protocol           = string
    timeout            = number
  })
  default = {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    matcher            = "200"
    path               = "/health.html"
    port               = "traffic-port"
    protocol           = "HTTPS"
    timeout            = 15
  }
}

variable "listener_ports" {
  description = "Puertos para los listeners"
  type = object({
    https = number
  })
  default = {
    https = 443
  }
}

variable "ssl_policy" {
  description = "Política SSL para el listener HTTPS"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "enable_cross_zone_lb" {
  description = "Habilitar balanceo de carga entre zonas para NLB"
  type        = bool
  default     = true
}

#MAIN
/*
variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}
*/
variable "backend_config" {
  description = "Configuración del backend S3"
  type = object({
    bucket         = string
    key            = string
    region         = string
    encrypt        = bool
    dynamodb_table = string
  })
  default = {
    bucket         = "labfinal-tfstate-daniel"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "labfinal-lock-daniel"
  }
}

#MEMCACHED

variable "memcached_config" {
  description = "Configuración del cluster de Memcached"
  type = object({
    cluster_id           = string
    engine              = string
    node_type           = string
    num_cache_nodes     = number
    port                = number
    parameter_group     = string
    az_mode             = string
    maintenance_window  = string
  })
  default = {
    cluster_id           = "labfinal-memcached"
    engine              = "memcached"
    node_type           = "cache.t3.micro"
    num_cache_nodes     = 2
    port                = 11211
    parameter_group     = "default.memcached1.6"
    az_mode             = "cross-az"
    maintenance_window  = "sun:05:00-sun:09:00"
  }
}

variable "memcached_subnet_group_name" {
  description = "Nombre del grupo de subnets para Memcached"
  type        = string
  default     = "memcached-subnet-group"
}

variable "availability_zones" {
  description = "Zonas de disponibilidad preferidas para Memcached"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "db_subnet_group_name" {
  description = "Nombre del grupo de subnets para RDS"
  type        = string
  default     = "labfinal-db-subnet-group"
}

variable "secret_name" {
  description = "Nombre del secreto en Secrets Manager"
  type        = string
  default     = "db-credentials"
}

variable "rds_config" {
  description = "Configuración de la instancia RDS"
  type = object({
    identifier           = string
    engine              = string
    engine_version      = string
    instance_class      = string
    storage_encrypted   = bool
    deletion_protection = bool
    allocated_storage   = number
    max_allocated_storage = number
    storage_type        = string
    db_name             = string
    port                = number
    multi_az            = bool
    parameter_group     = string
    backup_retention    = number
    backup_window       = string
    maintenance_window  = string
    skip_final_snapshot = bool
  })
  default = {
    identifier           = "labfinal-rds"
    engine              = "postgres"
    engine_version      = "14.10"
    instance_class      = "db.t3.micro"
    storage_encrypted   = true
    deletion_protection = false
    allocated_storage   = 20
    max_allocated_storage = 100
    storage_type        = "gp2"
    db_name             = "labfinaldb"
    port                = 5432
    multi_az            = true
    parameter_group     = "default.postgres14"
    backup_retention    = 1
    backup_window       = "03:00-06:00"
    maintenance_window  = "Mon:00:00-Mon:03:00"
    skip_final_snapshot = true
  }
}

variable "enabled_cloudwatch_logs" {
  description = "Lista de logs habilitados para CloudWatch"
  type        = list(string)
  default     = ["postgresql", "upgrade"]
}

variable "snapshot_identifier" {
  description = "ARN del snapshot para restaurar"
  type        = string
  default     = "arn:aws:rds:us-east-1:783764584164:snapshot:snapshot-labfinal-daniel-2024"
}


#REDSI

variable "redis_config" {
  description = "Configuración del grupo de replicación Redis"
  type = object({
    replication_group_id      = string
    description              = string
    engine                   = string
    node_type                = string
    num_cache_clusters       = number
    port                     = number
    parameter_group_name     = string
    automatic_failover       = bool
    multi_az                 = bool
    snapshot_retention_limit = number
    snapshot_window         = string
    maintenance_window      = string
  })
  default = {
    replication_group_id      = "labfinal-redis"
    description              = "Redis replication group for Labfinal"
    engine                   = "redis"
    node_type                = "cache.t3.micro"
    num_cache_clusters       = 2
    port                     = 6379
    parameter_group_name     = "default.redis7"
    automatic_failover       = true
    multi_az                 = true
    snapshot_retention_limit = 7
    snapshot_window         = "00:00-05:00"
    maintenance_window      = "sun:05:00-sun:09:00"
  }

  validation {
    condition     = can(regex("^cache\\.", var.redis_config.node_type))
    error_message = "El tipo de nodo debe comenzar con 'cache.'"
  }

  validation {
    condition     = var.redis_config.num_cache_clusters >= 2
    error_message = "El número de clusters debe ser al menos 2 para habilitar la replicación"
  }
}

variable "redis_subnet_group_name" {
  description = "Nombre del grupo de subnets para Redis"
  type        = string
  default     = "redis-subnet-group"
}

#ROUTE53

variable "route53_config" {
  description = "Configuración de la zona DNS privada"
  type = object({
    zone_name = string
    zone_tags = string
  })
  default = {
    zone_name = "labfinal.internal"
    zone_tags = "labfinal-internal"
  }
}

variable "dns_records" {
  description = "Configuración de los registros DNS"
  type = map(object({
    name = string
    type = string
    ttl  = number
  }))
  default = {
    db = {
      name = "db.labfinal.internal"
      type = "CNAME"
      ttl  = 300
    }
    nlb = {
      name = "nlb.labfinal.internal"
      type = "CNAME"
      ttl  = 300
    }
    internal_alb = {
      name = "internal-alb.labfinal.internal"
      type = "CNAME"
      ttl  = 300
    }
    redis = {
      name = "redis.labfinal.internal"
      type = "CNAME"
      ttl  = 300
    }
    efs = {
      name = "efs.labfinal.internal"
      type = "CNAME"
      ttl  = 300
    }
    memcached = {
      name = "memcached.labfinal.internal"
      type = "CNAME"
      ttl  = 300
    }
  }

  validation {
    condition = alltrue([
      for record in var.dns_records : contains(["A", "AAAA", "CNAME", "MX", "TXT", "PTR"], record.type)
    ])
    error_message = "El tipo de registro DNS debe ser uno de: A, AAAA, CNAME, MX, TXT, PTR"
  }
}

variable "s3_config" {
  description = "Configuración del bucket S3"
  type = object({
    bucket_name = string
    versioning  = string
  })
  default = {
    bucket_name = "labfinal-20242024"
    versioning  = "Enabled"
  }
}

variable "s3_public_access" {
  description = "Configuración de acceso público para el bucket S3"
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = {
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}

#Securiy groups

variable "security_groups" {
  description = "Configuración de los grupos de seguridad"
  type = map(object({
    name        = string
    description = string
    ingress = object({
      description = string
      port        = number
      protocol    = string
    })
  }))
  default = {
    nlb = {
      name        = "nlb-sg"
      description = "Grupo de seguridad para NLB externo"
      ingress = {
        description = "HTTPS desde cualquier lugar"
        port        = 443
        protocol    = "tcp"
      }
    }
    internal_alb = {
      name        = "internal-alb-sg"
      description = "Grupo de seguridad para el ALB interno"
      ingress = {
        description = "HTTPS desde VPC"
        port        = 443
        protocol    = "tcp"
      }
    }
    lt = {
      name        = "lt-sg"
      description = "Grupo de seguridad para el Launch Template"
      ingress = {
        description = "HTTPS desde ALB interno"
        port        = 443
        protocol    = "tcp"
      }
    }
    rds = {
      name        = "rds-sg"
      description = "Grupo de seguridad para RDS"
      ingress = {
        description = "PostgreSQL desde Launch Template"
        port        = 5432
        protocol    = "tcp"
      }
    }
    redis = {
      name        = "redis-sg"
      description = "Grupo de seguridad para Redis"
      ingress = {
        description = "Redis desde Launch Template"
        port        = 6379
        protocol    = "tcp"
      }
    }
    efs = {
      name        = "efs-sg"
      description = "Grupo de seguridad para EFS"
      ingress = {
        description = "NFS desde Launch Template"
        port        = 2049
        protocol    = "tcp"
      }
    }
    memcached = {
      name        = "memcached-sg"
      description = "Grupo de seguridad para Memcached"
      ingress = {
        description = "Memcached desde Launch Template"
        port        = 11211
        protocol    = "tcp"
      }
    }
  }
}

variable "egress_config" {
  description = "Configuración estándar para el tráfico saliente"
  type = object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    description = "Todo el trafico saliente"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "vpc_config" {
  description = "Configuración de la VPC"
  type = object({
    name = string
    cidr = string
    azs  = list(string)
    private_subnets = list(string)
    public_subnets  = list(string)
  })
  default = {
    name = "Labfinal"
    cidr = "10.0.0.0/16"
    azs  = ["us-east-1a", "us-east-1b"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  }
}

variable "vpc_features" {
  description = "Características de la VPC"
  type = object({
    enable_nat_gateway = bool
    single_nat_gateway = bool
    one_nat_gateway_per_az = bool
    enable_dns_hostnames = bool
    enable_dns_support = bool
  })
  default = {
    enable_nat_gateway = true
    single_nat_gateway = false
    one_nat_gateway_per_az = true
    enable_dns_hostnames = true
    enable_dns_support = true
  }
}

variable "kms_key_id" {
  description = "ARN de la clave KMS personalizada"
  type        = string
  default     = "arn:aws:kms:us-east-1:783764584164:key/cd30a858-89c5-42b0-b840-8b5d9da5ca02"
}