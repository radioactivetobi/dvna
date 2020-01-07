
# Static Analysis

## SAST Tools for Node.js Applications

The following are some tools that I found to perform SAST on Nodejs Applications:

* [NSP](https://github.com/nodesecurity/nsp) (This is now replaced with `npm audit` starting npm@6)
* [JSpwn](https://github.com/dvolvox/JSpwn) (JSPrime + ScanJs)
* [JSPrime](https://github.com/dpnishant/jsprime)
* [ScanJS](https://github.com/mozilla/scanjs) (Deprecated)

Resource for combined usage of Dependency Check, Retirejs, Snyk (and NSP): <https://blog.developer.bazaarvoice.com/2018/02/27/getting-started-with-dependency-security-and-nodejs/>

### [SonarQube](https://www.sonarqube.org/)

* Used SonarQube's docker image to run the application with the following command:

```bash
docker run -d -p 9000:9000 -p 9092:9092 --name sonarqube sonarqube
```

* Created a new Access Token for Jenkins in SonarQube under `Account > Security`.
* In Jenkins, under `Credentials >  Add New Credentials` the token is saved as a `Secret Text` type credential.
* The `SonarQube Server` section under `Manage Jenkins > Configure System`, check the `Enable injection of SonarQube server configuration as build environment variables` option.
* Provide the URL for SonarQube Server (in our case, localhost:9000) and add the previously saved SonarQube Credentials.
* Add the following stage in the Jenkinsfile:

```jenkins
stage ('SonarQube Analysis') {
    environment {
                scannerHome = tool 'SonarQube Scanner'
    }

    steps {
        withSonarQubeEnv ('SonarQube') {
            sh '${scannerHome}/bin/sonar-scanner'
            sh 'cat .scannerwork/report-task.txt > /home/chaos/reports/sonarqube-report'
        }
    }
}
```

### [NPM Audit](https://docs.npmjs.com/cli/audit)

NPM Audit comes along with `npm@6` and is not required to be installed seprately. To upgrade npm, if needed, run the following command:

```bash
npm install -g npm@latest
```

* NPM Audit gives a non-zero status code, if it finds any vulnerable dependencies, hence, I ran it through a script to avoid failure of the pipeline. The script is as follows:

```bash
#!/bin/bash

cd /var/lib/jenkins/workspace/node-app-pipeline
npm audit --json > /home/chaos/reports/npm-audit-report

echo $? > /dev/null
```

* Add the following stage in the Jenkinsfile:

```jenkins
stage ('NPM Audit Analysis') {
    steps {
        sh '/home/chaos/npm-audit.sh'
    }
}
```

### [NodeJsScan](https://github.com/ajinabraham/NodeJsScan)

* To install `NodeJsScan`, use the following command:

```bash
pip3 install nodejsscan
```

**Note**: If the package is not getting installed globally, as it will be run by the Jenkins User, run the following command: `sudo -H pip3 install nodejsscan`.

* To analyse the Nodejs project, the following command is used:

```bash
nodejsscan --directory `pwd` --output /home/chaos/reports/nodejsscan-report
```

* Add the following stage in the Jenkinsfile:

```jenkins
stage ('NodeJsScan Analysis') {
    steps {
        sh 'nodejsscan --directory `pwd` --output /home/chaos/reports/nodejsscan-report'
    }
}
```

### [Retire.js](https://retirejs.github.io/retire.js/)

* To install Retire.js use the following command:

```bash
npm install -g retire
```

* To analyse the project with Retire.js run the following command:

```bash
retire --path `pwd` --outputformat json --outputpath /home/chaos/reports/retirejs-report --exitwith 0
```

* Add the following stage in the Jenkinsfile:

```jenkins
stage ('Retire.js Analysis') {
    steps {
        sh 'retire --path `pwd` --outputformat json --outputpath /home/chaos/reports/retirejs-report --exitwith 0'
    }
}
```

### [OWASP Dependency Checker](https://www.owasp.org/index.php/OWASP_Dependency_Check)

* OWASP Dependency Checker comes as an executable for linux. To get the executable, download the [archive](https://dl.bintray.com/jeremy-long/owasp/dependency-check-5.2.4-release.zip).

* Unzip the archive:

```bash
unzip dependency-check-5.2.4-release.zip
```

* To execute the scan, run the following command:

```bash
/dependency-check/bin/dependency-check.sh --scan /var/lib/jenkins/workspace/node-app-pipeline --format JSON --out /home/chaos/reports/dependency-check-report --prettyPrint
```

* Add the following stage in the Jenkinfile:

```jenkins

```

### [auditjs](https://github.com/sonatype-nexus-community/auditjs)

* To install Audit.js, use the following command:

```bash
npm install auditjs -g
```

* To perform a scan, run the following command while inside the project directory:

```bash
auditjs --username ayushpriya10@gmail.com --token 55716e0a92c8c53ae2db6296b62f68860ef5f1af > /home/chaos/reports/auditjs-report 2>&1
```

**Note**: We use `2>&1` to redirct STDERR output to STDOUT otherwise the Vulnerabilities found will not be written to the report but instead will be printed to console.

* Add the following stage to the Jenkinsfile:

```jenkins

```

### [Synk](https://github.com/snyk/snyk#cli)