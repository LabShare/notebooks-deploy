pipeline {
    agent {
        node { label 'linux && build && aws'}
    }
    parameters {
        string(name: 'BUILD_VERSION', defaultValue: '', description: '')
    }
    environment {
        PROJECT_NAME = "labshare-compute"
        DOCKER_REPO_NAME = "labshare/labshare-compute"
    }
    triggers {
        pollSCM('H/5 * * * *')
    }
    stages {
        stage('Build Version'){
            when { expression { BUILD_VERSION == '' } }
            steps{
                script {
                    def packageJSON = readJSON file: 'package.json'
                    def packageJSONVersion = packageJSON.version

                    currentBuild.displayName = packageJSONVersion
                    env.BUILD_VERSION = packageJSONVersion
               }
            }
        }
        stage('Checkout source code') {
            steps {
                cleanWs()
                checkout scm
            }
        }
        stage('Deploy docker to kubernetes') {
            steps {
                    kubernetesDeploy(kubeconfigId: 'aws-ci-kube',
                        configs: 'jupyterhub-deployment.yaml',
                        enableConfigSubstitution: true)
                }
            }
        }
    }
