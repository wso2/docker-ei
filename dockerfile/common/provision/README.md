# Provisioning for WSO2 Docker Image Configuration
WSO2 Dockerfiles provide Dockerfiles for a number of WSO2 products to be used to build Docker images. The way these images are built and products inside them configured can vary depending on a number of factors. The configuration step of the Docker image build process is made extensible to allow this diversity of approaches.

The `build.sh` helper script will make use of the specified *provisioning method* to prepare the build process and subsequently configure the product inside. This involves two steps, hence two separate `bash` scripts.

* #### `image-prep.sh`
This script should validate and prepare the folder where files needed to configure the image will later be served from. `image-prep.sh` should export a variable named `file_location` that points to the folder where the `HTTP_PACK_SERVER` should be started.

* #### `image-config.sh`
This is the script that will get called inside the Dockerfile when the `docker build` command is invoked. It will download the needed files from the specified `HTTP_PACK_SERVER` and perform configuration steps as specifically needed.

`wso2/dockerfiles` include two provisioning methods, `default`, and `puppet`.

* ### `default` Provisioning
This involves a simple set of steps where the provided WSO2 product `zip` file and the JDK is copied to the Docker image. If no provisioning method is specified when invoking `build.sh`, `default` will be selected. The relevant files should be available inside `common/provision/default/files` folder.

* ### `puppet` Provisioning
[`wso2/puppet-modules`](https://github.com/wso2/puppet-modules) include Puppet modules and Hiera data that can be used to configure WSO2 products. `puppet` provisioning method uses these Puppet modules to execute a `puppet apply` command when building the Docker image and configure the product. The Puppet modules should be available at a separate location and the environment variable `PUPPET_HOME` should point to that location.

## Writing Custom Provisioning Methods
To write a custom provisioning method, simply create two `bash` scripts named `image-prep.sh` and `image-config.sh` that perform their respective duties, as specified above, and place them inside `common/provision/{your_provisioning_method}/` folder. When invoking `build.sh` pass the name of the provisioning method with `-r` flag.

Refer to the `default` provisioning method as a simple example.
