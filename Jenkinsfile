pipeline {
    agent any

    environment {
        VENV_DIR   = "venv"
        STAGING_DIR = "/opt/staging/flask_practice"   // change to your staging path
        APP_PORT    = "8000"
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }

    triggers {
        // Backup poll in case the webhook is missed; the real trigger is the
        // GitHub webhook configured in Manage Jenkins > System.
        pollSCM('H/5 * * * *')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build - Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    pip install pytest pytest-cov
                '''
            }
        }

        stage('Test - Run Pytest') {
            steps {
                sh '''
                    . ${VENV_DIR}/bin/activate
                    pytest --junitxml=test-results.xml --cov=. --cov-report=xml
                '''
            }
            post {
                always {
                    junit 'test-results.xml'
                }
            }
        }

        stage('Deploy - Staging') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    . ${VENV_DIR}/bin/activate
                    mkdir -p ${STAGING_DIR}
                    rsync -a --exclude ${VENV_DIR} --exclude .git ./ ${STAGING_DIR}/

                    # Restart the staging Flask app (adjust to your process manager).
                    # Example using a simple pkill/nohup pattern:
                    pkill -f "app.py" || true
                    cd ${STAGING_DIR}
                    nohup ${WORKSPACE}/${VENV_DIR}/bin/python app.py --port=${APP_PORT} > staging.log 2>&1 &
                '''
            }
        }
    }

    post {
        success {
            emailext (
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """<p>Build succeeded.</p>
                         <p>Job: ${env.JOB_NAME}</p>
                         <p>Build number: ${env.BUILD_NUMBER}</p>
                         <p>Check console output at <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                to: "${env.NOTIFY_EMAIL ?: 'your-email@example.com'}",
                mimeType: 'text/html'
            )
        }
        failure {
            emailext (
                subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """<p>Build failed.</p>
                         <p>Job: ${env.JOB_NAME}</p>
                         <p>Build number: ${env.BUILD_NUMBER}</p>
                         <p>Check console output at <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                to: "${env.NOTIFY_EMAIL ?: 'your-email@example.com'}",
                mimeType: 'text/html'
            )
        }
        always {
            cleanWs()
        }
    }
}
