# Create a VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name            = "${var.name}-${var.env}"
  cidr            = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = true
  enable_vpn_gateway = false
}

# Create an ECS Cluster
module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.6.0"

  cluster_name = "${var.name}-${var.env}"
}

# Create an Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.7.0"

  name               = "${var.name}-${var.env}"
  internal           = false
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
}

# SG for Fargate tasks to allow traffic only from ALB
resource "aws_security_group" "ecs_sg" {
  name_prefix = "ecs-sg-${var.env}"
  description = "ECS Fargate Security Group for React App"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow traffic only from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow outbound traffic (e.g., API calls, DB, external services)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an ECS Fargate Service
resource "aws_ecs_service" "react_app" {
  name            = "react-app-${var.env}"
  cluster         = aws_ecs_cluster.react_app.id
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets  
    security_groups  = [aws_security_group.ecs_sg.id]  
    assign_public_ip = false 
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.react_app.arn
    container_name   = "react-app"
    container_port   = 80
  }
}

resource "aws_route53_record" "react_app_dns" {
  zone_id = var.hosted_zone_id
  name    = "${var.env}-${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.react_app_alb.dns_name
    zone_id                = aws_lb.react_app_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_cloudwatch_log_group" "react_app_log_group" {
  name              = "/ecs/react-app-${var.env}"
  retention_in_days = 10
}

# Autoscale ECS tasks
resource "aws_appautoscaling_target" "ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.react_app.name}/${aws_ecs_service.react_app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_task_count
  max_capacity       = var.max_task_count
}

# Autoscale when CPU reaches > 60
resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name               = "ecs-cpu-scaling-${var.env}"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = 60.0  # Scale up when CPU > 60%
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}