pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Installing dependencies...'
                // Create virtual environment and install requirements
                sh 'python3 -m venv venv'
                sh './venv/bin/pip install -r requirements.txt'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                // Run pytest inside the virtual environment
                sh './venv/bin/python -m pytest'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying Flask app...'
                // Start the Flask app (replace with your deployment script)
                sh 'nohup ./venv/bin/python app.py &'
            }
        }
    }

    triggers {
        // Trigger pipeline on every push to GitHub main branch
        githubPush()
    }

    post {
        success {
            mail to: 'thupesh@gmail.com',
                 subject: "Jenkins Pipeline Success",
                 body: "Build, test, and deployment completed successfully."
        }
        failure {
            mail to: 'thupesh@gmail.com',
                 subject: "Jenkins Pipeline Failed",
                 body: "Pipeline failed. Please check Jenkins console output."
        }
    }
}
