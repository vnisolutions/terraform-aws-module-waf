####----------------------------------------------
## WAF: For cloudfront
####----------------------------------------------
resource "aws_wafv2_web_acl" "this" {
  name        = "${var.env}-${var.project_name}-waf"
  description = "${var.env}-${var.project_name}-waf"
  scope       = "CLOUDFRONT"
  provider    = aws.global
  tags        = {}
  default_action {
    allow {}
  }
  visibility_config {
    metric_name                = "${var.env}-${var.project_name}-waf"
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
  }

  ##---------------- [ Rule ] ------------------------------
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "${var.env}-${var.project_name}-IP-Rate-Bases"
    priority = 6
    action {
      block {}
    }
    statement {
      rate_based_statement {
        scope_down_statement {
          not_statement {
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.whitelist.arn
              }
            }
          }
        }
        limit              = var.rate_limit
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      metric_name                = "${var.env}-${var.project_name}-IP-Rate-Bases"
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
    }
  }
}

##---------------- [ Whitelist ] ------------------------------
resource "aws_wafv2_ip_set" "whitelist" {
  provider           = aws.global
  name               = "${var.env}-${var.project_name}-whitelist"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.whitelist_ip
}

# resource "aws_wafv2_web_acl_logging_configuration" "waf_logs" {
#   provider     = aws.global
#   resource_arn = aws_wafv2_web_acl.this.arn
#   log_destination_configs = [
#     aws_cloudwatch_log_group.waf.arn
#   ]
# }

# resource "aws_cloudwatch_log_group" "waf" {
#   provider = aws.global
#   name     = "${var.env}-${var.project_name}-waf-logs"
# }
