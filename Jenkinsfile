pipeline {
    agent any

    environment {
        PLOTS_FOLDER = "${WORKSPACE}/plots"
        M = 500
        K = 20000
        C = 1500
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo "Checking out Git repository..."
                checkout scm
            }
        }

        stage('Prepare Workspace') {
            steps {
                echo "Cleaning old CSV and PNG files in plots folder..."
                sh """
                    mkdir -p ${PLOTS_FOLDER}
                    rm -f ${PLOTS_FOLDER}/*.csv
                    rm -f ${PLOTS_FOLDER}/*.png
                """
            }
        }

        stage('Run MATLAB Script') {
            steps {
                echo "Running air_spring_script with parameters: M=${M}, K=${K}, C=${C}"
                sh """
                    /usr/local/MATLAB/R2025a/bin/matlab -batch "
                        cd('${WORKSPACE}');
                        air_spring_script(${M}, ${K}, ${C});
                    "
                """
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo "Archiving simulation results..."
                archiveArtifacts artifacts: 'plots/*.csv, plots/*.png', allowEmptyArchive: false
            }
        }
    }

    post {
        success {
            echo "Air spring simulation completed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}

