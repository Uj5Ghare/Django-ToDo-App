pipeline {
    agent any 

    stages {
        stage("Checkout") {
            steps {
                git branch:"main", url:"https://github.com/Uj5Ghare/Django-ToDo-App.git"
            }
        }

        stage("Docker_Build") {
            steps {
                sh "docker build -t todo-app ."
            }
        }

        stage("Docker_Run") {
            steps {
                sh "docker run -d -e app='todo-app' -p 8000:8000 todo-app"
            }
        }
    }
    post {
        success {
            echo "successs"
        }
    }
}
