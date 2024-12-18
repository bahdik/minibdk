pipeline {
    agent any
    environment {
        // Define your Docker Hub credentials and image name here
        DOCKER_IMAGE = 'redheaven/hello-world:latest' // Image name
        KUBE_CONTEXT = 'your-kube-context'  // Kube context if you have multiple clusters
        KUBERNETES_NAMESPACE = 'default'  // Replace with your namespace
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout your repository
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'git', url: 'git@github.com:irfanrp/jenkins-integration.git']])
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh '''
                        docker build -t $DOCKER_IMAGE .
                    '''
                }
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhubcredentials', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
        // stage('delete manifest in Kubernetes') {
        //     steps {
        //         script {
        //             // Deploy to Kubernetes using kubectl
        //             sh '''
        //                 kubectl delete -f k8s/deployment.yaml -n $KUBERNETES_NAMESPACE
        //                 sleep 60
        //             '''
        //         }
        //     }
        // }
        stage('Deploy again to Kubernetes') {
            steps {
                script {
                    // Deploy to Kubernetes using kubectl
                    sh '''
                        kubectl apply -f k8s/deployment.yaml -n $KUBERNETES_NAMESPACE
                    '''
                }
            }
        }
        stage('rollout restart  Kubernetes') {
            steps {
                script {
                    // Deploy to Kubernetes using kubectl
                    sh '''
                        kubectl rollout restart deployment/helloworld-app -n $KUBERNETES_NAMESPACE
                    '''
                }
            }
        }
    }
    post {
        always {
            // Clean up if necessary, for example, remove the Docker image locally
            sh 'docker rmi $DOCKER_IMAGE'
        }
    }
}
