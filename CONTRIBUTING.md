# Contributing Guide
## Hướng Dẫn Đóng góp

Thank you for your interest in contributing to the PostgreSQL Engineering Roadmap! This guide will help you understand how to contribute effectively.

Cảm ơn bạn vì quan tâm đóng góp vào Lộ trình Kỹ thuật PostgreSQL! Hướng dẫn này sẽ giúp bạn hiểu cách đóng góp một cách hiệu quả.

---

## 📋 Before You Start / Trước Khi Bắt Đầu

1. **Read the Documentation**: Familiarize yourself with [ARCHITECTURE.md](ARCHITECTURE.md) and [SETUP.md](SETUP.md)
2. **Understand the Goals**: This is a production-grade PostgreSQL engineering resource, not a basic tutorial
3. **Check Existing Issues**: Review open issues to avoid duplicate work
4. **Sign the CLA** (if applicable): Ensure legal compliance

---

## 🚀 How to Contribute

### 1. Report a Bug

**Create an Issue** with the following information:

```
Title: [BUG] Descriptive title

System: OS version, Docker version, PostgreSQL version
Issue: Clear description of the problem
Steps to Reproduce:
  1. ...
  2. ...
  3. ...
Logs: Paste relevant error output
Expected: What should happen
Actual: What actually happened
```

### 2. Suggest an Enhancement

**Create an Issue** with:

```
Title: [ENHANCEMENT] Feature description

Objective: What feature/improvement is needed?
Use Case: Why is this needed?
Proposed Solution: How should it work?
Example: Code sample or mock output
```

### 3. Contribute Code

#### Small Changes (Bug Fixes, Documentation)

1. **Fork the repository**
2. **Create a branch**: `git checkout -b fix/issue-123-description`
3. **Make changes**: Ensure quality and follow conventions (see below)
4. **Commit**: Use clear, descriptive commit messages
   ```bash
   git commit -m "fix: resolve connection timeout in wal_pitr_restore_lab.sh
   
   - Add 30s timeout for pg_ctl startup
   - Add retry logic for pg_isready checks
   - Fixes #123"
   ```
5. **Push**: `git push origin fix/issue-123-description`
6. **Create Pull Request**: Link related issues

#### Large Changes (New Labs, Features, Documentation)

1. **Create an Issue first**: Discuss your proposal before coding
2. **Wait for approval**: Maintainers will review and provide feedback
3. **Create a branch**: `git checkout -b feature/new-lab-description`
4. **Implement**: Follow the coding standards below
5. **Test thoroughly**: Run scripts locally, validate YAML, etc.
6. **Submit PR**: Reference the discussion issue

---

## 📐 Coding Standards

### Shell Scripts (.sh)

**Template:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Script: descriptive_name.sh
# Purpose: Clear one-line description
# Usage: ./descriptive_name.sh [OPTIONS]

# Trap errors for cleanup
trap 'echo "Error on line $LINENO"; exit 1' ERR

# Configuration with sensible defaults
VAR=${VAR:-default_value}

# Main logic
echo "Starting task..."
# ... implementation ...
echo "Task completed successfully."
```

**Requirements:**
- ✅ Use `set -euo pipefail` for error handling
- ✅ Include header comments (purpose, usage)
- ✅ Use `trap` for cleanup
- ✅ Validate input parameters
- ✅ Provide helpful error messages
- ✅ Make scripts idempotent where possible

### SQL Scripts (.sql)

**Template:**
```sql
-- ========================================================
-- Script: descriptive_name.sql
-- Purpose: Clear description of what this script does
-- Usage: psql -f descriptive_name.sql
-- Requirements: PostgreSQL 16+
-- ========================================================

-- Check prerequisites
CREATE EXTENSION IF NOT EXISTS vector;

