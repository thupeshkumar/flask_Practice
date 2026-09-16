pipeline {
    agent any

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
                withCredentials([usernamePassword(credentialsId: 'mongodb-atlas-creds',
                                                  usernameVariable: 'MONGO_USER',
                                                  passwordVariable: 'MONGO_PASS')]) {
                    sh '''
                    export MONGO_URI="mongodb+srv://${MONGO_USER}:${MONGO_PASS}@studentdb.tetcnkr.mongodb.net/StudentDB?retryWrites=true&w=majority"
                    ./venv/bin/python -m pytest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying Flask app with MongoDB Atlas..."
                withCredentials([usernamePassword(credentialsId: 'mongodb-atlas-creds',
                                                  usernameVariable: 'MONGO_USER',
                                                  passwordVariable: 'MONGO_PASS')]) {
                    sh '''
                    export MONGO_URI="mongodb+srv://${MONGO_USER}:${MONGO_PASS}@studentdb.tetcnkr.mongodb.net/StudentDB?retryWrites=true&w=majority"
                    nohup ./venv/bin/python app.py &
                    '''
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
