#!/bin/bash



### Script to add a tag
### The script checks that:
### - the tag does not exist yet
### - the tag is present in the CHANGELOG file


### usage function
function usage {
    echo -e "\nUsage: $(basename "$1") [Options]"
    echo -e "\n [Options]"
    echo -e "\t-t : git tag to deploy"        
    echo -e "\n\n [Example]: \n\t# ./tag-version4prod.sh -t version-1.2.3"
    echo -e "\n\n You must be in a local git repository to use this script."
}


### check if options are correctly passed to the script

while getopts :b:t:h: option
do
    case "${option}"
    in
	t) tag=${OPTARG};;	    
        h) usage "$0" ;  exit 0;;
        \?)  echo "Invalid option: -$OPTARG"; usage "$0"  ;  exit 1;;
	:)  echo "Option -$OPTARG requires an argument." >&2  ; exit 1 ;;
    esac
    shift $((OPTIND-1)); OPTIND=1
done

declare -A REQUIRED_ARGS=( [tag]=" git tag to deploy is missing. Use option -t." )


for REQ in "${!REQUIRED_ARGS[@]}"
do
    if [[ -z  ${!REQ} ]]
    then echo -e "\nERROR: ${REQUIRED_ARGS[$REQ]}"
	 usage "$0"
	 exit 1
    fi
done


### bash environment configuration to exit in case of error
set -o pipefail
set -x
set -u
set -e


echo "check that tag name is correctly formatted"
if [[ ! ${tag} =~ ^"version-"[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: TAG format is incorrect"
    echo "correct format is version-1.2.3"
    exit 1
fi

echo "check that tag has not been already used"
if [[ $(git tag | grep '^'"$tag"'$') ]]; then
    echo "ERROR: TAG has been already used"
    exit 1
fi


echo "check that TAG name is present in CHANGELOG file"
if [[ ! $(grep '^'"${tag}"'$' CHANGELOG) ]]; then
    echo "ERROR: TAG not present in CHANGELOG file"
    exit 1
fi

git tag $tag -m "[TAG] $tag"
