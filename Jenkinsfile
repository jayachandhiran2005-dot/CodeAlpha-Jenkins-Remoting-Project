pipeline {
  agent none
  options { timestamps() }
  stages {
    stage('Build on multiple architectures') {
      parallel {
        stage('x86_64') {
          agent { label 'linux && amd64' }
          steps {
            sh 'echo "Node: $NODE_NAME"; uname -m; java -version 2>&1 | head -1'
          }
        }
        stage('arm64') {
          agent { label 'linux && arm64' }
          steps {
            sh 'echo "Node: $NODE_NAME"; uname -m; java -version 2>&1 | head -1'
          }
        }
      }
    }
  }
}
