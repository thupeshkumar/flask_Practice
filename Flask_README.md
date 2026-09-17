# Flask Application CI/CD Pipelines

This repository demonstrates the implementation of **CI/CD pipelines** for a Flask application using two approaches:
1. **Jenkins Pipeline** (VM or cloud-based Jenkins server).
2. **GitHub Actions Workflow** (cloud-native, integrated with GitHub).

The goal is to automate the **build, test, and deployment** process, ensuring faster delivery, improved reliability, and secure integration with MongoDB Atlas.

---

## 📌 Project Overview
CI/CD automation improves developer productivity, reduces manual errors, and ensures reliable deployments of a Flask application integrated with MongoDB Atlas.

---

## ⚙️ Tech Stack
- **Language/Framework**: Python 3.12, Flask 3.x  
- **Database**: MongoDB Atlas (cloud-hosted NoSQL)  
- **Testing**: Pytest 9.x  
- **CI/CD Tools**:
  - Jenkins 2.x (Pipeline plugin, GitHub integration, Email Extension)
  - GitHub Actions (workflow automation)
- **Version Control**: GitHub  
- **Infrastructure**: VM/Cloud server for Jenkins deployment  
- **Secrets Management**:
  - Jenkins Credentials Store
  - GitHub Secrets  

---

## 📂 Repository Structure
```
flask-ci-cd/
├── app.py
├── requirements.txt
├── test_app.py
├── Jenkinsfile
├── .github/workflows/ci-cd.yml
├── README.md
└── docs/
    ├── assignment.pdf
    └── screenshots/
        ├── jenkins/
        └── github-actions/
```

---

## 🔄 CI/CD Pipeline Architecture

### Jenkins Pipeline
- **Build**: Install dependencies (`pip install -r requirements.txt`)
- **Test**: Run unit tests with `pytest`
- **Deploy**: Deploy Flask app to staging environment with MongoDB Atlas connection
- **Trigger**: GitHub webhook on push to `main`
- **Notifications**: Email alerts on success/failure

### GitHub Actions Workflow
- **Install Dependencies**: Setup Python environment and install requirements
- **Run Tests**: Execute test suite with `pytest`
- **Build**: Package application for deployment
- **Deploy to Staging**: Triggered on push to `staging`
- **Deploy to Production**: Triggered on tagged release
- **Secrets**: MongoDB credentials stored securely in GitHub Secrets

---

## 📊 Jenkins vs GitHub Actions Comparison

| Feature            | Jenkins Pipeline                  | GitHub Actions Workflow         |
|--------------------|-----------------------------------|---------------------------------|
| Trigger            | Webhook (push to main)            | Push to staging / release tag   |
| Build              | pip install dependencies          | pip install dependencies        |
| Test               | pytest                           | pytest                          |
| Deploy             | VM/Cloud staging environment      | GitHub-hosted staging/production |
| Secrets Management | Jenkins Credentials Store         | GitHub Secrets                  |
| Notifications      | Email                            | GitHub logs + email/slack       |

---

## 🖼️ Architecture Diagram
**Flow:**
- Developer pushes code to GitHub.
- GitHub triggers Jenkins pipeline (Build → Test → Deploy).
- GitHub Actions workflow runs (Install → Test → Build → Deploy).
- Both pipelines connect securely to MongoDB Atlas.
- Notifications (Email/Slack) sent on success/failure.

*(Insert diagram image here in docs/assignment.pdf)*

---

## ⚙️ Continuous Integration (CI)
**Continuous Integration (CI)** ensures that new code integrates smoothly with the existing codebase.

### Key Principles
- Frequent commits to main branch
- Automated builds and tests
- Immediate feedback via notifications
- GitHub integration for monitoring commits/pull requests

### Benefits
- Early bug detection  
- Faster feedback loops  
- Improved collaboration  
- Reliable builds  

---

## 🔧 Fork & Configurations

### Fork the Repository
- Original repo: [flask_Practice](https://github.com/mohanDevOps-arch/flask_Practice.git)  
- Fork it to your GitHub account.

### Clone & Setup
```bash
git clone https://github.com/thupeshkumar/flask_Practice.git
cd flask_Practice
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pytest -v
```

### MongoDB Atlas
- Create cluster and whitelist Jenkins server IP
- Create `StudentDB` database
- Add user with read/write permissions
- Store credentials securely:
  - Jenkins → Credentials ID: `mongodb-atlas-creds`
  - GitHub → Secrets: `MONGO_USER`, `MONGO_PASS`

---

## 🛠 Jenkins Configuration
- Install plugins: Pipeline, GitHub Integration, Email Extension
- Create pipeline job:
  - Source: forked GitHub repo
  - Script path: `Jenkinsfile`
- Add webhook:
  - URL: `http://<jenkins-server>:8080/github-webhook/`
  - Trigger: Push events

---

## 🛠 GitHub Actions Configuration
- Create `.github/workflows/ci-cd.yml`
- Define jobs: Install → Test → Build → Deploy
- Add secrets under **Settings → Secrets → Actions**

---

## 🧪 Run Tests Locally
```bash
python -m venv venv
source venv/bin/activate   # Mac/Linux
venv\Scripts\activate      # Windows
pip install -r requirements.txt
pytest -v
```

### Example `.env`
```
MONGO_URI=mongodb+srv://<user>:<password>@cluster.mongodb.net/StudentDB
```

---

## 📑 Deliverables
- Forked GitHub repository with Jenkinsfile and workflow file
- Updated README.md with documentation
- Screenshots of Jenkins and GitHub Actions pipeline executions
- Final PDF submission with architecture diagram and screenshots

---

## ✅ Conclusion
This project highlights the benefits of CI/CD automation for Flask applications:
- Jenkins provides flexibility and control for on-prem/cloud setups.
- GitHub Actions offers seamless GitHub integration and cloud-native workflows.
Together, they demonstrate modern DevOps practices for reliable and efficient software delivery.
```

---
