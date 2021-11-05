node {

    def buildtag = "nginx-hello-world-${env.BUILD_NUMBER}"

    def branch = "${env.BRANCH_NAME}".replaceAll('/','_')

    currentBuild.displayName = "${buildtag}"

    notifyEvents message: "Building: #${env.BUILD_TAG} - <b>Building</b>", token: env.SLACK_TOKEN
    
    stage "Checkout"
    checkout scm

    stage " Creating docker image"
    sh "echo '[i] building docker image'"
    docker.build "${buildtag}"

    stage "Deploy "
    sh "echo '[i] deploying locally'"
    sh "docker run -d -p 8181:8181 --name nginx-hw-example-${env.BUILD_NUMBER} ${buildtag}"

    stage "notification & wait"
    sh "echo '[i] the deployment has now finished'"
    sh "echo 'Go to this link to see the page/site http://localhost:8181/'"
    sh "echo 'And this will disappear after 120 seconds';sleep 120"

    stage "finish build & clean-up"
//    sh "echo 'lets NOT clean any thing, shall we?'"
    sh "echo '[i] cleaning up all resources'"
    sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
    sh "docker rmi ${buildtag}"
    notifyEvents message: "Build: <a target='_blank' href='${env.BUILD_URL}'>${env.BUILD_TAG}</a> - <b>Finished</b> <br/>${env.JOB_NAME}: #${env.BUILD_NUMBER} - ${currentBuild.result}", token: env.SLACK_TOKEN
    notifyEvents message: "<a target='_blank' href='${env.BUILD_LOG}'>Build log</a>", token: env.SLACK_TOKEN
}

