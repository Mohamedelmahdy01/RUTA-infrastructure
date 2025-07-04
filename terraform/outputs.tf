output "ec2_backend_public_ip" {
  value = aws_instance.backend.public_ip
}

output "ec2_backend_private_ip" {
  value = aws_instance.backend.private_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.frontend.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
} 