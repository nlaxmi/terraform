aws_region 				= "us-east-1"
aws_profile 			= "hawkeye"
#localip 				= "${locals.ip}"
localip 				= "115.98.182.119"
db_instance_class       = "db.t2.micro"
dbname                  = "hawkeye"
dbuser                  = "hawkeye"
dbpassword              = "hawkeyepass"
key_name        		= "hawkeye"
public_key_path 		= "/root/.ssh/hawkeye.pub"
domain_name 			= "hawkeye"
dev_instance_type		= "t2.micro"
dev_ami					= "ami-05062c82c75ed4335"
elb_healthy_threshold	= "2"
elb_unhealthy_threshold	= "2"
elb_timeout				= "3"
elb_interval			= "30"
asg_max					= "2"
asg_min					= "1"
asg_grace				= "300"
asg_hct					= "EC2"
asg_cap					= "2"
lc_instance_type		= "t2.micro"
