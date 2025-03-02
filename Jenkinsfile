pipeline {
    agent any

    environment { // We have to add our credentials here faizan bhai
        DOCKER_IMAGE = "your-dockerhub-username/your-image-name"
    }

    stages { // The stages execute the taskes in the following order
             // 1. Clone the repo
             // 2. Build and Test
             // 3. Docker Build and Push to Hub
             // 4. Deploying the container
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    sh 'docker run -d -p 5000:5000 --name flask-app $DOCKER_IMAGE'
                }
            }
        }
    }

    post {
        success {
            mail to: 'admin@example.com', // need to add your email address --- not 100% sure if this will work since no stmp gmail server is accessed or defined in the process
                 subject: 'Deployment Successful',
                 body: 'The latest version has been deployed successfully!'
        }
        failure {
            mail to: 'admin@example.com', 
                 subject: 'Deployment Failed',
                 body: 'The deployment process has failed. Please check Jenkins logs.'
        }
    }
}
