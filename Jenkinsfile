pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'pip3 install -r requirements.txt'
            }
        }
        stage('Test') {
            steps {
                sh 'pytest'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo Deploying to staging...'
                // Add deployment script here
            }
        }
    }
    triggers {
        githubPush()
    }
    post {
        success {
            mail to: 'thupesh@gmail.com',
                 subject: "SUCCESS: Build #${env.BUILD_NUMBER}",
                 body: "The build succeeded!"
        }
        failure {
            mail to: 'thupesh@gmail.com',
                 subject: "FAILURE: Build #${env.BUILD_NUMBER}",
                 body: "The build failed!"
        }
    }
}
