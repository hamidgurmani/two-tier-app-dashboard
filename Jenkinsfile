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
                docker rm -f postgres-db flask-web || true
                '''
            }
        } 
        
        stage('Health Check') {
            steps {
                sh '''
                echo "Waiting for app to become healthy..."
                sleep 15
                
                STATUS=$(docker inspect --format='{{.State.Health.Status}}' flask-web)
                
                if [ "$STATUS" != "healthy" ]; then
                  echo "❌ Application is unhealthy"
                  docker ps
                  exit 1
                fi
                
                echo "✅ Application is healthy"
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

