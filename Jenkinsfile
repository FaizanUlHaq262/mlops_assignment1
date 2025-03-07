pipeline {
    agent any

    environment { 
        DOCKER_CREDENTIALS_ID = 'dockerhub-creds'
        DOCKER_IMAGE = "faizan262/mlops_assignment1:latest"
    }

    stages { // The stages execute the taskes in the following order
             // 1. Clone the repo
             // 2. Build and Test
             // 3. Docker Build and Push to Hub
             // 4. Deploying the container
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/FaizanUlHaq262/mlops_assignment1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            docker push ${DOCKER_IMAGE}
                        '''
                }
            }
        }
    }

        stage('Deploy Container') {
            steps {
                script {
                    sh """
                    # Remove existing container if it exists
                    docker stop flask-app || true && docker rm flask-app || true
                    # Run new container
                    docker run -d -p 5000:5000 --name flask-app ${DOCKER_IMAGE}
                    """
                }
            }
        }
    }

    post {
        success {
            emailext (
                subject: 'Succesful Deployment',
                body: '''
                    Flask ML app has been successfully deployed via Jenkins!

                    Image: ${DOCKER_IMAGE}
                    Container Name: flask-app
                ''',
                to: 'faizan.official262@gmai.com'
            )
        }
        failure {
            emailext (
                subject: 'Failed Deploymnet',
                body: 'Check Jenkins logs for more details due to failure of email being not sent',
                to: 'faizan.official262@gmai.com'
            )
        }
    }
}
