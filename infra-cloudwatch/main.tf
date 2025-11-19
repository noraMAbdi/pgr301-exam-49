provider "aws" {
    region = "eu-west-1"
}

resource "aws_sns_topic" "alerts" {
    name = "sentiment-app-alerts"
}
resource "aws_sns_topic_subscription" "email_sub"{
    topic_arn = aws_sns_topic.alerts.arn
    protocol = "email"
    endpoint = var.alert_email
  }
resource "aws_cloudwatch_metric_alarm" "latency_alarm"{
    alarm_name = "HighLatency"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    metric_name = "Latency"
    namespace = "SentimentApp"
    period = 60
    statistic = "Average"
    threshold = 6
    alarm_description = "Triggered when latency above 6 sec"
    alarm_actions
}

resource "aws_cloudwatch_dashboard" "app_dashboard"{
    dashboard_name = "kandidat49Dash"
    dashboard_body = jsonencode({
       widgets = [
           {
               type = "metric"
               x = 0
               y = 0
               width = 12
               height = 6
               properties = {
                   metrics = [
                       "SentimentApp", "Latency"],
               period = 60
               stat = "Average"
               title = "Latency Over Time"
               }
               },
           {
            type = "metric"
            x = 12
            y = 0
            width = 12
            height = 6
            properties = {
                metrics = [
                    ["SentimentApp", "ErrorCount"],
                ]
                stat = "Sum"
                period = 60
                title = "Error Count"
              }

             }
           ]
        })

}