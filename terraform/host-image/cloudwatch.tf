resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "${var.project_name}-ecs-logs"
  retention_in_days = 14
}

resource "aws_cloudwatch_metric_alarm" "ec2_scaling_out_alarm" {
  alarm_name          = "${var.project_name} CPU utilization greater than 50%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"
  alarm_description   = "Alarm if CPU utilization is greater than 50% of reserved CPU"
  dimensions = {
    "Name"  = "ClusterName"
    "Value" = aws_ecs_cluster.ecs_cluster.name
  }
  alarm_actions = [aws_appautoscaling_policy.ecs_scaling_policy.arn]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm_high" {
  alarm_name          = "${var.project_name} CPU utilization greater than 50%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"
  alarm_description   = "Alarm if CPU too high or metric disappears indicating instance is down"
  dimensions = {
    "Name"  = "AutoScalingGroupName"
    "Value" = aws_autoscaling_group.ecs_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.ec2_scaling_policy.arn]
}