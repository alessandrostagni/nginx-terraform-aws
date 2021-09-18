# nginx-terraform-aws

- Log files grows infinitely.
- Some commands run as root.
- Log records returned by the search could be incomplete.
- No testing (e.g. pytest for script)
- Using Amazon Linux python3, not installing my own
- Flask server is not behind Nginx. Not ideal, but it makes more sense as its scope is to monitor the nginx container, so good to have them decoupled. Probably better to have that in a container anyway.