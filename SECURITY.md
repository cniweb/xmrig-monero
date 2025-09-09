# Security Policy

## Supported Versions

Use this section to tell people about which versions of your project are
currently being supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 6.24.x  | :white_check_mark: |
| < 6.0   | :x:                |

## Security Features

This Docker image implements several security best practices:

### Container Security
- **Non-root execution**: Container runs as unprivileged user (uid=1000)
- **Non-privileged ports**: Uses port 8080 instead of privileged port 80
- **Minimal base image**: Uses debian:bookworm-slim for reduced attack surface
- **No hardcoded secrets**: Removed hardcoded JWT tokens and passwords
- **Proper file ownership**: All files owned by non-root user

### Build Security
- **Dependency management**: Minimal package installation with cleanup
- **SSL verification**: Secure download of XMRig binaries
- **Build context optimization**: .dockerignore to reduce build context

### Runtime Security
- **Environment variable configuration**: Sensitive data via environment variables
- **Resource isolation**: Proper user/group separation
- **Signal handling**: Proper ENTRYPOINT for signal propagation

## Reporting a Vulnerability

If you discover a security vulnerability within this project, please follow these steps:

1. **Do not** open a public issue
2. Send an email to the repository maintainer
3. Include as much information as possible about the vulnerability
4. Allow time for the vulnerability to be addressed before public disclosure

## Security Best Practices for Users

When using this Docker image:

1. **Use environment variables** for sensitive configuration
2. **Run with limited privileges** - avoid `--privileged` flag
3. **Use Docker secrets** for production deployments
4. **Keep the image updated** to get latest security fixes
5. **Monitor for vulnerabilities** using container scanning tools
6. **Use specific version tags** instead of `latest` in production