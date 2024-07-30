# Docker Image Release Process

**This document explains a set of guidelines that need to be followed when releasing new Docker images.**

- Please follow the guidelines below to release a new Docker image.

#### Step 1: Update/Create Dockerfiles

    - To create a Docker image you need to have a Dockerfile. A Dockerfile contains a set of instructions that instructs Docker on how to build a certain image. To find more information on how to use Dockerfiles visit https://docs.docker.com/engine/reference/builder/.
    - To create/update a Docker file first you need to clone the docker repository and checkout to the corresponding branch.
    - If you are creating new Dockerfiles make sure to follow the same folder structure as the previous versions (dockerfiles/<OS flavor>/<product>).
    - Move inside the dockerfiles directory. Here we have different directories for each OS flavor that we support for the corresponding version. WSO2 Docker images come in three OS flavors (Alpine, CentOS, Ubuntu). Inside each of these directories we have the products that we support. Move to the corresponding product directory.
    - Here we have 3 files
        - Dockerfile
        - ReadMe - Instructions on how to build the docker image.
        - docker-entrypoint.sh - A set of commands that should run when a container is started from the Docker image
    - If you are creating an image please make sure to create Dockerfiles for all three OS flavors. If you are just modifying a Dockerfile make sure to port the changes to all three images if it’s possible. This will help to maintain consistency.
    - Notice that each Dockerfile of an WSO2 product has a label named MAINTAINER. This refers to the corresponding release tag of the product. Make sure to update the release tag with a new version. Use the same release tag in all three images.

> **Note**: The changes we add to the latest release branch should also be merged to the master (i.e. if the latest release is 4.2.0, whatever the changes we add to 4.2.x branch should be added to the master) and the release should be done from the master branch.

> **Note**: When preparing for a new version release, we should create a new branch from master (ex: 4.2.x) and work on that. Once all work is done, merge that branch to master and do the release from the master (4.2.0.1)

#### Step 2: Update the Changelog

    - Update the changelog with the changes offered by the new images. Try to be specific.

#### Step 3: Create a new release tag

    - Once all the changes are merged to the WSO2 repository, you need to release a Git release tag. You can follow the following steps to create a new release tag.
        - Go to the releases page (https://github.com/wso2/docker-apim/releases) and draft a new release. You can use the already existing releases to get the release notice template.
        - Select the correct branch and create a new tag in the drafting view (this tag should be the same tag you included under the maintainer label in step 1).
    - Add a release notice with the changes you have made. This will help customers to understand the changes that they can expect from the corresponding release.

#### Step 4: Update build scripts

    - Next step is to update the release tags in the Docker image build pipeline. This repository contains JSON scripts that the Jenkin builds use to build and release the Docker images.
    - For products that support WUM, move to resources/org/wso2/ie/conf/ directory and for products that support U2, move to resources/org/wso2/ie/conf/update2 directory.
    - Here we have JSON scripts for EI, APIM, IS and OB Jenkins builds. Open the corresponding json file (ex. apim-data.json)
    - If you are just modifying a Docker image, change the docker_release_version of the corresponding product and the version with the tag released at step 3. 
    - If you are creating a new Docker image add the following block inside the versions array of the corresponding product.
            
            {
                    "product_version": "<version>",
                    "docker_release_version": "<Git release tag>",
                    "latest": <true if this version is the latest of the product. Otherwise false>,
                    "multi_jdk_required": <true if multiple JDKs are supported. Otherwise false>
            }


#### Step 5: Release the images
- To release an image we can follow two methods. We can either manually release the image or use the nightly build.

###### Manual Release

    - For a manual release follow the below steps.
        - For U2 releases go to https://staging-supportbuilder-wilkes.wso2.com/jenkins/job/wum-docker-builds/job/update2/ and select the corresponding build job (ex. product-apim, product-ei).
        - If you added a new Docker image, click on Configure blade and add the new version to the wso2_product_version choice parameter. Make sure to add the new version to the description field too. Click save and exit from the configuration window.
        - Then click Build with parameters blade.
        - Select the corresponding product and the version.
        - Click on build.
        - For WUM releases go to https://staging-supportbuilder-wilkes.wso2.com/jenkins/job/wum-docker-builds/ and select the corresponding build job (ex. product-apim, product-ei).
        - Then repeat steps ii-v.

###### Nightly Build

    - If you just modified the Dockerfiles, nightly build will automatically build the images as configured in [Docker image build pipeline.](https://github.com/wso2-enterprise/docker-image-build-pipeline)

    - If you want to add new images to the nightly build,
        - you need to add the new versions to both the product build (ex. product-ei) and the corresponding product parent build (docker-parent-ei). 
        - The parent build is scheduled to trigger the product build at a pre scheduled time.
