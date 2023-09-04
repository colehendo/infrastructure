resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"
}

resource "aws_ecs_service" "service" {
  name            = var.project_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.desired_capacity
  iam_role        = aws_iam_role.ecs_service_role.arn
  depends_on      = [aws_lb_listener.alb_listener]
  load_balancer {
    container_name   = "${var.project_name}"
    container_port   = 5000
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = data.aws_ami.latest_ecs_ami.image_id
  security_groups      = [aws_security_group.ecs_sg.id]
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=ecs_cluster >> /etc/ecs/ecs.config"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "${var.project_name}-ecs-app"
  container_definitions = <<DEFINITION
[
  {
    "name": "${var.project_name}",
    "cpu": 10,
    "image": "${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_image}",
    "essential": true,
    "memory": 300,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${var.project_name}-ecs-logs",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.project_name}"
      }
    },
    "mountPoints": [
      {
        "containerPath": "/usr/local/apache2/htdocs",
        "sourceVolume": "${var.project_name}-volume"
      }
    ],
    "portMappings": [
      {
        "containerPort": 5000
      }
    ]
  }
]
DEFINITION
  volume {
    name = "${var.project_name}-volume"
  }
}
