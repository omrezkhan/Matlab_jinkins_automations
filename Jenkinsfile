pipeline {
    agent { label 'linux-agent' }

    parameters {
        string(name: 'MASS', defaultValue: '500', description: 'Mass (kg)')
        string(name: 'STIFFNESS', defaultValue: '20000', description: 'Spring stiffness (N/m)')
        string(name: 'DAMPING', defaultValue: '1500', description: 'Damping coefficient (Ns/m)')
    }

    environment {
        MATLAB_PATH = '/usr/local/MATLAB/R2025a/bin/matlab'
        WORKSPACE_DIR = '/home/omrez/Downloads/MAt_working/Air_spring_jenkins'
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
                echo 'Cleaning old CSV and PNG files in plots folder...'
                sh """
                    echo "Workspace DIR: ${WORKSPACE_DIR}/plots"
                    mkdir -p ${WORKSPACE_DIR}/plots
                    echo "Before cleanup:"
                    ls -l ${WORKSPACE_DIR}/plots
                    rm -f ${WORKSPACE_DIR}/plots/*.csv
                    rm -f ${WORKSPACE_DIR}/plots/*.png
                    echo "After cleanup:"
                    ls -l ${WORKSPACE_DIR}/plots
                """
            }
        }

        stage('Run MATLAB Script') {
            steps {
                echo "Running air_spring_script with parameters: M=${params.MASS}, K=${params.STIFFNESS}, C=${params.DAMPING}"
                sh """${MATLAB_PATH} -batch "cd('${WORKSPACE_DIR}'); air_spring_script(${params.MASS}, ${params.STIFFNESS}, ${params.DAMPING})" """
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo 'Archiving simulation results...'
                archiveArtifacts artifacts: 'plots/*.csv, plots/*.png', fingerprint: true
            }
        }

        stage('Post-processing') {
            steps {
                echo 'Post-processing stage (if needed)'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}

