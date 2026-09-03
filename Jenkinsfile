pipeline {
    agent any

    environment {
        MONGO_URI = 'mongodb://localhost:27017/test_student_db'
    }  

    stages {
        stage('Build') {
            steps {
                sh 'pip3 install -r requirements.txt'
            }
        }

        stage('Test') {
            steps {
                sh 'python3 -m pytest'
            }
        }

        stage('Deploy') {
            steps {
                    sh '''
                    mkdir -p /opt/staging
                    cp -rf * /opt/staging/
                    echo "Application deployed to staging."
                    '''
                }
        }
    }

    post {
    success {
        catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS') {
            emailext(
                to: 'thupesh@gmail.com',
                subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build completed successfully."
            )
        }
    }

    failure {
        catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS') {
            emailext(
                to: 'thupesh@gmail.com',
                subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build failed."
            )
        }
    }
}
    
}
