node {

    def buildtag = "nginx-hello-world-${env.BUILD_NUMBER}"

    def branch = "${env.BRANCH_NAME}".replaceAll('/','_')

    currentBuild.displayName = "${buildtag}"

    stage "Checkout"
    checkout scm

    stage " Creating docker image"
    sh "echo '[i] building docker image'"
    docker.build "${buildtag}"

    stage "deploy to selected environment(local for demo) "
    sh "echo '[i] deploying locally'"
    sh "docker run -d -p 8181:8181 --name nginx-hw-example-${env.BUILD_NUMBER} ${buildtag}"

    stage "notification & wait(demo)"
    sh "echo '[i] the deployment has now finished'"
    sh "echo 'Go to this link to see the page/site http://localhost:8181/'"
//    sh "echo 'And this will disappear after 600 seconds';sleep 600"

    stage "finish build"
    sh "echo 'lets NOT clean any thing, shall we?'"
    // sh "echo '[i] cleaning up all resources'"
    // sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
    // sh "docker rmi ${buildtag}"
}

