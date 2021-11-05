node {

    def buildtag = "nginx-hello-world-${env.BUILD_NUMBER}"

    def branch = "${env.BRANCH_NAME}".replaceAll('/','_')

    currentBuild.displayName = "${buildtag}"

    notifyEvents message: "${new Date().format('dd/MMM/yyyy')} <b>Building</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
    
    stage "Checkout"
        checkout scm

    stage " Creating docker image"
        sh "echo '[i] building docker image'"
        docker.build "${buildtag}"

    stage "Deploy "
        sh "echo '[i] deploying locally'"
        notifyEvents message: "${new Date().format('dd/MMM/yyyy')} - <b>Deploying</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
        sh "docker run -d -p 8181:8181 --name nginx-hw-example-${env.BUILD_NUMBER} ${buildtag}"

    stage "notification & wait"
        sh "echo '[i] the deployment has now finished'"
        sh "echo 'Go to this link to see the page/site http://localhost:8181/'"
        notifyEvents message: "${new Date().format('dd/MMM/yyyy')} - <b>Sleeping</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
        sh "echo 'And this will disappear after 120 seconds';sleep 120"

    stage "finish build & clean-up"
//        sh "echo 'lets NOT clean any thing, shall we?'"
        sh "echo '[i] cleaning up all resources'"
        sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
        sh "docker rmi ${buildtag}"
        notifyEvents message: "${new Date().format('dd/MMM/yyyy')} - <b>Finished</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Status</b> ${currentBuild.currentResult}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
        notifyEvents message: "${env.TAG_TIMESTAMP} - <a target='_blank' href='${env.BUILD_LOG}'>Build log</a>", token: env.SLACK_TOKEN
}

