
# What is this

THIS_PROJECT is an infrastructure code project for managing SOME_INFRASTRUCTURE.

THIS_PROJECT is a plain Terraform code project that you could use by directly running the terraform command and passing parameters and configuration. However, it's designed to be used with [spin-tools](https://github.com/cloudspinners/spin-tools) to manage multiple instances of the infrastructure, including testing and delivery to different environments. spin-tools also supports assembling multiple infrastructure stacks into composable environments; however, this project is a single standalone stack.

spin-tools is packaged in a docker image using [dojo](https://github.com/kudulab/dojo), so that you can work with the code in projects like THIS_PROJECT in a local working environment that has the necessary tooling (including things like Terraform and the aws CLI) prepackaged. This approach also ensures that the code can be used consistently in delivery pipelines.


# How to work with this project

The following howto guides are given below:

- As an infrastructure developer, I want to work on the code for THIS_PROJECT, so I can make improvements to the SOME_INFRASTRUCTURE (and learn how to use the spin-tools)
- As an infrastructure user, I want to create and manage instances of SOME_INFRASTRUCTURE


## HOW TO: Prerequisites for the other how-tos.

1. Docker and docker-compose. I use colima to run it on my Mac. Make sure you're running it to expose network ports (with colima, start it with the command  `colima start --network-address`).
2. [Dojo](https://github.com/kudulab/dojo) (I install it on my Mac with homebrew)


## How to work on the code in this project

(Assumes you have commit access. Otherwise you can fork the repository, but we need instructions that don't require access to things like the AWS account and whatever else we use to test).

Run the `dojo` command, which downloads a [spin-tools](https://github.com/cloudspinners/spin-tools) container image and starts an instance for local development. This puts you at a prompt in the container, with the project files mounted. Write tests and code. When you're ready, push the code changes and the build job runs in github actions. This job will test and build the stack package so it can be made available for use.

Run the `go` script on the host (not inside a running container) to manage dojo images to use and run tests from outside the container. Run `./go help` to see the commands available. Run the `gojo` script from inside the running container to run the test suite. Run `./gojo help` to see the commands available.


# How to create and manage infrastructure using the THIS_PROJECT code

Run the dojo command (having installed the prerequisites as explained above) to get a prompt with the spin-tools installed. Then you can run the `stack-spin` command to manage an instance of THIS_PROJECT infrastructure.

Configure your infrastructure stack by either adding a file under `./instances`, or by making a file in the base folder named `./instance-spec.yml`. Copy the contents of `./instances/example-sandbox.yml` to play around. This stores terraform state locally, so is mainly useful for a single session (e.g. for developing and testing), rather than for managing persistent infrastructure.

For persistent infrastructure, you can configure your instance to use terraform cloud:

```
  tool: 
    name: terraform
    backend:
      name: cloud
      organization: YOUR_TFCLOUD_ORG
      workspace: YOUR_TFCLOUD_SANDBOX
```
