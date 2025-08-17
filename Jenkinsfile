pipeline {
    agent { label 'linux-agent' }

    parameters {
        string(name: 'MASS', defaultValue: '500', description: 'Mass (kg)')
        string(name: 'STIFFNESS', defaultValue: '20000', description: 'Spring stiffness (N/m)')
        string(name: 'DAMPING', defaultValue: '1500', description: 'Damping coefficient (Ns/m)')
        string(name: 'MAX_DISPLACEMENT', defaultValue: '0.1', description: 'Maximum allowed displacement (m)')
        string(name: 'MAX_VELOCITY', defaultValue: '1.0', description: 'Maximum allowed velocity (m/s)')
        string(name: 'MAX_ACCELERATION', defaultValue: '5.0', description: 'Maximum allowed acceleration (m/s^2)')
    }

    environment {
        MATLAB_PATH = '/usr/local/MATLAB/R2025a/bin/matlab'
        WORKSPACE_DIR = "${env.WORKSPACE}"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo 'Checking out the Git repository...'
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/master']],
                          userRemoteConfigs: [[url: 'git@github.com:omrezkhan/Matlab_jinkins_automations.git']]])
            }
        }

        stage('Prepare Workspace') {
            steps {
                echo 'Cleaning old files...'
                sh """
                    mkdir -p ${WORKSPACE_DIR}/plots
                    rm -f ${WORKSPACE_DIR}/plots/*
                    echo "Workspace ready at ${WORKSPACE_DIR}/plots"
                """
            }
        }

        stage('Run MATLAB Script') {
            steps {
                echo "Running air_spring_script with parameters..."
                sh """${MATLAB_PATH} -batch "cd('${WORKSPACE_DIR}'); air_spring_script(...
                    ${params.MASS}, ${params.STIFFNESS}, ${params.DAMPING}, '${WORKSPACE_DIR}/plots', ...
                    ${params.MAX_DISPLACEMENT}, ${params.MAX_VELOCITY}, ${params.MAX_ACCELERATION})" """
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo 'Archiving CSV and PNG files...'
                archiveArtifacts artifacts: 'plots/*.csv, plots/*.png', fingerprint: true
            }
        }

        stage('Publish JUnit Results') {
            steps {
                echo 'Publishing MATLAB pass/fail results...'
                junit 'plots/junit_air_spring_*.xml'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed!'
        }
    }
}

