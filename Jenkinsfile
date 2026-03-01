pipeline {
    agent none

    environment {
        AWS_REGION   = "us-east-1"
        ECR_REPO     = "865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd"
        IMAGE_TAG    = "${BUILD_NUMBER}"
        TERRAFORM_DIR = "terraform"
    }

    stages {

        // -----------------------------
        stage('Checkout Code') {
            agent any
            steps {
                git branch: 'main', url: 'https://github.com/kambalaashok4/ci-cd-django-jenkins.git'
            }
        }

        // -----------------------------
        stage('Build & Push Image') {
            agent {
                docker {
                    image 'docker:29.2.1'
                    args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh """
                apk add --no-cache python3 py3-pip aws-cli

                // pip install --upgrade pip
                // pip install -r requirements.txt

                python3 manage.py check
                python3 manage.py test

                docker build -t cicd:${IMAGE_TAG} .
                docker tag cicd:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}

                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ECR_REPO}

                docker push ${ECR_REPO}:${IMAGE_TAG}
                """
            }
        }

        // -----------------------------
        stage('Terraform Deploy') {
            agent {
                docker {
                    image 'hashicorp/terraform:1.6'
                }
            }
            steps {
                sh """
                cd ${TERRAFORM_DIR}
                terraform init
                terraform plan -var="image_tag=${IMAGE_TAG}"
                terraform apply -auto-approve -var="image_tag=${IMAGE_TAG}"
                """
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










// pipeline {
//     agent any

//     environment {
//         AWS_REGION = "us-east-1"
//         //ECR_REPO = "865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd"
//         ECR_REPO = "865487342006.dkr.ecr.us-east-1.amazonaws.com/cicd"
//         IMAGE_TAG = "${BUILD_NUMBER}"
//         TERRAFORM_DIR = "terraform"
//         BRANCH_NAME = "main"
//     }

//     stages {

//         // -----------------------------
//         stage('Checkout Code') {
//             steps {
//                 git branch: 'main', url: 'https://github.com/kambalaashok4/ci-cd-django-jenkins.git'
//             }
//         }

//         // -----------------------------
//         stage('Install Dependencies') {
//             steps {
//                 sh '''
//                 pip install --upgrade pip
//                 pip install -r requirements.txt
//                 '''
//             }
//         }

//         // -----------------------------
//         stage('Run Django Checks') {
//             steps {
//                 sh 'python3 manage.py check'
//             }
//         }

//         stage('Run Tests') {
//             steps {
//                 sh 'python3 manage.py test'
//             }
//         }

//         // -----------------------------
//         stage('Build Docker Image') {
//             steps {
//                 sh """
//                 docker build -t cicd:${IMAGE_TAG} .
//                 docker tag cicd:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
//                 """
//             }
//         }

//         stage('Login to AWS ECR') {
//             steps {
//                 sh """
//                 aws ecr get-login-password --region ${AWS_REGION} \
//                 | docker login --username AWS --password-stdin ${ECR_REPO}
//                 """
//             }
//         }

//         stage('Push Docker Image to ECR') {
//             steps {
//                 sh "docker push ${ECR_REPO}:${IMAGE_TAG}"
//             }
//         }

//         // -----------------------------
//         stage('Trigger Deployment') {
//     when {
//         branch 'main'
//     }
//     steps {
//         script {

//             // Determine environment based on branch
//             // def deployEnv = (env.BRANCH_NAME == 'main') ? 'production' : 'staging'

//             // echo "Deploying to environment: ${deployEnv}"

//             sh """
//             cd ${TERRAFORM_DIR}
//             terraform init
//             terraform plan -var="image_tag=${IMAGE_TAG}"
//             terraform apply -auto-approve -var="image_tag=${IMAGE_TAG}"
//             """
//         }
//     }
// }
        
//     }

//     post {
//         success {
//             echo "CI/CD Pipeline Successful 🎉"
//             sh """
//             docker rmi cicd:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
//             docker system prune -af
//             """

//         }
//         failure {
//             echo "Pipeline Failed ❌"
//             sh """
//             docker rmi cicd:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
//             docker system prune -af
//             """
//         }
//     }
// }