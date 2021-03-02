# omnileads-digitalocean
Deploy your own Contact Center as a Service business on Digitalocean with OMniLeads & Terraform

<p>OMniLeads (OML) is an Open Source software solution based on WebRTC technology(https://webrtc.org/) designed to support the management, operation and administration of a Contact Center using multiple comunication channels. At present it allows the management and phone attention deployment using: Inbound Campaigns, Preview Campaigns and Manual Outbound Campaigns natively. Also it have with the option to administrate Predictive/Progressive Dialer Campaigns using integrations APIs.</p>

<p>In this repository you will find the terraform code necessary to deploy OMniLeads on digitalocean in an automated way and isolating the main components of the App in such a way that the security of business data and the ease of scaling any component prevail.</p>


## Components distribution 🔧

There are three ways to deploy the app and its components

* **AIO - All in One**: on this scenario all the components are deployed on same Droplet.

![All In One](./docs/AIO.png)

* **Cluster**: on this scenario we split the components PSQL, Redis and RTPEngine on isolates Droplets, while the rest of the components (Nginx, Kamailio, Asterisk, Django-uwsgi, Wombat-dialer and MySQL) share the restate droplet.

![Cluster](./docs/cluster.png)

* **Cluster with dialer**: on this scenario we split the components PSQL, Redis, RTPEngine, Wombat-dialer and MySQL on isolates Droplets, while the rest of the components (Nginx, Kamailio, Asterisk y Django-uwsgi) share the restate droplet.

![Cluster with Dialer](./docs/cluster_dialer.png)

All three scenarios share the fact:

* Each instance is generated with its corresponding firewall.
* A load balancer is implemented with SSL certificates (Let's & crypt). This LB attend the HTTPS request and re-send to OMniLeds Nginx web server.
* Call recordings files are stored on Spaces Bucket in order to grown without limit :)


## Prerequisites 📋

The following steps are required before proceeding to the next steps.

* An SSH-key available in our Digital Ocean account. Particularly from here we are going to consider the fingerprint field.

![SSH key fingerprint](./docs/ssh-key-fingerprint.png)

* A Personal Access [Token](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/). Personal access tokens function like ordinary OAuth access tokens. You can use them to authenticate to the API.

* Create a [Space](https://www.digitalocean.com/community/tutorials/how-to-create-a-digitalocean-space-and-api-key) to store call recordings and the tfstate terraform files. The bucket NAME should be considered like environment variable.

* A domain name that you own or control [to point to Digital Ocean Nameservers](https://www.digitalocean.com/community/tutorials/how-to-point-to-digitalocean-nameservers-from-common-domain-registrars), From Common Domain Registrars.

You have to generate the following environment variables:

```
export DIGITALOCEAN_TOKEN=ede1dc8dbd503dwghkds2323298fe8b02ffasfsa161ddsada
export TF_VAR_ssh_key_fingerprint=50:2a:6d:54:54:1e:w0:a3:70:13:c3:8
export TF_VAR_spaces_key=ADSLKDSLALI4WGFIKN2XJKHDKJLSPF52QA
export TF_VAR_spaces_secret_key=SSAYskskad2CXtszQzdsafsfsaftoymzM3rDuAdCCfTj
export TF_VAR_spaces_bucket_name=omnileads
export TF_VAR_domain_name=your_domain.com
```

## Deploy 🚀

Para llevar a cabo el deploy vamos a usar la utilidad *make* :

* make init: para levantar un nuevo entorno con sus variables y módulos.

```
make init ENV=$customer-name TYPE=$deploy-type
```

* make plan: para sacar un listado de todo lo que se va a generar/modificar una vez que se aplique el make apply.

```
make plan ENV=$customer-name
```

* make apply: para impactar los cambios de la infraestructura en la nube.

```
make apply ENV=$customer-name
```

* make destroy: para eliminar toda la infraestructura de un cliente.

```
make destroy ENV=$customer-name
```

* make delete: para eliminar el directorio de cliente generado con el make init.

```
make deletes ENV=$customer-name
```


On the one hand we have general variables, then variables linked to the sizing and names of the components and finally variables linked to application parameters.
The vars.tfvars file have all parameters with their description.




## License
GPLv3. Every source code file contains the license preamble and copyright details.
