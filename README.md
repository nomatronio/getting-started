# Nomatron Getting Started Template

This repository is a simple starter for the [Nomatron getting started guide](https://nomatron.io/docs/getting-started/).

Use it as a template in your own GitHub account or GitHub organization:

1. Click **Use this template**
2. Create your own repository
3. Follow the getting started guide

## What's inside

- `admin-console/`: admin console service
- `agent-orchestrator/`: agent coordination service
- `embedding-service/`: embedding generation service
- `eval-runner/`: AI evaluation runner service
- `mcp-server/`: MCP server service
- `metrics-pipeline/`: metrics processing service
- `model-gateway/`: model routing service
- `paymemts-api/`: payments API service
- `vector-index/`: vector search index service
- `worker-fleet/`: worker service fleet

Each service deploys a small `nicholasjackson/fake-service` container through Nomad.
