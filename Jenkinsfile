pipeline {
    // Inline Kubernetes pod agent. Jenkins runs on EKS and schedules this pod.
    // serviceAccountName jenkins-sa is annotated with an IRSA role that grants ECR push perms.
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-sa
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.16.0-debug
      command:
        - sleep
      args:
        - 99d
    - name: git
      image: alpine/git
      command:
        - sleep
      args:
        - 99d
"""
        }
    }

    // Poll the Git repo every minute; a new commit on final-project auto-starts a build.
    // (Registered after Jenkins loads this Jenkinsfile once — run one build after adding it.)
    triggers {
        pollSCM('* * * * *')
    }

    environment {
        IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
        GIT_REPO  = "github.com/Maksym-Kryvenko/goit-devops.git"
    }

    stages {
        stage('Build & Push') {
            steps {
                container('kaniko') {
                    // ECR authentication is handled automatically by Kaniko's built-in
                    // ECR credential helper, using the jenkins-sa IRSA role. No docker
                    // config or --insecure/--skip-tls-verify is needed (ECR is real TLS).
                    sh '''
                        /kaniko/executor \
                            --context=dir://${WORKSPACE}/django \
                            --dockerfile=django/Dockerfile \
                            --destination=${ECR_REPO}:${IMAGE_TAG} \
                            --cache=true
                    '''
                }
            }
        }

        stage('Update Chart Tag in Git') {
            steps {
                container('git') {
                    withCredentials([usernamePassword(
                        credentialsId: 'github-token',
                        usernameVariable: 'GIT_USER',
                        passwordVariable: 'GIT_PAT'
                    )]) {
                        sh '''
                            set -e
                            rm -rf repo
                            git clone -b final-project https://$GIT_USER:$GIT_PAT@$GIT_REPO repo
                            cd repo

                            sed -i "s|  tag:.*|  tag: $IMAGE_TAG|" charts/django-app/values.yaml

                            git config user.email "ci@jenkins.local"
                            git config user.name "Jenkins CI"

                            git add charts/django-app/values.yaml
                            # Guard against an empty diff so an unchanged tag does not fail the build.
                            git diff --cached --quiet || git commit -m "ci: update image tag to $IMAGE_TAG"
                            git push origin final-project
                        '''
                    }
                }
            }
        }
    }
}
