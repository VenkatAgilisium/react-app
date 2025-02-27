output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.react_app_alb.dns_name
}

output "route53_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) from Route 53"
  value       = aws_route53_record.react_app.fqdn
}

