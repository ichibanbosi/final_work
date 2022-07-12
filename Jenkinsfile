pipeline{
    agent any

    stages {
//        stage ('git_clone') {
//            steps {
//               git 'https://github.com/ichibanbosi/final_work.git'
//            }
//        }

        stage ('Create_VM') {
            agent any
            steps {
                sh '''
                  export TOKEN_Y=$TOKEN_Y && echo "TOKEN_Y=$TOKEN_Y" > varibles.txt
                  export CLOUD_ID_Y=$CLOUD_ID_Y && echo "CLOUD_ID_Y=$CLOUD_ID_Y" >> varibles.txt
                  export FOULDER_ID_Y=$FOULDER_ID_Y && echo "FOULDER_ID_Y=$FOULDER_ID_Y" >> varibles.txt
                  mkdir -p $SSH_KEY_FOULDER
                  if [ ! -f SSH_KEY_FOULDER/id_rsa ]; then ssh-keygen -N '' -f $SSH_KEY_FOULDER/id_rsa; fi
                  '''
            }
        }
    }
}
