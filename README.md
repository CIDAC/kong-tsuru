# kong-tsuru
This project assemble instructions to deploy Kong gateway in Tsuru Paas

## 1. Scenario

We are using [Tsuru](https://tsuru.io/) as our Platform as a Service software (Paas), and we decided to deploy [Kong](https://getkong.org/) in Tsuru in order to manage APIs and Microservices.

> Notes:
> * We are using **Tsuru 1.5.1** and **Kong 0.14.0**

## 2. Problem

* As shown [here](https://getkong.org/install/docker/?_ga=2.249750145.664958612.1528111222-351095331.1528111222) (at step 4) and [here](https://github.com/Kong/docker-kong/blob/6e2035c5739482f0616021a7eda04ec6809d9f3e/alpine/Dockerfile) (at line 22), Kong exposes 4 ports;

* Tsuru supports only one port per container.

So, in this scenario we have a conflict. Kong needs 4 ports to work properly and Tsuru only accepts one port.

To prove that, if you execute `tsuru app-deploy -i kong -a kong-helloworld` you will get this error:

```bash
Deploying image... ok
---- Getting process from image ----
---- Inspecting image "kong:latest" ----
---- ERROR during deploy: ----
Too many ports. You should especify which one you want to.
```

## 3. Solution

We've create a Dockerfile based on [Kong oficial image](https://github.com/Kong/docker-kong/blob/6e2035c5739482f0616021a7eda04ec6809d9f3e/alpine/Dockerfile) that exposes only one port.

So, to get it done, clone this project, open your terminal and execute this command:

```bash
chmod +x docker-entrypoint.sh
```

Then, execute this command to build your image:

```bash
docker build -t YOUR_CUSTOM_KONG_IMAGE_NAME .
```

Now you are able to push this image to [Docker Hub](https://hub.docker.com/) or a registry of your choice. To push the image created to [Docker Hub](https://hub.docker.com/) execute this command:

```bash
docker push YOUR_CUSTOM_KONG_IMAGE_NAME
```

Then you can deploy kong in Tsuru running this command:

```bash
tsuru app-deploy -i YOUR_CUSTOM_KONG_IMAGE_NAME -a kong-helloworld
```

Last but not least, you can register and create a route to Kong admin API in Tsuru, running these commands:

* Access the kong's shell.

```bash
tsuru app-shell -a kong-helloworld
```

* Registry Kong admin API

```bash
curl -X POST http://localhost:8001/services \
  --data name=admin-api \
  --data host=localhost \
  --data port=8001
```

* Creates a route to access Kong admin API.

```bash
curl -X POST http://localhost:8001/services/admin-api/routes \
  --data paths[]=/admin-api
```

> Note:
> * For further information about registering APIs take a look [here](https://getkong.org/docs/0.14.x/secure-admin-api/#kong-api-loopback) and [here](https://getkong.org/about/faq/#kong-server).

## 4. Automatization

To see the deploy automated take a look at the gitlab-ci.yaml in this project.

## Oh, Thanks!

By the way... thanks to [@jhonyscamacho](https://github.com/orgs/CIDAC/people/jhonyscamacho), [@matheuscruzsouza](https://github.com/orgs/CIDAC/people/matheuscruzsouza), [@wallacegsouza](https://github.com/orgs/CIDAC/people/wallacegsouza), [@ronanrf](https://github.com/orgs/CIDAC/people/ronanrf) and [@patrezze](https://github.com/patrezze).