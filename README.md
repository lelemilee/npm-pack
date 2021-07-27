# npm-pack

script to download npm packages and its respective dependency from `package.json` as \*.tgz files into artifacts/packages folder

# Prerequisite

- Bash
- Docker
- Python

# Quickstart

## Preparing npm packages in sharable format for upload

1. Update `package.json` using the template provided: `package-empty.json`
2. Run `download.sh`
3. Updated \*.tgz files will be stored in `./artifacts/packages`

## Uploading npm packages to your registry

1. Run `upload.sh $PRIVATE_REGISTRY`

# Contributors

[bladerail](https://github.com/bladerail)
[lelemilee](https://github.com/lelemilee)
