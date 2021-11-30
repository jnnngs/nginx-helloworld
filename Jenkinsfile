node {

    def success = false
    def deployed = false
    def app
    def image = 'registry.hub.docker.com/jnnngs/nginx-helloworld'
    def buildtag = "nginx-hello-world-${env.BUILD_NUMBER}"
    def branch = "${env.BRANCH_NAME}".replaceAll('/','_')
    
    currentBuild.displayName = "${buildtag}"
    
    notifyEvents message: "## Starting ${env.JOB_NAME}, Build #${env.BUILD_NUMBER} ##", token: env.SLACK_TOKEN

    stage "Checkout" 
        checkout scm
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Checkout</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN

    stage "Creating docker image"
        sh "echo '[i] building docker image'"
        docker.build "${buildtag}"
        app = docker.build image
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Building</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN

    stage "Deploy "
        sh "echo '[i] deploying locally'"
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Deploying</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
        sh "docker run -d -p 8181:8181 --name nginx-hw-example-${env.BUILD_NUMBER} ${buildtag}"

    stage "Check Docker Availability"
        try {         
            sh "docker ps | grep 'nginx-hw-example-${env.BUILD_NUMBER}'"
            echo "Docker Availability GOOD"
            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Testing</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
            deployed = true
            success = true
        } catch (Exception e) {
            echo "Docker Availability BAD"
            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>FAILED</b>: Docker Availability BAD <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
            success = false
        }

    if ( success ) {        
        stage "Push image to DockerHub"
        try { 
                docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials')
            {
                    app.push("latest")  
                }
            echo "Push Success: TAG latest"
            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Pushing</b>:: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
            success = true
        } catch (Exception e) {
                echo "Push failed"
                notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Dockerhub push</b>: ${env.JOB_NAME}, ${env.BUILD_TAG}, <b>DockerHub</b> #${env.BUILD_NUMBER}, <b>PUSH FAILED</b>, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
                sh "echo '[i] cleaning up all resources'"
                sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
                sh "docker rmi ${buildtag}"
                notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>FAILED</b>: Dockerhub PUSH BAD <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
                success = false
            }	
    }	

     if ( deployed ) {     
        stage "finish build & clean-up"
        sh "echo '[i] cleaning up all resources'"
        sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
        sh "docker rmi ${buildtag}"
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Cleaning up</b>:: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
        deployed = false
     }

     stage "Check if finished successfully"
     if ( success ) { 
         notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Finished</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Status</b> ${currentBuild.currentResult}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN  
         notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <a target='_blank' href='${env.BUILD_LOG}'>Build log</a>", token: env.SLACK_TOKEN
         notifyEvents message: "## Finished ${env.JOB_NAME}, Build #${env.BUILD_NUMBER} ##", token: env.SLACK_TOKEN
         return true
     } else {
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Finished</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Status</b> ${currentBuild.currentResult}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN  
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <a target='_blank' href='${env.BUILD_LOG}'>Build log</a>", token: env.SLACK_TOKEN
        notifyEvents message: "## !! Failed ${env.JOB_NAME}, Build #${env.BUILD_NUMBER} !! ##", token: env.SLACK_TOKEN
        return false
     }
     
}
