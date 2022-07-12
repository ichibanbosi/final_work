pipeline{
    agent any

    stages {
        stage ('git_clone') {
            steps {
               git branch: 'main', url: 'https://github.com/ichibanbosi/final_work.git'
               sh 'echo $WORKSPACE > /tmp/var_w.txt'
            }
        }

        stage ('Create_VM') {
            agent any
            steps {
                sh '''
                  export REP=$(cat /tmp/var_w.txt)
                  BEGIN=$(pwd)
                  export TOKEN_Y=$TOKEN_Y && echo "TOKEN_Y=$TOKEN_Y" > varibles.txt
                  export CLOUD_ID_Y=$CLOUD_ID_Y && echo "CLOUD_ID_Y=$CLOUD_ID_Y" >> varibles.txt
                  export FOULDER_ID_Y=$FOULDER_ID_Y && echo "FOULDER_ID_Y=$FOULDER_ID_Y" >> varibles.txt
                  export SUBNET_ID_Y=$SUBNET_ID_Y && echo "SUBNET_ID_Y=$SUBNET_ID_Y" >> varibles.txt
                  cd $REP
                  terraform init
                  terraform apply -var-file $BEGIN/varibles.txt -auto-approve
                  BUILD_IP=$(terraform output build_ip |sed -e 's/^"//' -e 's/"$//')
                  PROD_IP=$(terraform output prod_ip |sed -e 's/^"//' -e 's/"$//')
                  echo "[build]" > /etc/ansible/hosts
                  echo $BUILD_IP >> /etc/ansible/hosts
                  echo "[prod]" >> /etc/ansible/hosts
                  echo $PROD_IP >> /etc/ansible/hosts
                  ssh-keyscan -H $BUILD_IP >> ~/.ssh/known_hosts
                  ssh-keyscan -H $PROD_IP >> ~/.ssh/known_hosts
                  ansible all -m ping -v
                  '''
            }
        }
    }
}
