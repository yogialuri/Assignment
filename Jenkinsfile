node {

appName = "tomcat"
tag = "9.0"
registryHost = "yogi02"
imageName = "${registryHost}/${appName}:${tag}"

stage "Checkout"

checkout scm

stage "Docker Build"
    
sh "docker build -t ${imageName} -f docker/Dockerfile"
    
stage "Docker Push"

sh "docker push ${imageName}"

stage "Deploy in Kubernetes"

sh "kubectl run tomcat-app --image=${imageName} --port=8080"

stage " Create Config map and Secrets "

sh """ kubectl create secret generic test-user --from-literal=TEST_USER=tomcat
       kubectl describe secrets test-user
	   kubectl create configmap test-config  --from-literal=TESTCONFIG=tomcat
	   kubectl describe configmaps test-config
	"""



}
