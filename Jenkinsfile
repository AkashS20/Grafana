pipeline {
    agent any
    stages {
        stage('Pre-check Docker') {
            steps {
                script {
                    try {
                        // Check if Docker is installed
                        def dockerVersion = sh(script: 'docker --version', returnStdout: true).trim()
                        if (!dockerVersion) {
                            error "Docker is not installed or not in the PATH. Please install Docker."
                        }

                        // Check if Docker daemon is running
                        def dockerInfo = sh(script: 'docker info', returnStatus: true)
                        if (dockerInfo != 0) {
                            error "Docker daemon is not running. Please start the Docker service."
                        }

                        echo "Docker is available and running: ${dockerVersion}"
                    } catch (Exception e) {
                        error "Pre-check failed: ${e.message}"
                    }
                }
            }
        }
        stage('Checkout Repository') {
            steps {
                // Jenkins will automatically clone the repository with the Git SCM plugin
                // The repository is available under the $WORKSPACE directory
                echo "Repository checked out to: ${env.WORKSPACE}"
            }
        }
        stage('Build Docker Image') {
            steps {
                // Assuming you have a Dockerfile in your repository
                sh 'docker build -t delivery_metrics .'
            }
        }
        stage('Run Application') {
            steps {
                // Run your application in a Docker container
                sh '''
                    # Stop and remove existing container if it exists
                    docker rm -f delivery_metrics || true
                    
                    # Run new container
                    docker run -d -p 8005:8005 --name delivery_metrics delivery_metrics
                '''
            }
        }
        stage('Run Prometheus & Grafana') {
            steps {
                // Run Prometheus with the configuration files from the repository
                sh '''
                docker run -d --name prometheus -p 9095:9095 \
                  -v $WORKSPACE/prometheus.yml:/etc/prometheus/prometheus.yml \
                  -v $WORKSPACE/alert_rules.yml:/etc/prometheus/alert_rules.yml \
                  prom/prometheus
                docker run -d --name grafana -p 3005:3005 grafana/grafana
                '''
            }
        }
    }
}

