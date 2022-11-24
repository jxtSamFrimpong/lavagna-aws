#!/bin/bash
PROJECT_NAME="lavagna-sam-frimpong"
PROJECT_DEPLOY_VERSION="1.0"
UNTAR_DIRECTORY="."

while getopts 'p:v:w:' OPTION;
do
    case "$OPTION" in

    p)
        PROJECT_NAME="$OPTARG"
        #echo $PROJECT_NAME
        ;;

    v)
        PROJECT_DEPLOY_VERSION="$OPTARG"
        #echo $PROJECT_DEPLOY_TAG
        ;;

    w)
        UNTAR_DIRECTORY="$OPTARG"
        #echo $PROJECT_DEPLOY_TAG
        ;;
    
    ?)
        #echo "Invalid Flags"
        echo "Usage: build [-l lavagna-tagname] [-d docs-tag-name] "
        exit 1
        ;;

    esac
done
shift "$(($OPTIND -1))"

untar_packack(){
    tar -xzvf "${PROJECT_NAME}_${PROJECT_DEPLOY_VERSION}.tar.gz" -C $UNTAR_DIRECTORY

    chmod 766 "$PROJECT_NAME"

    chmod +x "$PROJECT_NAME/docker-install.sh"
    "./${PROJECT_NAME}/docker-install.sh"

    chmod +x "$PROJECT_NAME/main.sh"
    "./${PROJECT_NAME}/main.sh"
}

untar_packack