#!/bin/bash

# Update package lists
apt update -y

# Install Apache2
apt install -y apache2

# Get the instance ID using the instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

if [ -z "$INSTANCE_ID" ]; then
    echo "Failed to retrieve instance ID."
    exit 1
fi

# Install the AWS CLI
apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Verify AWS CLI installation
if ! command -v aws &> /dev/null; then
    echo "AWS CLI could not be installed."
    exit 1
fi

# Download the images from S3 bucket
aws s3 cp s3://myterraformprojectbucket2023/project.webp /var/www/html/project.png --acl public-read

# Create a simple HTML file with the portfolio content and display the images
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>My Portfolio</title>
  <style>
    /* Add animation and styling for the text */
    @keyframes colorChange {
      0% { color: red; }
      50% { color: green; }
      100% { color: blue; }
    }
    h1 {
      animation: colorChange 2s infinite;
    }
  </style>
</head>
<body>
  <h1>Terraform Project Server 1</h1>
  <h2>Instance ID: <span style="color:green">$INSTANCE_ID</span></h2>
  <p>Welcome to Abhishek Veeramalla's Channel</p>
  <img src="project.png" alt="Project Image">
</body>
</html>
EOF

# Start Apache and enable it on boot
systemctl start apache2
systemctl enable apache2

# Debugging outputs
echo "Script completed successfully."
echo "Instance ID: $INSTANCE_ID"
