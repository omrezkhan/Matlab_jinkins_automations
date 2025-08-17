pipeline {
    agent any

    environment {
        MATLAB_PATH = "/usr/local/MATLAB/R2025a/bin/matlab"
        SCRIPT_PATH = "/home/omrez/Downloads/MAt_working/Air_spring_jenkins"
        PLOTS_FOLDER = "${SCRIPT_PATH}/plots"
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
                // Keep only the latest result by removing all existing files
                sh """
                    mkdir -p ${PLOTS_FOLDER}
                    rm -f ${PLOTS_FOLDER}/*.csv
                    rm -f ${PLOTS_FOLDER}/*.png
                """
            }
        }

        stage('Run MATLAB Script') {
            steps {
                script {
                    def timestamp = new Date().format("yyyy_MM_dd_HH_mm_ss")
                    def csvFile = "${PLOTS_FOLDER}/air_spring_simulation_data_${timestamp}.csv"
                    def pngFile = "${PLOTS_FOLDER}/air_spring_simulation_plot_${timestamp}.png"

                    echo "Running air_spring_script with parameters: M=500, K=20000, C=1500"
                    
                    sh """
                        ${MATLAB_PATH} -batch "cd('${SCRIPT_PATH}'); air_spring_script(500, 20000, 1500)"
                    """

                    // Move MATLAB output to timestamped files
                    sh """
                        mv ${PLOTS_FOLDER}/air_spring_simulation_data.csv ${csvFile} || true
                        mv ${PLOTS_FOLDER}/air_spring_simulation_plot.png ${pngFile} || true
                    """

                    env.LATEST_CSV = csvFile
                    env.LATEST_PNG = pngFile
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo "Archiving latest simulation results..."
                archiveArtifacts artifacts: "${env.LATEST_CSV}, ${env.LATEST_PNG}", allowEmptyArchive: false
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}

