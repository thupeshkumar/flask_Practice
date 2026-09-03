pipeline {
    agent any
   stage('Build') {
      steps {
               sh '''
               python3 -m venv venv
               source venv/bin/activate
               pip install --upgrade pip
               pip install -r requirements.txt
               '''
            }
      }

        stage('Test') {
            steps {
                sh '''
                source venv/bin/activate
                pytest -v
		'''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                chmod +x deploy.sh
                ./deploy.sh
                '''
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
