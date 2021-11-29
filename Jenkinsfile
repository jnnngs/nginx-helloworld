node {
    
    def app
    def image = 'registry.hub.docker.com/jnnngs/nginx-helloworld'
    def buildtag = "nginx-hello-world-${env.BUILD_NUMBER}"

    def branch = "${env.BRANCH_NAME}".replaceAll('/','_')

    currentBuild.displayName = "${buildtag}"

    notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Building</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
    
    stage "Checkout"
        checkout scm

    stage " Creating docker image"
        sh "echo '[i] building docker image'"
        docker.build "${buildtag}"
        app = docker.build image

    stage "Deploy "
        sh "echo '[i] deploying locally'"
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Deploying</b>: ${env.JOB_NAME}, <b>Build</b> #${env.BUILD_NUMBER}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
        sh "docker run -d -p 8181:8181 --name nginx-hw-example-${env.BUILD_NUMBER} ${buildtag}"

    stage "Check Docker Availability"
        try {         
            sh "docker ps | grep 'nginx-hw-example-${env.BUILD_NUMBER}'"
            echo "Docker Availability GOOD"
            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Testing</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Test</b> #${env.BUILD_NUMBER}, <b>Container</b> EXISTS, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
            // return true
        } catch (Exception e) {
            echo "Docker Availability BAD"
            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Testing</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Test</b> #${env.BUILD_NUMBER}, <b>Container</b> DOES NOT EXISTS <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
            return false
        }
	
    stage('Check Web Availability') 
        timeout(time: 15, unit: 'SECONDS') {
          waitUntil {
            try { 
                app.inside{
                    sh "curl -s --head  --request GET localhost:8181 | grep '200'"
                    echo "Web Availability GOOD"
                }
                    notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Testing</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Test</b> #${env.BUILD_NUMBER}, <b>Web</b> EXISTS, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
                } catch (Exception e) {
                echo "Web Availability BAD"
                    notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Testing</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Test</b> #${env.BUILD_NUMBER}, <b>Web</b> DOES NOT EXISTS <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
                    sh "echo '[i] cleaning up all resources'"
                    sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
                    sh "docker rmi ${buildtag}"
                return false
                }
            
            }
        }
    stage "Push image to DockerHub"
	try { 
    	    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials')
		{
                app.push("latest")  
	        }
	    echo "Push Success: TAG latest"
	    notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Dockerhub push</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>DockerHub</b> #${env.BUILD_NUMBER}, <b>PUSH SUCCESS</b>, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
	} catch (Exception e) {
            echo "Push failed"
            notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Dockerhub push</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>DockerHub</b> #${env.BUILD_NUMBER}, <b>PUSH FAILED</b>, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN 
            sh "echo '[i] cleaning up all resources'"
            sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
            sh "docker rmi ${buildtag}"
	    return false
        }		
    
    stage "finish build & clean-up"
        sh "echo '[i] cleaning up all resources'"
        sh "docker rm -f nginx-hw-example-${env.BUILD_NUMBER}"
        sh "docker rmi ${buildtag}"
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <b>Finished</b>: <a target='_blank' href='${env.JOB_NAME}'>${env.BUILD_TAG}</a>, <b>Build</b> #${env.BUILD_NUMBER}, <b>Status</b> ${currentBuild.currentResult}, <b>Duration</b> ${currentBuild.durationString.minus(' and counting')}", token: env.SLACK_TOKEN
        notifyEvents message: "${new Date().format('dd MMM yyyy HH:mm:ss')} - <a target='_blank' href='${env.BUILD_LOG}'>Build log</a>", token: env.SLACK_TOKEN
}
