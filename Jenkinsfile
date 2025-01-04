pipeline {
    agent any
    environment {
        KUBECONFIG = 'C:/Users/OGS/.kube/config'  // Your Kube config path
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
                bat 'docker run -d -p 85:80 --name test-container mohanmanav/intellipaat-app:04'
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
                docker push mohanmanav/intellipaat-app:04
                '''
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                bat 'kubectl apply -f deployment.yaml'  // Apply the Deployment YAML
                bat 'kubectl apply -f service.yaml'     // Apply the Service YAML
            }
        }
    }
}
