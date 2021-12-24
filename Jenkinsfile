pipeline {
    agent any
    
    stages {
        
        stage ('Initialization') {
            steps {
                sh 'echo "Starting the CI pipeline."'
            }
        }
        
        stage ('Build') {
            steps {
                sh 'npm install'
            }
        }
        
        stage ('SonarQube Analysis') {
            environment {
                scannerHome = tool 'SonarQube Scanner'
            }
            steps {
                withSonarQubeEnv ('SonarQube') {
                    sh '${scannerHome}/bin/sonar-scanner'
                    sh 'cat .scannerwork/report-task.txt > /var/lib/jenkins/reports/sonarqube-report'
                }
            }    
        }
        
        stage ('NPM Audit Analysis') {
            steps {
                sh '/home/chaos/npm-audit.sh'
            }
        }
        
        stage ('NodeJsScan Analysis') {
            steps {
                sh 'nodejsscan --directory `pwd` --output /var/lib/jenkins/reports/nodejsscan-report'
            }
        }
        
        stage ('Retire.js Analysis') {
            steps {
                sh 'retire --path `pwd` --outputformat json --outputpath /var/lib/jenkins/reports/retirejs-report --exitwith 0'
            }
        }
        
        stage ('Dependency-Check Analysis') {
            steps {
                sh '/var/lib/jenkins/dependency-check/bin/dependency-check.sh --scan `pwd` --format JSON --out /var/lib/jenkins/reports/dependency-check-report --prettyPrint'
            }
        }
        
        stage ('Audit.js Analysis') {
            steps {
                sh '/home/chaos/auditjs.sh'
            }
        }
              
        stage ('Snyk Analysis') {
            steps {
                sh '/home/chaos/snyk.sh'
            }
        }
                
    }
}
