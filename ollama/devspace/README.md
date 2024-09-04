# Agent Prompts

Agent Prompts is a tool for generating prompts for Kubert agents.

## Python Environment

Use pyenv to create new venv

```bash
pyenv install 3.12.5
pyenv virtualenv 3.12.5 agent-prompts
```

Activate the new venv

```bash
pyenv activate agent-prompts
```

Set the pyenv version as local for this directory

```bash
  pyenv local agent-prompts
```

Install dependencies

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt -r dev-requirements.txt
```

## Kube Context

Setup the kubectl context for the project.

Check the context configuration

```bash
# List of context
kubectl config current-context
# Namespace for the current context
kubectl config view --minify -o jsonpath='{..namespace}'
```

Create the new namespace

```bash
kubectl create namespace kubert-assistant-dev
```

Set the context with the new namespace

```bash
kubectl config use-context your-cluster-context
kubectl config set-context your-cluster-context --namespace=kubert-assistant-dev
```

## Devspace

We are adding global parameters to each command to make sure we are using the correct kube cluster and namespace.

For Dev

```bash
devspace dev --kube-context=your-cluster-context --namespace=kubert-assistant-dev
```
