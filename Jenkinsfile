pipeline {
    agent {
        node { label 'linux && build && aws' }
    }
    parameters {
        booleanParam(name: 'SKIP_BUILD', defaultValue: false, description: 'Skips Docker builds')
    }
    environment {
        PROJECT_NAME = "labshare-compute"
        DOCKER_REPO_NAME = "labshare/labshare-compute"
        CONFIG_HASH = """${sh (
            script: "shasum deploy/kubernetes/jupyterhub-configs.yaml | cut -d ' ' -f 1 | tr -d '\n'",
            returnStdout: true
        )}"""
        BUILD_HUB = """${sh (
            script: "git diff --name-only ${GIT_PREVIOUS_SUCCESSFUL_COMMIT} ${GIT_COMMIT} | grep 'jupyterhub/VERSION'",
            returnStatus: true
        )}"""
        BUILD_NOTEBOOK = """${sh (
            script: "git diff --name-only ${GIT_PREVIOUS_SUCCESSFUL_COMMIT} ${GIT_COMMIT} | grep 'notebook/VERSION'",
            returnStatus: true
        )}"""
        HUB_VERSION = readFile(file: 'deploy/docker/jupyterhub/VERSION')
        NOTEBOOK_VERSION = readFile(file: 'deploy/docker/notebook/VERSION')
        STORAGE_PER_USER = "100Mi"
        STORAGE_SHARED = "80Gi"
    }
    triggers {
        pollSCM('H/5 * * * *')
    }
    stages {
        stage('Build Version'){
            steps{
                script {
                    BUILD_VERSION_GENERATED = VersionNumber(
                        versionNumberString: 'v${BUILD_YEAR, XX}.${BUILD_MONTH, XX}${BUILD_DAY, XX}.${BUILDS_TODAY}',
                        projectStartDate:    '1970-01-01',
                        skipFailedBuilds:    true)
                    currentBuild.displayName = BUILD_VERSION_GENERATED
                    env.BUILD_VERSION = BUILD_VERSION_GENERATED
               }
            }
        }
        stage('Checkout source code') {
            steps {
                cleanWs()
                checkout scm
            }
        }
        stage('Build JupyterHub Docker') {
            when {
                environment name: 'SKIP_BUILD', value: 'false'
                environment name: 'BUILD_HUB', value: '0'
            }
            steps {
                script {
                    dir('deploy/docker/jupyterhub') {
                        docker.withRegistry('https://registry-1.docker.io/v2/', 'f16c74f9-0a60-4882-b6fd-bec3b0136b84') {
                            def image = docker.build('labshare/jupyterhub:latest', '--no-cache ./')
                            image.push()
                            image.push(env.HUB_VERSION)
                        }
                    }
                }
            }
        }
        stage('Build Jupyter Notebook Docker') {
            when {
                environment name: 'SKIP_BUILD', value: 'false'
                environment name: 'BUILD_NOTEBOOK', value: '0'
            }
            steps {
                script {
                    dir('deploy/docker/notebook') {
                        docker.withRegistry('https://registry-1.docker.io/v2/', 'f16c74f9-0a60-4882-b6fd-bec3b0136b84') {
                            def image = docker.build('labshare/polyglot-notebook:latest', '--no-cache ./')
                            image.push()
                            image.push(env.NOTEBOOK_VERSION)
                        }
                    }
                }
            }
        }
        stage('Deploy JupyterHub to Kubernetes') {
            steps {
		withAWS(credentials:'aws-jenkins-eks') {
		    sh "sed -i 's/NOTEBOOK_VERSION_VALUE/${NOTEBOOK_VERSION}/g' ./deploy/kubernetes/jupyterhub-configs.yaml"
            sh "sed -i 's/STORAGE_PER_USER_VALUE/${STORAGE_PER_USER}/g' ./deploy/kubernetes/jupyterhub-configs.yaml"
            sh "sed -i 's/STORAGE_SHARED_VALUE/${STORAGE_SHARED}/g' ./deploy/kubernetes/jupyterhub-volumes.yaml"
		    sh "sed -i 's/HUB_VERSION_VALUE/${HUB_VERSION}/g' ./deploy/kubernetes/jupyterhub-deployment.yaml"
		    sh "sed -i 's/CONFIG_HASH_VALUE/${CONFIG_HASH}/g' ./deploy/kubernetes/jupyterhub-deployment.yaml"
		    sh '''
    			kubectl apply -f ./deploy/kubernetes/jupyterhub-configs.yaml
    			kubectl apply -f ./deploy/kubernetes/jupyterhub-deployment.yaml
    			kubectl apply -f ./deploy/kubernetes/storage.yaml
		    '''
		}
            }
        }
    }
}
