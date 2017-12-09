node {
   def mvnHome
   stage('Checkout') { 
      
      checkout scm
    
      mvnHome = tool 'maven'
   }
   stage('Build jar') {
      if (isUnix()) {
         sh "'${mvnHome}/bin/mvn' -f workspace/spring-boot-sample clean package"
      } else {
         bat(/"${mvnHome}\bin\mvn" -f workspace\spring-boot-sample clean package/)
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