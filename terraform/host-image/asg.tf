resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "${var.project_name}-ecs-asg"
  vpc_zone_identifier  = [aws_subnet.private_first_az.id, aws_subnet.private_second_az.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity = var.desired_capacity
  min_size         = 1
  max_size         = var.maximum_capacity
}

resource "aws_autoscaling_policy" "ec2_scaling_policy" {
  name                   = "${var.project_name}-ec2_scaling_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}

resource "aws_appautoscaling_policy" "ecs_scaling_policy" {
  name               = "${var.project_name}-ecs-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 50.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_target" "ecs_scaling_target" {
  max_capacity       = var.maximum_capacity
  min_capacity       = var.desired_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${var.project_name}"
  role_arn           = aws_iam_role.autoscaling_role.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on         = [aws_ecs_service.service]
}