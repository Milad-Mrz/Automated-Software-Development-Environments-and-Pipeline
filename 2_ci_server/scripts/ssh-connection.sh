echo "Create ssh key"   
ssh-keygen -t rsa -N '' -f /home/vagrant/.ssh/id_rsa_stage

ssh_config=$(cat <<EOF
Host stage-vm
        User vagrant
        Hostname 192.168.56.7
        IdentityFile /home/vagrant/.ssh/id_rsa_stage

EOF
)

echo "$ssh_config" > /home/vagrant/.ssh/config
#mv /home/vagrant/.ssh/id_rsa_stage.pub /vagrant_data

scp vagrant@192.168.56.7:/home/vagrant/.ssh/id_rsa_stage.pub /home/vagrant/.ssh/authorized_keys
