# Automatic Versioning Commit Examples

## Commits that increment PATCH (v1.0.0 → v1.0.1)
```bash
git commit -m "fix: correct min/max parameter validation"
git commit -m "fix: resolve memory leak issue"
git commit -m "bugfix: fix race condition in generator"
```

## Commits that increment MINOR (v1.0.0 → v1.1.0)
```bash
git commit -m "feature: add /health endpoint"
git commit -m "feat: implement structured logging"
git commit -m "feature: add Prometheus metrics"
```

## Commits that increment MAJOR (v1.0.0 → v2.0.0)
```bash
git commit -m "major: change JSON response format"
git commit -m "major: migrate to new API v2"
git commit -m "major: remove deprecated endpoints"
```

## Release Workflow

1. **Make changes in feature branch**
2. **Create PR to master**
3. **When merging, use descriptive message:**
   ```bash
   git commit -m "feature: add usage statistics endpoint"
   ```
4. **Push to master will automatically trigger:**
   - Version increment (MINOR in this case)
   - Git tag creation (e.g: v1.2.0)
   - Docker image build and push with multiple tags
   - Kubernetes deployment with 10 replicas
   - GitHub Release creation with notes

## Resulting Container Registry Tags

After a commit `feature: add stats endpoint`:

```
ghcr.io/your-username/luckypandarng:latest
ghcr.io/your-username/luckypandarng:1.2.0
ghcr.io/your-username/luckypandarng:v1.2.0
ghcr.io/your-username/luckypandarng:sha-abc1234
```

## Verify Deployment

```bash
# Check rollout status
kubectl rollout status deployment/luckypanda-rng

# View running pods
kubectl get pods -l app=luckypanda-rng

# Check deployed version
kubectl describe deployment luckypanda-rng | grep Image
```