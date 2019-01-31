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
                    env.BUILD = 'true'
                }
            }
        }
        stage('Checkout source code') {
            steps {
                cleanWs()
                checkout scm
            }
        }
        stage('Build image') {
            when { expression { return env.BUILD == 'true' }}
            steps {
                retry(3) {
                    sshagent (credentials: ['871f96b5-9d34-449d-b6c3-3a04bbd4c0e4']){
                        nodejs(configId: 'kw-npmrc', nodeJSInstallationName: 'Default Node.js') {
                            sh 'git config --global url."git@github.com:".insteadOf "https://github.com/"'
                            sh 'npm i --quiet --cache=$WORKSPACE/npm-cache'
                            sh """
                            NODE_OPTIONS=--max_old_space_size=4096 npm run services -- build \
                            --destination=$WORKSPACE/$BUILD_VERSION \
                            --buildVersion=$BUILD_VERSION \
                            --npmCache=$WORKSPACE/npm-cache \
                            """
                        }
                    }
                }

                script {
                    docker.withRegistry("https://registry-1.docker.io/v2/", "f16c74f9-0a60-4882-b6fd-bec3b0136b84") {
                        def img = docker.build("labshare/labshare-services:${BUILD_VERSION}", "--build-arg SOURCE_FOLDER=./${BUILD_VERSION} --no-cache ./")
                        img.push("${BUILD_VERSION}")
                        return img.id
                    }
                }

            }
        }
        stage('Deploy docker to kubernetes') {
            steps {
                configFileProvider([
                   # configFile(fileId: 'labshare-services-ci-config', targetLocation: 'config.json'),
                   # configFile(fileId: 'labshare-services-ci-facility', targetLocation: 'facilities.json')
                ]) {
                    withKubeConfig([credentialsId: 'aws-kube-admin',
                            serverUrl: 'https://kubeapi.ci.aws.labshare.org:6443',
                            contextName: 'aws-ci']) {
                    #    sh '''
                    #    kubectl delete configmap labshare-config
                    #    kubectl create configmap labshare-config --from-file=config.json --from-file=facilities.json
                    #   '''
                    }
                }

                withCredentials([string(credentialsId: 'KEYMETRICS_PUBLIC', variable: 'KEYMETRICS_PUBLIC'),
                                string(credentialsId: 'KEYMETRICS_SECRET', variable: 'KEYMETRICS_SECRET')]) {
                    kubernetesDeploy(kubeconfigId: 'aws-ci-kube',
                        configs: 'k8s-deploy.yaml',
                        enableConfigSubstitution: true)
                    }
                }
            }
        }
    }
