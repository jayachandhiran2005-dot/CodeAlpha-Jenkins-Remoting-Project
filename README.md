# Jenkins Remoting Project

Hands-on project for connecting remote Jenkins nodes with **Jenkins Remoting**, distributing builds securely, running jobs on different architectures, and hardening agents with node isolation.

## Goals
- Set up Jenkins Remoting to connect remote Jenkins nodes
- Distribute build load across different machines securely
- Run jobs on various architectures remotely
- Improve security using node isolation
- Gain hands-on experience with Jenkins' remote execution capabilities

## Repository layout
```
.
├── controller/docker-compose.yml   # Jenkins controller (0 executors recommended)
├── agent/docker-compose.yml        # Inbound (WebSocket) agent container
├── scripts/start-agent.sh          # Run agent.jar directly on a remote machine
├── systemd/jenkins-agent.service   # Keep the agent running across reboots
├── Jenkinsfile                     # Multi-architecture parallel pipeline
└── docs/
    ├── architecture.md
    └── security-hardening.md
```

## Quick start

### 1. Start the controller
```bash
cd controller
docker compose up -d
# open http://localhost:8080 and finish the setup wizard
```
Then: **Manage Jenkins → Nodes → Built-In Node → set executors to 0**.

### 2. Create a node
**Manage Jenkins → Nodes → New Node** → Permanent Agent.
- Remote root directory: `/home/jenkins/agent`
- Labels: e.g. `linux amd64` (use `arm64` on ARM machines, `windows` on Windows)
- Launch method: *Launch agent by connecting it to the controller*
- Enable **WebSocket** under the node's advanced options

Copy the node **secret** from the node's status page.

### 3. Connect the agent

**Option A: Docker**
```bash
cd agent
cp .env.example .env     # fill in URL, name, secret
docker compose up -d
```

**Option B: plain Java (Java 17+)**
```bash
export JENKINS_URL=http://<controller>:8080
export AGENT_NAME=linux-node-1
export AGENT_SECRET=<secret>
./scripts/start-agent.sh
```

**Option C: systemd service** — see `systemd/jenkins-agent.service`.

### 4. Run the pipeline
Create a Pipeline job pointing at this repository. The `Jenkinsfile` builds in parallel on nodes labelled `amd64` and `arm64` and prints where each stage ran.

## Exercises
1. Connect two agents with different architectures and run the same pipeline on both.
2. Kill an agent mid-build and observe the failure and reconnection behaviour.
3. Add a node with a restricted label and confirm unlabeled jobs can't use it.
4. Compare build times with 1 vs. 3 agents under parallel load.
5. Confirm Agent → Controller access control blocks an agent from reading controller files.

## Troubleshooting
| Symptom | Likely cause |
|---|---|
| `UnsupportedClassVersionError` | Agent Java version older than the controller requires |
| Agent never connects | Firewall, wrong URL, or WebSocket not enabled on the node |
| `403` / authentication failed | Wrong node name or secret |
| Jobs stay queued | No node matches the label expression |

## License
MIT
