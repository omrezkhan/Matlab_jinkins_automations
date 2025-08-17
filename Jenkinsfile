pipeline {
    agent any

    environment {
        WORKSPACE_DIR = '/home/omrez/Downloads/MAt_working/Air_spring_jenkins'
        PLOTS_DIR = "${WORKSPACE_DIR}/plots"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo "Checking out the Git repository..."
                checkout scm
            }
        }

        stage('Prepare Workspace') {
            steps {
                echo "Cleaning old CSV and PNG files in plots folder..."
                sh """
                    mkdir -p ${PLOTS_DIR}
                    rm -f ${PLOTS_DIR}/*.csv ${PLOTS_DIR}/*.png ${PLOTS_DIR}/junit_*.xml
                    echo "Workspace ready"
                """
            }
        }

        stage('Run MATLAB Script') {
            steps {
                echo "Running air_spring_script with parameters: M=500, K=20000, C=1500"
                sh """
                    matlab -batch "air_spring_script(500,20000,1500)"
                """
            }
        }

        stage('Convert MATLAB Output to JUnit XML') {
            steps {
                echo "Converting MATLAB results to JUnit XML for pass/fail display..."
                sh """
                    python3 <<EOF
import os
import glob
import xml.etree.ElementTree as ET

plots_dir = '${PLOTS_DIR}'
csv_files = glob.glob(os.path.join(plots_dir, 'air_spring_simulation_data_*.csv'))

# Create JUnit XML
testsuite = ET.Element('testsuite', name='AirSpringSimulation', tests=str(len(csv_files)))
for i, f in enumerate(csv_files):
    testcase = ET.SubElement(testsuite, 'testcase', classname='AirSpringSimulation', name=os.path.basename(f))
    # Here, simple pass/fail: fail if max displacement > threshold (example 0.05 m)
    import pandas as pd
    data = pd.read_csv(f)
    max_disp = data.iloc[:,1].max()   # displacement column
    if max_disp > 0.05:
        failure = ET.SubElement(testcase, 'failure', message='Max displacement exceeded 0.05 m')
        failure.text = f'Max displacement: {max_disp}'
tree = ET.ElementTree(testsuite)
tree.write(os.path.join(plots_dir, 'junit_air_spring_results.xml'))
EOF
                """
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo "Archiving simulation results..."
                archiveArtifacts artifacts: 'plots/*.csv, plots/*.png', allowEmptyArchive: true
            }
        }

        stage('Publish JUnit Results') {
            steps {
                echo "Publishing JUnit pass/fail results..."
                junit 'plots/junit_air_spring_results.xml'
            }
        }
    }

    post {
        always {
            echo "Pipeline completed!"
        }
        success {
            echo "Air spring simulation PASSED"
        }
        failure {
            echo "Air spring simulation FAILED"
        }
    }
}

