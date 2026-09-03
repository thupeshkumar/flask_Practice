pipeline {
    agent any

    environment {
        MONGO_URI = 'mongodb://root:password@localhost:27017/student_db?authSource=admin'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Installing dependencies...'
                sh '''
                python3 -m venv venv
                venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                sh '''
                export MONGO_URI=${MONGO_URI}
                venv/bin/python -m pytest -v
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to staging...'
                sh '''
                export MONGO_URI=${MONGO_URI}
                nohup venv/bin/python app.py &
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
            mail to: 'thupesh@gmail.com',
                 subject: 'Jenkins Pipeline Success',
                 body: 'Build, test and deployment completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
            mail to: 'thupesh@gmail.com',
                 subject: 'Jenkins Pipeline Failed',
                 body: 'Jenkins pipeline failed. Please check console output.'
        }
    }
}
