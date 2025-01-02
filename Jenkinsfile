pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/mohanmanav/intellipaat-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('mohanmanav/intellipaat-app:latest')
                }
            }
        }
        stage('Run Container Locally') {
            steps {
                script {
                    sh 'docker run -d -p 85:80 --name test-container mohanmanav/intellipaat-app:latest'
                }
            }
        }
        stage('Test Application') {
            steps {
                script {
                    def responseCode = sh(
                        script: "curl -o /dev/null -s -w '%{http_code}' http://localhost:85",
                        returnStdout: true
                    ).trim()
                    if (responseCode != '200') {
                        error "Test failed! Response code: ${responseCode}"
                    }
                }
            }
        }
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        sh 'docker push mohanmanav/intellipaat-app:latest'
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }
    post {
        always {
            script {
                sh 'docker rm -f test-container || true'
            }
        }
        failure {
            echo 'Pipeline failed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
    }
}
