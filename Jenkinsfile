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
            sh "docker ps | grep 'nginx-hw-example-${env.BUILD_NUMBER}'"
            echo "Availability GOOD"
            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Testing</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Container</b> EXISTS, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
            // return true
        } catch (Exception e) {
            echo "Availability BAD"
            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Testing</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Container</b> DOES NOT EXISTS <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
            return false
        }
   
    stage "Push image"
    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials'){
            app.push("${env.BUILD_NUMBER}")            
            app.push("latest")   
    }
    
    stage "finish build & clean-up"
//        sh "echo 'lets NOT clean any thing, shall we?'"
        sh "echo '[i] cleaning up all resources'"
        sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
        sh "docker rmi ${buildtag}"
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Finished</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Status</b> ${currentBuild.currentResult}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <a target='_blank' href='${env.BUILD_LOG}'>Build log</a>", token: env.SLACK_TOKEN
}
