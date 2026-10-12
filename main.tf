resource "aws_instance" "my_instance" {
    ami = "ami-0c02fb55956c7d316"
    instance_type = "t3.micro"
    key_name = "myserver"
    tags = {
        Name = "my_instance_1"
    }
}

