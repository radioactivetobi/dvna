pipeline {
    agent any
    
    stages {
        
        stage ('Initialization') {
            steps {
                sh 'echo "Starting the build"'
            }
        }
        
        stage ('Build') {
            steps {
                sh '''
                    export MYSQL_USER=root
                    export MYSQL_DATABASE=dvna
                    export MYSQL_PASSWORD=ayushpriya10
                    export MYSQL_HOST=127.0.0.1
                    export MYSQL_PORT=3306
                    npm install
                   '''
            }
        }
        
        stage ('SonarQube Analysis') {
            environment {
                scannerHome = tool 'SonarQube Scanner'
            }
            steps {
                withSonarQubeEnv ('SonarQube') {
                    sh '${scannerHome}/bin/sonar-scanner'
                    sh 'cat .scannerwork/report-task.txt'
                }
            }    
        }   
        
        stage ('Deploy to App Server') {
            steps {
                sshagent(['node-app-server']) {
                    sh 'echo "Deploying App to Server"'
                    sh 'ssh -o StrictHostKeyChecking=no chaos@10.0.2.20 "rm -rf dvna/ && mkdir dvna"'
                    sh 'scp -r * chaos@10.0.2.20:~/dvna'
                    sh 'ssh -o StrictHostKeyChecking=no chaos@10.0.2.20 "cd dvna && pm2 start server.js"'
                }                        
            }
        }
    }
}
