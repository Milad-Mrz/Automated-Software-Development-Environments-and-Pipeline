echo "Create deploy script"
deploy_script=$(cat <<EOF
	#!/bin/bash

	scp /home/vagrant/artefact-repository/$1 vagrant@$2:/home/vagrant/stage

EOF
)

echo "$deploy_script" > ~/deploy-proc.sh
chmod 744 ~/deploy-proc.sh
