aws_region 				= "us-east-1"
aws_profile 			= "hawkeye"
#localip 				= "${locals.ip}"
localip 				= "116.74.242.82"
docker_key_name        	= "docker"
docker_key_path 		= "/root/.ssh/docker.pub"
ansible_key_name        = "ansible"
ansible_key_path 		= "/root/.ssh/ansible.pub"
instance_type			= "t2.micro"
ami						= "ami-05062c82c75ed4335"
elb_healthy_threshold	= "2"
elb_unhealthy_threshold	= "2"
elb_timeout				= "3"
elb_interval			= "30"
asg_max					= "2"
asg_min					= "1"
asg_grace				= "300"
asg_hct					= "EC2"
asg_cap					= "2"
master_count			= "3"
slave_count				= "2"
docker_count			= "3"