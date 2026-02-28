// pipeline {
//     agent any
//     environment {
//         build_image = 'cicd:${BUILD_NUMBER}'
//     }
//     stages {

//         stage('Checkout Code') {
//             steps {
//                 git branch: 'main', url: 'https://github.com/kambalaashok4/ci-cd-django-jenkins.git'
//             }
//         }

//         stage('Install dependencies') {
//             steps {
//                 sh '''
//                 pip install --upgrade pip
//                 pip install -r requirements.txt
//                 '''
//             }
//         }

//         stage('Run Django Checks') {
//             steps {
//                 sh '''
//                 python3 manage.py check
//                 '''
//             }
//         }
//         stage('Run Tests') {
//             steps {
//                 sh '''
//                 python3 manage.py test
//                 '''
//             }
//         }
//         stage('build docker image') {
//             steps {
//                 sh '''
//                 docker build -t cicd:${BUILD_NUMBER} .
//                 '''
//             }
//         }
//         stage('Login to AWS ECR') {
//             steps {
//                 sh '''
//                 aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 865487342006.dkr.ecr.us-east-1.amazonaws.com
//                 '''
//             }
//         }
//         stage('Push Docker Image to ECR') {
//             steps {
//                 sh '''
//                 docker tag cicd:${BUILD_NUMBER} 865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd:${BUILD_NUMBER}
//                 docker push 865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd:${BUILD_NUMBER}
//                 '''
//             }
//         }
//         stage('deploy to ecs') {
//             steps {
//                 sh '''
//                 aws ecs update-service --cluster comfortable-gorilla-jslweh --service cicd-jenkins-service --force-new-deployment --region us-east-1
//                 '''
//             }
//     }
// }
//     post {
//         success {
//             echo 'Build Successful 🎉'
//         }
//         failure {
//             echo 'Build Failed ❌'
//         }
//     }
// }



pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        //ECR_REPO = "865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd"
        ECR_REPO = "865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd"
        IMAGE_TAG = "${BUILD_NUMBER}"
        TERRAFORM_DIR = "terraform"
    }

    stages {

        // -----------------------------
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/kambalaashok4/ci-cd-django-jenkins.git'
            }
        }

        // -----------------------------
        stage('Install Dependencies') {
            steps {
                sh '''
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        // -----------------------------
        stage('Run Django Checks') {
            steps {
                sh 'python3 manage.py check'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'python3 manage.py test'
            }
        }

        // -----------------------------
        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t cicd:${IMAGE_TAG} .
                docker tag cicd:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
                """
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ECR_REPO}
                """
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh "docker push ${ECR_REPO}:${IMAGE_TAG}"
            }
        }

        // -----------------------------
        stage('Trigger Deployment') {
            when {
                branch 'deploy-dev', 'deploy-staging', 'deploy-prod'
            }
            steps {
                script {
                    // Determine environment based on branch
                    def environment = env.BRANCH_NAME.replace('deploy-', '')
                    echo "Deploying to environment: ${environment}"

                    sh """
                    cd ${TERRAFORM_DIR}
                    terraform init 
                    terraform plan -var="image_uri=${ECR_REPO}:${IMAGE_TAG}"
                    terraform apply -auto-approve -var="image_uri=${ECR_REPO}:${IMAGE_TAG}"
                    """
                }
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline Successful 🎉"
        }
        failure {
            echo "Pipeline Failed ❌"
        }
    }
}