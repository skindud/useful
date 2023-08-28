# Linters

## others
```bash
docker run --rm -it -v "$PWD:/workdir" -w /workdir nexus.inno.tech:19101/dbp/image/ansible:1.0.1 ansible-lint -p --force-color /workdir
docker run -e RUN_LOCAL=true -e USE_FIND_ALGORITHM=true -v $(pwd):/tmp/lint github/super-linter
docker run --rm -v "$PWD:/workdir" -w /workdir <terraform-img> terraform fmt -check -recursive --diff
docker run --rm -it -v $(pwd):/data cytopia/yamllint .
```
