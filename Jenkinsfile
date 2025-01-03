pipeline {
    agent any
    environment {
        KUBECONFIG = 'C:/Users/OGS/.kubeconfig' // Replace with the path to your kubeconfig file
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/mohanmanav/intellipaat-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t mohanmanav/intellipaat-app:03 .'
            }
        }
        stage('Run Container Locally') {
            steps {
                bat 'docker run -d -p 85:80 --name test-container mohanmanav/intellipaat-app:03'
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
                docker login -u mohanmanav -p Reeta@1980@Manav
                docker push mohanmanav/intellipaat-app:03
                '''
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                bat 'kubectl apply -f deployment.yaml --validate=false'
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
