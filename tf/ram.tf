resource "null_resource" "invite" {
# Listing the resolver rules and finding the Arm
# aws   route53resolver  list-resolver-rules

depends_on = [aws_route53_resolver_rule.radarhacker]
      provisioner "local-exec" {
        command = <<-EOT
            aws ram create-resource-share \
            --region eu-west-3 \
            --name MyRuleShare2 \
            --permission-arns arn:aws:ram::aws:permission/AWSRAMDefaultPermissionLicenseConfiguration \
            --resource-arns ${aws_route53_resolver_rule.radarhacker.arn} \
            --principals ${var.account-id-share}
            EOT
        }
}