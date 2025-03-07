pipeline {
    agent any

    environment { 
        DOCKER_CREDENTIALS_ID = 'dockerhub-creds'
        DOCKER_IMAGE = "faizan262/mlops_assignment1:latest"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/FaizanUlHaq262/mlops_assignment1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t %DOCKER_IMAGE% ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        bat '''
                            echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
                            docker push %DOCKER_IMAGE%
                        '''
                    }
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // First, check if the container is running. If it is, stop and remove it.
                    def containerExist = bat(script: 'docker ps -aq -f name=flask-app', returnStdout: true).trim()

                    if (containerExist) {
                        // Stop and remove the container only if it exists
                        bat '''
                            docker stop flask-app || exit /b 0
                            docker rm flask-app || exit /b 0
                        '''
                    }

                    // Run the new container
                    bat '''
                        docker run -d -p 5003:5003 --name flask-app %DOCKER_IMAGE%
                    '''
                }
            }
        }
    }

    post {
        success {
            emailext (
                subject: 'Successful Deployment',
                body: '''
                    Flask ML app has been successfully deployed via Jenkins!

                    Image: ${DOCKER_IMAGE}
                    Container Name: flask-app
                ''',
                to: 'faizan.official262@gmail.com'
            )
        }
        failure {
            emailext (
                subject: 'Failed Deployment',
                body: 'Check Jenkins logs for more details due to failure of email being not sent',
                to: 'faizan.official262@gmail.com'
            )
        }
    }
}
