pipeline {
    agent {
        docker {
            image 'python:3.12-slim'
        }
    }
    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/kambalaashok4/ci-cd-django-jenkins.git'
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run Django Checks') {
            steps {
                sh '''
                python manage.py check
                '''
            }
        }
        stage('Run Tests') {
            steps {
                sh '''
                . $VENV/bin/activate
                python manage.py test
                '''
            }
        }
        stage('build docker image') {
            steps {
                sh '''
                docker build -t django-app:latest .
                '''
            }
        }
        stage('Login to AWS ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 865487342006.dkr.ecr.us-east-1.amazonaws.com
                '''
            }
        }
        stage('Push Docker Image to ECR') {
            steps {
                sh '''
                docker tag cicd:latest 865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd:latest
                docker push 865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'Build Successful 🎉'
        }
        failure {
            echo 'Build Failed ❌'
        }
    }
}