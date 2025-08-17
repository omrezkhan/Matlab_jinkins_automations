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
        OUTPUT_ROOT = "${WORKSPACE}/plots" // Root folder for artifacts
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

        stage('Run MATLAB Script') {
            steps {
                script {
                    // Create timestamped folder for this run
                    def timestamp = new Date().format("yyyy_MM_dd_HH_mm_ss")
                    def runOutputDir = "${OUTPUT_ROOT}/${timestamp}"
                    sh "mkdir -p ${runOutputDir}"

                    echo "Running air_spring_script with parameters: M=${params.MASS}, K=${params.STIFFNESS}, C=${params.DAMPING}"
                    sh """${MATLAB_PATH} -batch "cd('${WORKSPACE_DIR}'); air_spring_script(${params.MASS}, ${params.STIFFNESS}, ${params.DAMPING}, '${runOutputDir}')" """
                    
                    // Set environment variable for later stages
                    env.RUN_OUTPUT_DIR = runOutputDir
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo 'Archiving simulation results...'
                archiveArtifacts artifacts: "${env.RUN_OUTPUT_DIR}/*.csv, ${env.RUN_OUTPUT_DIR}/*.png", fingerprint: true
            }
        }

        stage('Publish Test Results') {
            steps {
                echo 'Publishing JUnit test results...'
                junit "${env.RUN_OUTPUT_DIR}/test_results_*.xml"
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

