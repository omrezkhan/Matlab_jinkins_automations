pipeline {
    agent { label 'linux-agent' }

    parameters {
        string(name: 'MASS', defaultValue: '500', description: 'Mass (kg)')
        string(name: 'STIFFNESS', defaultValue: '20000', description: 'Spring stiffness (N/m)')
        string(name: 'DAMPING', defaultValue: '1500', description: 'Damping coefficient (Ns/m)')
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
                    set -e
                    mkdir -p ${WORKSPACE_DIR}/plots
                    rm -f ${WORKSPACE_DIR}/plots/*
                    echo "Workspace ready at ${WORKSPACE_DIR}/plots"
                """
            }
        }

        stage('Run MATLAB Script') {
            steps {
                echo "Running air_spring_script with parameters: M=${params.MASS}, K=${params.STIFFNESS}, C=${params.DAMPING}"
                echo "MATLAB command: ${MATLAB_PATH} -batch \"cd('${WORKSPACE_DIR}'); air_spring_script(${params.MASS}, ${params.STIFFNESS}, ${params.DAMPING}, '${WORKSPACE_DIR}/plots')\""
                sh """
                    set -e
                    ${MATLAB_PATH} -batch "cd('${WORKSPACE_DIR}'); air_spring_script(${params.MASS}, ${params.STIFFNESS}, ${params.DAMPING}, '${WORKSPACE_DIR}/plots')"
                """
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

