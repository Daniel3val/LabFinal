# Crear el certificado SSL
resource "aws_acm_certificate" "ssl_certificate" {
  private_key       = file("clave.pem")
  certificate_body  = file("certificado.pem")
  tags = var.tags
}

