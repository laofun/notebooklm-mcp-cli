---
trigger: always_on
---

When we publish to NotebookLM MCPand CLI repo, there is a github action that checks that both toml, init, and skill files are on the same version. Otherwise, the push will fail, so make sure that before you publish, all versions on all three files match. '