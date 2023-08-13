
output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}


output "jumbox_public_ip" {
   value = "${aws_instance.jumpbox.public_ip}"
}

output "route53_resolver_rule_share_arn" {
   value = "${aws_route53_resolver_rule.radarhacker.arn}"
}