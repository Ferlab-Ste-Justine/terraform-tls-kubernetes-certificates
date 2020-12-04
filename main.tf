#https://kubernetes.io/docs/setup/best-practices/certificates/

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = var.ca_key_algorithm
  private_key_pem = var.ca_key

  subject {
    common_name  = "kubernetes"
  }

  validity_period_hours = var.ca_certificate_lifespan*24
  early_renewal_hours = var.ca_certificate_early_renewal_window*24

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "cert_signing",
  ]

  is_ca_certificate = true
}

resource "tls_self_signed_cert" "etcd_ca" {
  key_algorithm   = var.etcd_ca_key_algorithm
  private_key_pem = var.etcd_ca_key

  subject {
    common_name  = "etcd-ca"
  }

  validity_period_hours = var.etcd_ca_certificate_lifespan*24
  early_renewal_hours = var.etcd_ca_certificate_early_renewal_window*24

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "cert_signing",
  ]

  is_ca_certificate = true
}

resource "tls_self_signed_cert" "front_proxy_ca" {
  key_algorithm   = var.front_proxy_ca_key_algorithm
  private_key_pem = var.front_proxy_ca_key

  subject {
    common_name  = "front-proxy-ca"
  }

  validity_period_hours = var.front_proxy_ca_certificate_lifespan*24
  early_renewal_hours = var.front_proxy_ca_certificate_early_renewal_window*24

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "cert_signing",
  ]

  is_ca_certificate = true
}

resource "tls_cert_request" "client" {
  key_algorithm   = var.client_key_algorithm
  private_key_pem = var.client_key

  subject {
    common_name  = "kubernetes-admin"
    organization = "system:masters"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem   = tls_cert_request.client.cert_request_pem
  ca_key_algorithm   = var.ca_key_algorithm
  ca_private_key_pem = var.ca_key
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = var.client_certificate_lifespan*24
  early_renewal_hours = var.client_certificate_early_renewal_window*24

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "client_auth",
  ]

  is_ca_certificate = false
}