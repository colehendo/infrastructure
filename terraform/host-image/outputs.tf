output "flask_app_endpoint" {
  description = "The Application Load Balancer DNS name"
  value       = aws_lb.main.*.dns_name[0]
}