pipeline {
	agent any
	
	stages{
		stage('Checkout'){
			git 'https://github.com/sandeepajay1/EC2_create.git'
			}
		}
		stage('terraform init'){
			steps{
				sh 'terraform init'
				}
			}
		stage('terraform plan and apply'){
			steps{
				sh 'terraform plan'
				sh 'terraform apply -auto approve'
				}
			}
}
