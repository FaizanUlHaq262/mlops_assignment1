pipeline {
    agent any
    triggers {
            //this will trigger this jenkins job when the merger happens
            githubPush branch: 'master'
            
        }
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
                    bat '''
                    docker stop flask-app || exit /b 0
                    docker rm flask-app || exit /b 0
                    docker run -d -p 5000:5000 --name flask-app %DOCKER_IMAGE%
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
                to: 'faizan.official262@gmai.com'
            )
        }
        failure {
            emailext (
                subject: 'Failed Deployment',
                body: 'Check Jenkins logs for more details due to failure of email being not sent',
                to: 'faizan.official262@gmai.com'
            )
        }
    }
}