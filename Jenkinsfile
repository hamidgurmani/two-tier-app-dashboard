pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask-app"
        CONTAINER_NAME = "flask-web"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Stop Old Containers') {
            steps {
                sh '''
                docker compose down || true
                '''
            }
        }

        stage('Start Application') {
            steps {
                sh '''
                docker compose up -d
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                echo "Waiting for app to become healthy..."
                sleep 15

                STATUS=$(docker inspect --format='{{.State.Health.Status}}' $CONTAINER_NAME 2>/dev/null || echo "not_found")

                if [ "$STATUS" != "healthy" ]; then
                  echo "❌ Application is unhealthy or container not found"
                  docker ps -a
                  exit 1
                fi

                echo "✅ Application is healthy"
                '''
            }
        }

        stage('Verify Containers') {
            steps {
                sh '''
                docker ps
                '''
            }
        }
    }

    post {
        failure {
            echo "❌ Deployment failed. Rolling back..."
            sh '''
            docker compose down || true
            docker compose up -d
            '''
        }

        success {
            echo "✅ Deployment completed successfully"
        }
    }
}

