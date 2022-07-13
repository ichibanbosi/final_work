pipeline{
    agent any

    stages {
        stage ('git_clone') {
            steps {
               git branch: 'main', url: 'https://github.com/ichibanbosi/final_work.git'
               sh 'cp config ~/.ssh/config'
            }
        }

        stage ('Create_VM') {
            steps {
                sh '''
                  BEGIN=$(pwd)
                  export TOKEN_Y=$TOKEN_Y && echo "TOKEN_Y=$TOKEN_Y" > varibles.txt
                  export CLOUD_ID_Y=$CLOUD_ID_Y && echo "CLOUD_ID_Y=$CLOUD_ID_Y" >> varibles.txt
                  export FOULDER_ID_Y=$FOULDER_ID_Y && echo "FOULDER_ID_Y=$FOULDER_ID_Y" >> varibles.txt
                  export SUBNET_ID_Y=$SUBNET_ID_Y && echo "SUBNET_ID_Y=$SUBNET_ID_Y" >> varibles.txt
                  terraform init
                  terraform apply -var-file $BEGIN/varibles.txt -auto-approve
                  echo build:$(terraform output build_ip |sed -e 's/^"//' -e 's/"$//') > var_for_ansible.txt
                  echo prod:$(terraform output prod_ip |sed -e 's/^"//' -e 's/"$//') >> var_for_ansible.txt
                  '''
            }
        }
        stage ('start_ansible_roles') {
            steps {
                sh '''
                  BUILD_IP=$(cat var_for_ansible.txt |grep build |cut -d ':' -f 2)
                  PROD_IP=$(cat var_for_ansible.txt |grep prod |cut -d ':' -f 2)
                  echo "[build]" > /etc/ansible/hosts
                  echo $BUILD_IP >> /etc/ansible/hosts
                  echo "[prod]" >> /etc/ansible/hosts
                  echo $PROD_IP >> /etc/ansible/hosts
                  TOKEN_A=$(cat varibles.txt |grep TOKEN |cut -d'=' -f 2|sed -e 's/^"//' -e 's/"$//')
                  echo $TOKEN_A
                  ansible-playbook start.yaml --extra-vars "TOKEN_ANSIB=$TOKEN_A" --extra-vars "CON_REGESTRY_ID=$CONTAINER_REGESTRY_ID"
                  '''
            }
        }
    }
}
