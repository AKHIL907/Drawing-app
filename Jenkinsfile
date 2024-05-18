pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/AKHIL907/Drawing-app.git'
        DOCKER_IMAGE = 'akhil0531/drawing_pannel'
        REMOTE_HOST = 'ubuntu@3.16.156.19'
        SSH_CREDENTIALS = 'ssh-agent'
        SSH_OPTS = '-o StrictHostKeyChecking=no'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: "${REPO_URL}"]])
            }
        }
        stage('Build') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t drawing_pannel .'
            }
        }
        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-credential', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}'
                    }
                }
            }
        }
        stage('Docker Push') {
            steps {
                sh 'docker tag drawing_pannel ${DOCKER_IMAGE}'
                sh 'docker push ${DOCKER_IMAGE}'
            }
        }
        stage('List Files on Remote') {
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    sh "ssh ${SSH_OPTS} ${REMOTE_HOST} 'ls -la'"
                }
            }
        }
        stage('Pull Docker Image on Remote') {
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    sh "ssh ${SSH_OPTS} ${REMOTE_HOST} 'docker pull ${DOCKER_IMAGE}'"
                }
            }
        }
        stage('Deploy Docker Container on Remote') {
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    sh """
                    ssh ${SSH_OPTS} ${REMOTE_HOST} '
                        docker stop \$(docker ps -q) || true &&
                        docker run -dp 5000:5000 ${DOCKER_IMAGE}
                    '
                    """
                }
            }
        }
    }
}
