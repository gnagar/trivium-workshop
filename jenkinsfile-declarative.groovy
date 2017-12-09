node {
   def mvnHome
   stage('Checkout') { 
      
      git 'git@github.com:gnagar/trivium-workshop.git'
    
      mvnHome = tool 'maven'
   }
   stage('Build jar') {
      if (isUnix()) {
         sh "'${mvnHome}/bin/mvn' -Dmaven.test.failure.ignore clean package"
      } else {
         bat(/"${mvnHome}\bin\mvn" -Dmaven.test.failure.ignore clean package/)
      }
   }
   stage('Build docker image') {
       if (isUnix()) {
         sh "docker build workspace/spring-boot-sample -t gauravnagar/trivium-my-sql"
      } else {
         bat(/docker build workspace\\spring-boot-sample -t gauravnagar\/trivium-my-sql/)
      }
      
   }
}