-- Main logic
CREATE TABLE IF NOT EXISTS example_table (
    id BIGSERIAL PRIMARY KEY,
    data TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Output verification
SELECT COUNT(*) as table_count FROM information_schema.tables 
WHERE table_schema = 'public';
```

**Requirements:**
- ✅ Include descriptive header comments
- ✅ Use `IF NOT EXISTS` for idempotency
- ✅ Include output verification queries
- ✅ Document any dependencies (extensions, tables)
- ✅ Use consistent formatting (spaces around =, commas, etc.)

### Markdown Documentation (.md)

**Template:**
```markdown
# Title (Short & Descriptive)

## Overview / Tổng quan
- Brief introduction (EN + VN)
- Target audience

## Prerequisites / Yêu cầu
- Tools needed
- System requirements

## Implementation / Triển khai
### Step 1: Setup
```bash
command example
```

### Step 2: Execute
Steps with code examples

## Verification / Kiểm thử
How to verify success

## Troubleshooting / Xử lý sự cố
Common issues and solutions

## References / Tài liệu tham khảo
- Links to related docs
```

**Requirements:**
- ✅ Use bilingual headings (EN / VN)
- ✅ Include practical code examples
- ✅ Add verification steps
- ✅ Include troubleshooting section
- ✅ Link to related documentation

### YAML Files (Docker Compose, Kubernetes)

**Requirements:**
- ✅ Use 2-space indentation (not tabs)
- ✅ Include comments explaining each section
- ✅ Define resource limits for all containers
- ✅ Include health checks for services
- ✅ Use environment variable interpolation where applicable

**Example:**
```yaml
services:
  postgres:
    # PostgreSQL 16 Alpine image
    image: postgres:16-alpine
    container_name: pg_engineering_lab
    environment:
      POSTGRES_USER: engineer
      POSTGRES_PASSWORD: engineering_secret
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    # Health check ensures readiness
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U engineer"]
      interval: 10s
      timeout: 5s
      retries: 5
    # Resource limits prevent container sprawl
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
```

---

## 📝 Pull Request Process

### Before Submitting

1. **Code Quality**
   - Run `shellcheck` on shell scripts: `shellcheck *.sh`
   - Run `yamllint` on YAML files: `yamllint -d relaxed *.yml`
   - Verify SQL syntax locally

2. **Testing**
   - Test your changes locally
   - For lab scripts: run against actual PostgreSQL
   - For docs: verify links and formatting

3. **Documentation**
   - Update README if adding new sections
   - Add comments in code
   - Include examples in PR description

### PR Description Template

```markdown
## Description
Brief description of changes

## Related Issue
Fixes #123
Related to #456

## Type of Change
- [ ] Bug fix (non-breaking)
- [ ] New feature (non-breaking)
- [ ] Documentation update
- [ ] New lab or example

## Testing Done
- [ ] Tested locally on Docker
- [ ] Validated YAML/SQL syntax
- [ ] Ran lab scripts successfully

## Checklist
- [ ] Code follows project style guidelines
- [ ] Documentation updated
- [ ] Comments added for complex logic
- [ ] No hardcoded credentials
- [ ] Files validated (.sh, .yml, .sql)
```

### Review Process

1. **Maintainer Review**: Code review for quality and correctness
2. **Feedback**: Maintainers may request changes
3. **Approval**: Once approved, PR can be merged
4. **Merge**: Maintainer merges the PR

---

## 🎯 Contribution Areas

### 🔥 High Priority
- Fix reported issues and bugs
- Add missing lab scripts
- Improve documentation clarity
- Add resource limits to manifests

### 📚 Medium Priority
- Write additional examples
- Improve troubleshooting docs
- Add performance tuning tips
- Create advanced lab scenarios

### 🌟 Nice-to-Have
- Add diagrams (Mermaid, draw.io)
- Create video tutorials
- Add performance benchmarks
- Contribute to related projects

---

## 🚫 What NOT to Contribute

- ❌ Sensitive information (credentials, API keys, passwords)
- ❌ Large data files (> 1MB)
- ❌ Third-party proprietary code without permission
- ❌ Unrelated to PostgreSQL engineering
- ❌ Non-production-grade examples
- ❌ Hard-coded values instead of environment variables

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License (see [LICENSE](LICENSE)).

---

## ❓ Questions?

- **Documentation**: Check [SETUP.md](SETUP.md) and [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Discussions**: Open a GitHub Discussion
- **Issues**: Create an Issue with your question

---

## 🙏 Thank You!

Thank you for contributing to making PostgreSQL engineering more accessible and practical!

---

**Last Updated:** May 2024
**Version:** 1.0
