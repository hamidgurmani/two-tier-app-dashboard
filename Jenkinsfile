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
        echo "🔍 Checking application health endpoint..."

        for i in {1..12}; do
            if curl -sf http://localhost:5000/health > /dev/null; then
                echo "✅ Application is healthy"
                exit 0
            fi
            echo "Waiting for app..."
            sleep 5
        done

        echo "❌ Application failed health check"
        docker logs flask-web
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

