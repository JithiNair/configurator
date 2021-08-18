

clean: clean-configurator
build: build-configurator
deploy: deploy-configurator
remove: remove-configurator

clean-configurator: 
	-rm -f configurator
	-docker rmi ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG}

deploy-configurator:
	-kubectl create ns configurator		
	-kubectl apply -f deploy/configurator-serviceaccount.yaml
	-kubectl apply -f deploy/configurator-clusterrole.yaml
	-kubectl apply -f deploy/configurator-clusterrolebinding.yaml
	-kubectl apply -f deploy/crd-customConfigMap.yaml
	-kubectl apply -f deploy/crd-customSecret.yaml
	-kubectl apply -f deploy/configurator-deployment.yaml

remove-configurator:
	-kubectl delete -f deploy/configurator-deployment.yaml
	-kubectl delete -f deploy/crd-customConfigMap.yaml
	-kubectl delete -f deploy/crd-customSecret.yaml
	-kubectl delete -f deploy/configurator-clusterrolebinding.yaml
	-kubectl delete -f deploy/configurator-clusterrole.yaml
	-kubectl delete -f deploy/configurator-serviceaccount.yaml
	-kubectl delete ns configurator

build-configurator:
	-go mod vendor
	-go build -o configurator .
	-docker build . -t ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG}
	-docker push ${DOCKER_IMAGE_REPO}:${DOCKER_IMAGE_TAG}
