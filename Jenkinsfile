pipeline {
    agent any
    environment {
        KUBECONFIG = 'C:\\path\\to\\kubeconfig' // Replace with the path to your kubeconfig file
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/mohanmanav/intellipaat-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t mohanmanav/intellipaat-app:latest .'
            }
        }
        stage('Run Container Locally') {
            steps {
                bat 'docker run -d -p 85:80 --name test-container mohanmanav/intellipaat-app:latest'
            }
        }
        stage('Test Application') {
            steps {
                bat '''
                curl -o nul -s -w "%%{http_code}" http://localhost:85 > response.txt
                set /p RESPONSE=<response.txt
                if "%RESPONSE%" NEQ "200" exit /b 1
                '''
            }
        }
        stage('Push to DockerHub') {
            steps {
                bat '''
                docker login -u <your-username> -p <your-password>
                docker push mohanmanav/intellipaat-app:latest
                '''
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
            bat 'docker stop test-container || true'
            bat 'docker rm test-container || true'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
