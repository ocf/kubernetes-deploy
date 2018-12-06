pipeline {
  agent {
    label 'slave'
  }

  options {
    ansiColor('xterm')
    timeout(time: 1, unit: 'HOURS')
    timestamps()
  }

  stages {
    stage('check-gh-trust') {
      steps {
        checkGitHubAccess()
      }
    }

    stage('set-version') {
      steps {
        script {
          sha = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          version = "${new Date().format("yyyy-MM-dd-'T'HH-mm-ss")}-git${sha}"
        }
      }
    }

    stage('cook-image') {
      environment {
        DOCKER_REPO = 'docker-push.ocf.berkeley.edu/'
        DOCKER_REVISION = "${version}"
      }

      steps {
        sh 'make cook-image'
      }
    }

    stage('push-to-registry') {
      environment {
        DOCKER_REPO = 'docker-push.ocf.berkeley.edu/'
        DOCKER_REVISION = "${version}"
      }
      when {
        branch 'master'
      }
      agent {
        label 'deploy'
      }
      steps {
        sh 'make push-image'
      }
    }
  }

  post {
    failure {
      emailNotification()
    }
    always {
      node(label: 'slave') {
        ircNotification()
      }
    }
  }
}

// vim: ft=groovy
