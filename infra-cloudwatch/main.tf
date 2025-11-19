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
resource "aws_cloudwatch_metric_alarm" "companies_detected_high"{
    alarm_name = "kandidat49-CompaniesDetected-High"

    comparison_operator = "GreaterThanThreshold"

    evaluation_periods = 1
    metric_name = "sentiment.analysis.companies.detected"
    namespace = "kandidat49"
    period = 60
    statistic = "Average"
    threshold = 6
    alarm_description = "Triggered when too many companies in a single analysis"
    alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_dashboard" "app_dashboard" {
    dashboard_name = "kandidat49-SentimentDashboard"
    dashboard_body = jsonencode({
       widgets = [
           {
               "type" = "metric",
               "x" = 0 ,
               "y" = 0,
               "width" = 12,
               "height" =  6,
               "properties" =  {
                   "title" =  "Sentiment analysis duration"
                   "region" = "eu-west-1"
                   "metrics" : [
                       "kandidat49", "sentiment.analysis.duration"
                       ],
              " period" : 60,
               "stat" : "Average",
               "view" : "timeSeries",
               "annotations" = {}

               }
           },
           {
            "type" = "metric",
            "x" = 12,
            "y" = 0,
            "width" = 12,
            "height" = 6,
            "properties" = {
                "title" = "Companies Detected (Gauge)"
                "metrics" = [
                    ["kandidat49", "sentiment.analysis.total"]
                ],
                "stat" = "Maximum",
                "period" = 60,
                "view" = "singleValue",
                "annotations" = {}

              }

             }
           ]
        })

}