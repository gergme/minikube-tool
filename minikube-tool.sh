#!/usr/bin/bash

# This script uses latest STABLE as it's default
# Set USE_DEFAULT=0 to use LATEST STABLE
# Set USE_DEFAULT=1 to use MINIKUBE DEFAULT
USE_DEFAULT=0
DEFAULT_DOCKERENV=1
DEFAULT_KUBERNETES="v1.10.0"
STABLE_KUBERNETES="v1.11.0"
DATE_STAMP=`date +%Y%m%d-%H%M-%S`
MACHINE_NAME="minikube"
MACHINE_STORAGE_PATH="$HOME/.minikube"
TMPPATH="/tmp"
WORKPATH="${TMPPATH}/${MACHINE_NAME}-${DATE_STAMP}"
WORKFILE="${MACHINE_NAME}-${DATE_STAMP}.tgz"

###
# Functions
###
cleanmk_warn(){
	TIMETOWIPE=15
	printf "╒═══════════════════════════════════════════════════════════════════════════════╕\n"
	printf "│ WARNING!  This script will PERMANENTLY WIPE your minikube machine and cache!! │\n"
	printf "│           Use --backup to backup your minikube docker machine                 │\n"
	while [ ${TIMETOWIPE} -gt -1 ]; do
	TIMETOWIPE_PAD=$(printf "%02d" ${TIMETOWIPE})
	echo -ne ""╘═[$TIMETOWIPE_PAD]══════════════════════════════════════════════════════════════════════════╛"\033[0K\r"
	[ ${TIMETOWIPE} -eq 0 ] && printf "\n"
	sleep 1
	: $((TIMETOWIPE--))
	done
}

minikube_warn(){
	printf "╒═════════════════════════════════════════════════════════════════╕\n"
	printf "│ WARNING!  Your docker environment is currently set to MINIKUBE! │\n"
	printf "│           Use --unset to unset the docker environment           │\n"
	printf "╘═════════════════════════════════════════════════════════════════╛\n"
}

kubever_warn(){
	if [ ${USE_DEFAULT} -eq 0 ]; then 
	printf "╒═════════════════════════════════════════════════════════════════╕\n"	
	printf "│ WARNING!  Minikube will use kubernetes ${STABLE_KUBERNETES} which is not the │\n"
	printf "│           default of ${DEFAULT_KUBERNETES}                                    │\n"
	printf "╘═════════════════════════════════════════════════════════════════╛\n"
	else
	printf "╒═════════════════════════════════════════════════════════════════╕\n"
	printf "│ NOTICE!   You have selected the default minikube kubernetes     │\n"
	printf "│           ${DEFAULT_KUBERNETES}                                               │\n"
	printf "╘═════════════════════════════════════════════════════════════════╛\n"
fi
}

backup_minikube(){
	[[ ! -d ${MACHINE_STORAGE_PATH}/ ]] && printf "${MACHINE_STORAGE_PATH} doesn't exist ... skipping!\n" && exit 250 || \

	# copy to /tmp and strip out $MACHINE_STORAGE_PATH
	mkdir -p ${WORKPATH}/
	cp -R ${MACHINE_STORAGE_PATH}/ ${WORKPATH}/
	#/tmp/minikube-20181009-1534-02/.minikube/machines/minikube
	perl -pi -e "s|$MACHINE_STORAGE_PATH|__MACHINE__STORAGE_PATH__|g" ${WORKPATH}/.${MACHINE_NAME}/machines/$MACHINE_NAME/config.json
	tar cf - ${WORKPATH} -P | pv -s $(du -sb ${WORKPATH}/ | awk '{print $1}') | gzip > ${WORKFILE}
	rm -rf ${WORKPATH}/
}

restore_minikube(){
	TIMETOWIPE=15
	printf "╒═══════════════════════════════════════════════════════════════════════╕\n"
	printf "│ WARNING!  This option will OVERWRITE your current minikube machine !! │\n"
	while [ ${TIMETOWIPE} -gt -1 ]; do
	TIMETOWIPE_PAD=$(printf "%02d" ${TIMETOWIPE})
	echo -ne ""╘═[$TIMETOWIPE_PAD]══════════════════════════════════════════════════════════════════╛"\033[0K\r"
	[ ${TIMETOWIPE} -eq 0 ] && printf "\n"
	sleep 1
	: $((TIMETOWIPE--))
	done

	minikube stop $MACHINE_NAME
	rm -rf ${MACHINE_STORAGE_PATH}
	printf "Restoring ${RESTORE_FILE} to ${MACHINE_STORAGE_PATH}/machines/${MACHINE_NAME}\n"
	mkdir -p ${HOME}/.minikube/machines/${MACHINE_NAME}/
	tar -zvxf ${RESTORE_FILE} -C ${HOME}/ --strip-components=2
	perl -pi -e "s|__MACHINE__STORAGE_PATH__|$MACHINE_STORAGE_PATH|g" ${WORKPATH}/.${MACHINE_NAME}/machines/$MACHINE_NAME/config.json
}

unset_dockerenv(){
	minikube docker-env --unset
}

set_dockerenv(){

}
version(){
	printf "Version 0.0.11\n"
}

install_ver(){
	[ ${USE_DEFAULT} -eq 0 ] && KUBE_VERSION=${STABLE_KUBERNETES} || KUBE_VERSION=${DEFAULT_KUBERNETES}
}

run_program(){
	cleanmk_warn
	minikube delete
	rm -rfv ~/.minikube/cache
	kubever_warn
	minikube start --kubernetes-version ${KUBE_VERSION} --insecure-registry=localhost:5000
	eval $(minikube docker-env)
	docker run -d -p 5000:5000 --restart=always --name registry registry:2
	minikube status
}

###
# App
###
while test $# -gt 0; do
		case "$1" in
			-h|--help)
					version
					echo "syntax:  ${0} [options] [run]"
					echo "options:"
					echo "-h, --help		Its what youre looking at!"
					echo "-b, --backup		Backup the minikube virtual machine"
					echo "-d, --default-kube	Use the minikube default kubernetes version of ${DEFAULT_KUBERNETES}"
					echo "-r, --restore [file]	Restore a minikube virtual machine"
					echo "-s, --set 		Set the minikube docker environment"
					echo "-u, --unset		Unset the minikube docker environment"
					echo "-v, --version		Show version"
					echo "run			Run the script"
					exit 0
					;;
            -b|--backup)
					backup_minikube
                    shift
                    exit 0
                    ;;

			-d|--default-kube)
					USE_DEFAULT=1
					kubever_warn
					shift
					;;
			-r|--restore)
					RESTORE_FILE=${2}
					restore_minikube
					shift
					exit 0
					;;
			-s|--set)
					set_dockerenv
					shift
					;;
			-u|--unset)
					unset_dockerenv
					shift
					;;
			-v|--version)
					version
					;;
			run)
					install_ver
					run_program
					[ ${DEFAULT_DOCKERENV} -ne 0 ] && set_dockerenv || unset_dockerenv
					RAN=1
					shift
					;;
			*)
					printf "Unknown option!\n"
					RAN=1
					$0 --help
					break
					exit 0
					;;
		esac
done
###
# Exit
###
[ "${RAN}" == "1" ] && exit 0 || \
printf "Here, I'll help you out...\n"
$0 --help
exit 0
