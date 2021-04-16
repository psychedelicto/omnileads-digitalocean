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

To spin up the deploy we are going to use the  *make* utility:

* **make init**: The first step is to generate all the customer folder and build config files.

```
make init ENV=$customer-name TYPE=$deploy-type RELEASE=$omnileads-release
```

The ENV parameter refers to the name with which we want to identify the customer in the cloud infrastructure, TYPE has to do with the type of OML architecture to be deployed and optionally we can
indicate de OMniLeads version to be deploy, if we do not do it, then the stable version is displayed by default.

*TYPE=aio*, *TYPE=cluster_a*, *TYPE=cluster_b* or *TYPE=cluster_c*

The execution of *make init*  has generated the *../customer-name* directory where the *var.auto.tfvars* file resides. This file has many variables like the sizing of Droplets and Cluster components. You can tune this parameters according to the size of the operation to display:

```
droplet_oml_size = "s-1vcpu-1gb"
droplet_rtp_size = "s-1vcpu-1gb"
droplet_redis_size = "s-1vcpu-1gb"
droplet_dialer_size = "s-1vcpu-1gb"
pgsql_size = "db-s-1vcpu-1gb"
```

The release version of OMniLeads App:

```
oml_release = "release-1.13.0"
```
Set the timezone where the nodes are:
```
oml_tz = "America/Argentina/Cordoba"
```

Then we pay attention to a fundamental parameter since they involve the IP addresses of the SIP trunk providers that will be configured in the PSTN configuration part of OMniLeads, these IPs will be admitted by the firewall when accepting SIP packets:

```
sip_allowed_ip = ["X.X.X.X/32","Y.Y.Y.Y/32","Z.Z.Z.Z/32"]
```

Once the variables have been adjusted, proceed with the plan :)

* **make plan**: this command is a convenient way to check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or to the state.

```
make plan ENV=$customer-name
```

* **make apply**: this command is used to apply the changes required to reach the desired state of the configuration or the pre-determined set of actions generated by a make plan execution plan.

```
make apply ENV=$customer-name
```

* **make destroy**: this commando is used to destroy all the customer infrastructure. Must be used to unsubscribe a customer from the service

```
make destroy ENV=$customer-name
```

* **make delete**: this command is used to delete all the customer build folder and config files.

```
make deletes ENV=$customer-name
```


## Upgrades and Re-sizing

Both for the management of updates and when resizing a component, simply adjust the variables already mentioned within the file corresponding to each customer and then
execute a *make plan* and then the *make apply*.




## License
GPLv3. Every source code file contains the license preamble and copyright details.
