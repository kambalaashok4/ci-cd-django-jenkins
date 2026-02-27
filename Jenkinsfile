pipeline {
    agent any
    environment {
        build_image = 'cicd:${BUILD_NUMBER}'
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
                python3 manage.py check
                '''
            }
        }
        stage('Run Tests') {
            steps {
                sh '''
                python3 manage.py test
                '''
            }
        }
        stage('build docker image') {
            steps {
                sh '''
                docker build -t cicd:${BUILD_NUMBER} .
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
                docker tag cicd:${BUILD_NUMBER} 865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd:${BUILD_NUMBER}
                docker push 865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd:${BUILD_NUMBER}
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