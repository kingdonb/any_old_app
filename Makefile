.PHONY: jsonnet

jsonnet: output/production.yaml

output/production.yaml: manifests/example.jsonnet
	kubecfg show -V VERSION=staging manifests/example.jsonnet > output/production.yaml

clean:
	rm output/production.yaml
