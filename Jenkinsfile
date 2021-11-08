node {

    def buildtag = "nginx-hello-world-${env.BUILD_NUMBER}"

    def branch = "${env.BRANCH_NAME}".replaceAll('/','_')

    currentBuild.displayName = "${buildtag}"

    notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Building</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
    
    stage "Checkout"
        checkout scm

    stage " Creating docker image"
        sh "echo '[i] building docker image'"
        docker.build "${buildtag}"

    stage "Deploy "
        sh "echo '[i] deploying locally'"
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Deploying</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
        sh "docker run -d -p 8181:8181 --name nginx-hw-example-${env.BUILD_NUMBER} ${buildtag}"

    stage "Check Availability"
        try {         
            sh "curl -s --head --request GET  localhost:8182 | grep '200'"
            echo "Availability GOOD"
            return true
        } catch (Exception e) {
            echo "Availability BAD"
            return false
        }
   
//    stage "notification & wait"
//       sh "echo '[i] the deployment has now finished'"
//        sh "echo 'Go to this link to see the page/site http://localhost:8181/'"
//        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Sleeping</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
//        sh "echo 'And this will disappear after 120 seconds';sleep 120"

//    stage "check if docker container exists"
//        try {         
//            new URL("http://localhost:8181").getText()
//            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Testing</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Container</b> EXISTS, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
//            return true
//        } catch (Exception e) {
//            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Testing</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Container</b> DOES NOT EXISTS <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
//            return false
//        }
    
    stage "finish build & clean-up"
//        sh "echo 'lets NOT clean any thing, shall we?'"
        sh "echo '[i] cleaning up all resources'"
        sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
        sh "docker rmi ${buildtag}"
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Finished</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Status</b> ${currentBuild.currentResult}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <a target='_blank' href='${env.BUILD_LOG}'>Build log</a>", token: env.SLACK_TOKEN
}

