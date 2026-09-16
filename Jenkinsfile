pipeline {
    agent any

    environment {
        // Inject Jenkins credentials (ID = mongodb-atlas-creds)
        MONGO_CREDS = credentials('mongodb-atlas-creds')
    }

    stages {
        stage('Build') {
            steps {
                echo 'Installing dependencies...'
                sh 'python3 -m venv venv'
                sh './venv/bin/pip install -r requirements.txt'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                script {
                    // Construct MongoDB URI using injected credentials
                    def mongoUri = "mongodb+srv://${MONGO_CREDS_USR}:${MONGO_CREDS_PSW}@studentdb.tetcnkr.mongodb.net/StudentDB?retryWrites=true&w=majority"

                    // Export URI before running pytest
                    sh """
                    export MONGO_URI=${mongoUri}
                    ./venv/bin/python -m pytest
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying Flask app with MongoDB Atlas..."
                script {
                    // Construct MongoDB URI again for deployment
                    def mongoUri = "mongodb+srv://${MONGO_CREDS_USR}:${MONGO_CREDS_PSW}@studentdb.tetcnkr.mongodb.net/StudentDB?retryWrites=true&w=majority"

                    // Export URI so Flask app can read it
                    sh """
                    export MONGO_URI=${mongoUri}
                    nohup ./venv/bin/python app.py &
                    """
                }
            }
        }
    }

    post {
        success {
            mail to: 'thupesh@gmail.com',
                 subject: "Pipeline Success",
                 body: "Build, test, and deploy completed successfully."
        }
        failure {
            mail to: 'thupesh@gmail.com',
                 subject: "Pipeline Failed",
                 body: "Pipeline failed. Please check Jenkins console output."
        }
    }
}
