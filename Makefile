build-dev:
	docker build -t ghost-dev .
build-prod:
	docker build -t ghost-prod .
dev: build-dev
	docker run -d --name ghost-dev -p 2368:2368 ghost-dev
prod: build-prod
	docker run -d --name ghost-prod -p 2368:2368 ghost-prod
clean-dev:
	docker stop ghost-dev
	docker rm ghost-dev
clean-prod:
	docker sotp ghost-prod
	docker rm ghost-prod
