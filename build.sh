#!/bin/bash
DOCS_VERSION="docs"
LAVAGNA_VERSION="lavagna"
PROJECT_NAME="lavagna-sam-frimpong"
PROJECT_DEPLOY_VERSION="1.0"
MYSQL_VERSION="5.7"

while getopts 'd:l:p:t:m:' OPTION;
do
    case "$OPTION" in

    d)
        DOCS_VERSION="$OPTARG"
        #echo $DOCS_VERSION
        ;;

    l)
        LAVAGNA_VERSION="$OPTARG"
        #echo $LAVAGNA_VERSION
        ;;

    p)
        PROJECT_NAME="$OPTARG"
        #echo $PROJECT_NAME
        ;;

    v)
        PROJECT_DEPLOY_VERSION="$OPTARG"
        #echo $PROJECT_DEPLOY_TAG
        ;;

    m)
        MYSQL_VERSION="$OPTARG"
        #echo $MYSQL_VERSION
        ;;
    
    ?)
        #echo "Invalid Flags"
        echo "Usage: build [-l lavagna-tagname] [-d docs-tag-name] "
        exit 1
        ;;

    esac
done
shift "$(($OPTIND -1))"

echo "docs version = $DOCS_VERSION"
echo "lavagna version = $LAVAGNA_VERSION"

pass_env(){
    echo "DOCS=$DOCS_VERSION" > .env
    echo "LAVAGNA=$LAVAGNA_VERSION" >> .env
    echo "MYSQL=$MYSQL_VERSION" >> .env
    echo "COMPOSE_PROJECT_NAME=$PROJECT_NAME" >> .env
    echo "PROJ_VERSION=$PROJECT_DEPLOY_VERSION" >> .env
}


build_and_push_images(){
    docker build -t schmiterlin:lavagna -f Dockerfile.6-aws.2 .
    docker tag schmiterlin:lavagna 644435390668.dkr.ecr.us-west-2.amazonaws.com/schmiterlin:$LAVAGNA_VERSION
    docker push 644435390668.dkr.ecr.us-west-2.amazonaws.com/schmiterlin:$LAVAGNA_VERSION

    docker build -t schmiterlin:docs -f Dockerfile.7 .
    docker tag schmiterlin:docs 644435390668.dkr.ecr.us-west-2.amazonaws.com/schmiterlin:$DOCS_VERSION
    docker push 644435390668.dkr.ecr.us-west-2.amazonaws.com/schmiterlin:$DOCS_VERSION

    pass_env
}

build_tar_and_name(){
    mkdir "$PROJECT_NAME"
    cp conf/ docs-conf/ project/ docker-compose.yml main.sh .env entrypoint.sh docker-install.sh -r "$PROJECT_NAME"
    rm -rf "$PROJECT_NAME/project/.*"
    rm -rf "$PROJECT_NAME/project/src/.*"
    rm -rf "$PROJECT_NAME/project/src/main/.*"
    #TODO remove unecessary dir's

    tar -czvf "${PROJECT_NAME}_${PROJECT_DEPLOY_VERSION}.tar.gz" "$PROJECT_NAME"

    rm -rf "$PROJECT_NAME"

}

build_and_push_images

build_tar_and_name