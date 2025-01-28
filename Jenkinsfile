pipeline {
    agent any

    environment {
        // Use Jenkins credentials for Docker Hub and Kubernetes
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')  // Store Docker Hub credentials in Jenkins
        KUBECONFIG = 'C:/Users/OGS/.kube/config'  // Path to kubeconfig file
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/mohanmanav/intellipaat-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t mohanmanav/intellipaat-app:04 .'
            }
        }

        stage('Run Container Locally') {
            steps {
                bat 'docker run -d -p 8585:80 --name test-container mohanmanav/intellipaat-app:04'
            }
        }

        stage('Test Application') {
            steps {
                bat '''
                curl -o nul -s -w "%%{http_code}" http://localhost:8585 > response.txt
                set /p RESPONSE=<response.txt
                if "%RESPONSE%" NEQ "200" exit /b 1
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                bat """
                docker login -u ${DOCKER_HUB_CREDENTIALS_USR} -p ${DOCKER_HUB_CREDENTIALS_PSW}
                docker push mohanmanav/intellipaat-app:04
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                bat 'kubectl apply -f deployment.yaml'
                bat 'kubectl apply -f service.yaml'
            }
        }
    }

    post {
        always {
            // Clean up Docker containers and images
            bat 'docker stop test-container || true'
            bat 'docker rm test-container || true'
            bat 'docker rmi mohanmanav/intellipaat-app:04 || true'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}