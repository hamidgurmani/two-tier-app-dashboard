pipeline {
    agent any

    environment {
        IMAGE_NAME     = "flask-app"
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
                docker build -t ${IMAGE_NAME} .
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
                echo "🔍 Waiting for Flask app to become healthy..."

                MAX_ATTEMPTS=12
                SLEEP_TIME=5

                for i in $(seq 1 $MAX_ATTEMPTS); do
                    STATUS=$(docker inspect --format='{{.State.Health.Status}}' ${CONTAINER_NAME} 2>/dev/null || echo "not_found")
                    echo "Attempt $i/$MAX_ATTEMPTS → status: $STATUS"

                    if [ "$STATUS" = "healthy" ]; then
                        echo "✅ Application is healthy"
                        exit 0
                    fi

                    if [ "$STATUS" = "unhealthy" ]; then
                        echo "❌ Application reported unhealthy"
                        docker logs ${CONTAINER_NAME}
                        exit 1
                    fi

                    sleep $SLEEP_TIME
                done

                echo "❌ Timed out waiting for application to become healthy"
                docker ps -a
                docker logs ${CONTAINER_NAME} || true
                exit 1
                '''
            }
        }

        stage('Verify Containers') {
            steps {
                sh '''
                echo "📦 Running containers:"
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

