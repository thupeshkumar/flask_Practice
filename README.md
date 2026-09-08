# Flask Practice — CI/CD Pipelines

This document explains the two CI/CD pipelines set up for this repository:

1. **Jenkins pipeline** (`Jenkinsfile`) — build, test, deploy to staging.
2. **GitHub Actions workflow** (`.github/workflows/ci-cd.yml`) — install, test,
   build, deploy to staging, deploy to production on release.

---

## 1. Jenkins CI/CD Pipeline

### Prerequisites
- A Linux VM (Ubuntu 24.04 recommended) or a cloud Jenkins service (e.g. an
  EC2/Azure VM, or a managed Jenkins offering).
- Java 17 (required by modern Jenkins).
- Python 3.10+ and `pip` installed on the Jenkins agent that will run builds.
- Git installed on the Jenkins agent.
- A GitHub account with this repository forked into it.
- Jenkins plugins: **Git**, **Pipeline**, **GitHub**, **Email Extension
  (emailext)**, **JUnit**.
- An SMTP account (e.g. Gmail with an App Password) for email notifications.

### Setup Steps

1. **Install Jenkins**
   ```bash
   sudo apt update
   sudo apt install -y openjdk-17-jdk
   curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
     /usr/share/keyrings/jenkins-keyring.asc > /dev/null
   echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
     https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
     /etc/apt/sources.list.d/jenkins.list > /dev/null
   sudo apt update
   sudo apt install -y jenkins
   sudo systemctl enable --now jenkins
   ```
   Browse to `http://<server-ip>:8080`, unlock Jenkins with the initial
   admin password (`/var/lib/jenkins/secrets/initialAdminPassword`), and
   install the suggested plugins plus the ones listed above.

2. **Install Python tooling on the agent**
   ```bash
   sudo apt install -y python3 python3-venv python3-pip
   ```

3. **Fork and clone the repository**
   - Fork `https://github.com/mohanDevOps-arch/flask_Practice.git` into your
     own GitHub account.
   - On the Jenkins server, clone your fork once manually to confirm access,
     then let Jenkins manage subsequent clones via the pipeline job:
     ```bash
     git clone https://github.com/<your-username>/flask_Practice.git
     ```

4. **Add the Jenkinsfile**
   - Copy the provided `Jenkinsfile` into the root of your forked repository
     and push it to `main`.

5. **Create the Pipeline job in Jenkins**
   - New Item → Pipeline → name it `flask-practice-pipeline`.
   - Under **Pipeline**, choose **Pipeline script from SCM** → SCM: Git →
     enter your fork's URL and credentials (a GitHub Personal Access Token
     works well for HTTPS, or an SSH key).
   - Set the **Script Path** to `Jenkinsfile`.

6. **Configure the GitHub webhook trigger**
   - In your GitHub fork: Settings → Webhooks → Add webhook →
     Payload URL: `http://<jenkins-server>:8080/github-webhook/`,
     content type `application/json`, event: **Just the push event**.
   - In the Jenkins job configuration, enable **GitHub hook trigger for
     GITScm polling** (the `pollSCM` line in the Jenkinsfile is a safety-net
     fallback in case the webhook doesn't fire).

7. **Configure email notifications**
   - Manage Jenkins → System → **Extended E-mail Notification**: set SMTP
     server, port, credentials, and default recipient.
   - Optionally set a `NOTIFY_EMAIL` environment variable on the job (or edit
     the Jenkinsfile default) so `emailext` sends to the right address.

8. **Run the pipeline**
   - Push a commit to `main` (or click **Build Now**) and confirm all three
     stages — Build, Test, Deploy — go green.
   - Take screenshots of the Jenkins **Stage View** and the **Console
     Output** for the submission.

### Pipeline Stages
| Stage | What it does |
|---|---|
| Checkout | Pulls the latest code from the configured branch |
| Build | Creates a virtualenv and installs `requirements.txt` |
| Test | Runs `pytest` with JUnit + coverage reporting |
| Deploy | On `main` only: syncs files to the staging path and restarts the app |

Email notifications fire on both `success` and `failure` in the `post`
block of the Jenkinsfile.

---

## 2. GitHub Actions CI/CD Pipeline

### Prerequisites
- The repository has both a `main` branch and a `staging` branch.
- A staging server (and, optionally, a production server) reachable over SSH.
- GitHub repository **Settings → Secrets and variables → Actions** access to
  add the secrets below.

### Required GitHub Secrets
| Secret | Used for |
|---|---|
| `STAGING_HOST` | Hostname/IP of the staging server |
| `STAGING_USER` | SSH user on the staging server |
| `STAGING_SSH_KEY` | Private key for SSH access to staging |
| `PROD_HOST` | Hostname/IP of the production server |
| `PROD_USER` | SSH user on the production server |
| `PROD_SSH_KEY` | Private key for SSH access to production |

Add each one via **Settings → Secrets and variables → Actions → New
repository secret**.

For extra safety, define **Environments** (Settings → Environments) named
`staging` and `production`, attach the corresponding secrets there instead
of at the repo level, and optionally require manual approval before the
`production` environment deploys.

### Setup Steps

1. Create the branch structure if it doesn't exist:
   ```bash
   git checkout -b staging
   git push -u origin staging
   ```
2. Create the workflow directory and file:
   ```bash
   mkdir -p .github/workflows
   cp ci-cd.yml .github/workflows/ci-cd.yml
   git add .github/workflows/ci-cd.yml
   git commit -m "Add GitHub Actions CI/CD workflow"
   git push
   ```
3. Add the secrets listed above under **Settings → Secrets and variables →
   Actions**.
4. Push a commit to `staging` to trigger the `deploy-staging` job, and
   publish a GitHub **Release** (tag) to trigger `deploy-production`.
5. Watch the run under the **Actions** tab and screenshot each job
   (install-and-test, build, deploy-staging/production) once it's green.

### Workflow Jobs
| Job | Trigger | What it does |
|---|---|---|
| `install-and-test` | Every push/PR to `main` or `staging` | Installs deps, runs `pytest` |
| `build` | After tests pass | Packages the app into a zip artifact |
| `deploy-staging` | Push to `staging` | Copies the build to the staging server via SSH and restarts it |
| `deploy-production` | A GitHub Release is published | Copies the build to the production server via SSH and restarts it |

---

## Notes on the Application

This app connects to MongoDB via `Flask-PyMongo`. For CI test runs, either:
- Mock the MongoDB layer in tests, or
- Set a `TESTING=1` environment variable and guard the real DB connection in
  `app.py` behind `if not os.environ.get("TESTING")`, or
- Spin up a throwaway MongoDB service in the CI job (a `services:` block in
  GitHub Actions, or a Docker container on the Jenkins agent).

Adjust `requirements.txt`, the staging paths, and the restart commands in
both the `Jenkinsfile` and `ci-cd.yml` to match your actual server layout.
