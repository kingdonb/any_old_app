pipeline {
  agent any
  stages {
    stage('Prepare') {
      steps {
        sh('''
            git checkout -B $TARGET_BRANCH
            git config user.name 'jenkins-ci-user'
            git config user.email 'kingdonb@users.noreply.github.example.com'
        ''')
        script {
          version = env.GIT_COMMIT.substring(0,8)
          buildDate = sh(script: "date -u +'%Y-%m-%dT%H:%M:%SZ'")
        }
      }
    }
    stage('Update manifests') {
      steps {
        sh(script: "./jenkins/update-k8s.sh ${env.GIT_COMMIT}")
      }
    }
    stage('Commit changes') {
      environment {
        GIT_AUTH = credentials('jenkins-git-writer-token-auth')
      }
      steps {
        sh('''
            git add . && git commit -am "[Jenkins CI] update-k8s.sh"
            git config --local credential.helper "!f() { echo username=\\$GIT_AUTH_USR; echo password=\\$GIT_AUTH_PSW; }; f"
            git push origin HEAD:$TARGET_BRANCH
        ''')
      }
    }
  }
}
