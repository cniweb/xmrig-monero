# XMRig Docker Container

XMRig is a high performance, open source RandomX, CryptoNight, AstroBWT and Argon2 CPU/GPU miner packaged as a Docker container with strong security practices and multi-registry deployment.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Build and Test the Repository:
- `docker build . -t cniweb/xmrig:test --file Dockerfile` -- NEVER CANCEL: takes ~10 seconds fresh build, sub-second with cache. Set timeout to 30+ seconds.
- `./build.sh build-only` -- builds and runs security checks. NEVER CANCEL: takes ~1 second with cache. Set timeout to 60+ seconds for fresh builds.
- Test the container: `docker run --rm cniweb/xmrig:test --version` -- should output XMRig 6.24.0 version info
- Validate functionality: `docker run --rm cniweb/xmrig:test --dry-run` -- validates configuration without mining

### Alternative Secure Build (Multi-stage):
- `docker build . -t cniweb/xmrig:secure --file Dockerfile.secure` -- NEVER CANCEL: takes ~9 seconds. Set timeout to 30+ seconds.
- Test: `docker run --rm cniweb/xmrig:secure /usr/local/bin/xmrig --version`

### Security Validation:
- `./security-check.sh` -- runs comprehensive security checks on container
- ALWAYS run security checks after making changes to Dockerfile or configuration
- All containers run as non-root user (uid=1000) and use non-privileged port 8080

## Validation

### CRITICAL: Always Manually Validate Mining Container Functionality
After making any changes to Docker configuration, XMRig settings, or build scripts:

1. **Build Test**: `docker build . -t cniweb/xmrig:test`
2. **Version Test**: `docker run --rm cniweb/xmrig:test --version` -- verify XMRig 6.24.0 output
3. **Help Test**: `docker run --rm cniweb/xmrig:test --help` -- verify full options display
4. **Config Test**: `docker run --rm cniweb/xmrig:test --dry-run` -- verify config validation passes
5. **Security Test**: `./security-check.sh` -- verify all security checks pass

### User Scenarios to Test:
- **Basic Container Run**: Container starts and shows XMRig version information
- **Configuration Validation**: Dry run validates mining pool configuration without connecting
- **Security Posture**: Container runs as non-root user with proper file permissions
- **Multi-Registry Support**: Build script can tag images for multiple container registries

## Common Tasks

### Repository Structure
```
.
├── README.md              # Project documentation
├── Dockerfile             # Standard production container
├── Dockerfile.secure      # Multi-stage secure container variant  
├── build.sh              # Main build script with multi-registry support
├── security-check.sh     # Container security validation script
├── config.json          # XMRig mining configuration
├── start_zergpool.sh     # Mining pool startup script
├── .github/
│   ├── workflows/
│   │   ├── docker-build.yml           # CI/CD build and deploy
│   │   ├── docker-image.yml           # Additional Docker workflow
│   │   └── snyk-container-analysis.yml # Security scanning
│   └── dependabot.yml    # Dependency updates
├── SECURITY.md           # Security policy and best practices
└── LICENSE              # Apache 2.0 license
```

### Build Script Capabilities:
- **Standard Build**: `./build.sh build-only` -- builds without pushing to registries
- **Full Deploy**: `./build.sh` -- builds and pushes to Docker Hub, GitHub Container Registry, Quay.io
- **Dockerfile Variants**: Set `DOCKERFILE=Dockerfile.secure` for multi-stage build
- **Version Control**: Version is defined in build.sh (currently 6.24.0)

### Container Registries:
- **Docker Hub**: `docker.io/cniweb/xmrig`
- **GitHub Container Registry**: `ghcr.io/cniweb/xmrig` 
- **Quay.io**: `quay.io/cniweb/xmrig`

### Available Tags:
- `latest` -- Latest stable build from main branch
- `6.24.0` -- Version-specific tag
- `<commit-sha>` -- Specific commit versions

### Configuration Files:
- **config.json**: XMRig configuration with pool settings, CPU options, and API settings
- **start_zergpool.sh**: Shell script for starting mining with environment variables
- Environment variables: `ALGO`, `POOL_ADDRESS`, `WALLET_USER`, `PASSWORD`

### GitHub Actions Workflows:
- **docker-build.yml**: NEVER CANCEL: Full CI/CD pipeline takes ~2-5 minutes including multi-registry push
- **snyk-container-analysis.yml**: Security scanning with SARIF output processing  
- Workflows run on: push to main, pull requests, scheduled security scans

### Security Features:
- Non-root execution (uid=1000, user=xmrig)
- Non-privileged port usage (8080)
- Minimal base image (debian:bookworm-slim)
- No hardcoded secrets in environment variables
- Comprehensive security validation via security-check.sh

## Development Workflow

### Making Changes:
1. **Edit Files**: Modify Dockerfile, configuration, or scripts
2. **Build**: `./build.sh build-only` -- NEVER CANCEL: Set timeout 60+ seconds
3. **Test**: Run all validation scenarios above
4. **Security Check**: `./security-check.sh` 
5. **CI/CD**: Push triggers automatic build and security scanning

### Common Issues:
- **Build Warning**: "SecretsUsedInArgOrEnv" warning for PASSWORD env var is expected and acceptable for this mining application
- **Security Check**: If hardcoded tokens detected, review config.json for JWT tokens that should be null. Some environment/Docker runtime issues may cause security check false positives.
- **Port Exposure**: Always use port 8080 (non-privileged) not port 80
- **Container Runtime**: If security checks fail with runtime errors, this is typically due to environment constraints and doesn't indicate actual security issues

### Performance Notes:
- **Initial builds**: 9-10 seconds for fresh builds depending on network for XMRig binary download
- **Cached builds**: Sub-second with Docker layer caching
- **Security checks**: Near-instantaneous for running containers
- **CI/CD pipeline**: 2-5 minutes for full multi-registry deployment

## Key Project Information

### Mining Configuration:
- **Default Algorithm**: Ghostrider (gr)
- **Default Pool**: Zergpool (ghostrider.mine.zergpool.com:5354)
- **CPU Threading**: Auto-detected based on available cores
- **API**: HTTP API enabled on port 8080 with access token

### Dependencies:
- **Base OS**: Debian Bookworm Slim
- **XMRig Version**: 6.24.0 (pre-compiled binary)
- **Key Libraries**: libuv/1.51.0, OpenSSL/3.0.16, hwloc/2.12.1
- **Build Tools**: Docker only (no local compilation required)

### License and Compliance:
- **License**: Apache License 2.0
- **Security Policy**: See SECURITY.md for vulnerability reporting
- **Container Scanning**: Automated via Snyk with SARIF upload to GitHub Security

ALWAYS follow these validation steps and timing guidelines to ensure reliable development in this cryptocurrency mining container project.