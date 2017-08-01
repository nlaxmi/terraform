aws_region 		= "us-west-2"
aws_profile 		= "lldev01"
localip 		= "115.248.5.193"
db_instance_class       = "db.t2.micro"
dbname                  = "lldev01"
dbuser                  = "lldev01"
dbpassword              = "lldev01pass"
key_name        	= "lldev01"
public_key_path 	= "/root/.ssh/lldev01.pub"
domain_name 		= "linuxlibrary"
dev_instance_type	= "t2.micro"
dev_ami			= "ami-b55a51cc"
elb_healthy_threshold	= "2"
elb_unhealthy_threshold	= "2"
elb_timeout		= "3"
elb_interval		= "30"
asg_max			= "2"
asg_min			= "1"
asg_grace		= "300"
asg_hct			= "EC2"
asg_cap			= "2"
lc_instance_type	= "t2.micro"
delegation_sets		= ""
