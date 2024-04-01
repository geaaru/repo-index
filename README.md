<p align="center">
  <img src="https://github.com/macaroni-os/macaroni-site/blob/master/site/static/images/logo.png">
</p>

# Macaroni OS Repositories index (AKA Geaaru Repox Index)

This repository it is automatically built and contains different Anise repositories packages.

You can also build this repo locally if you wish:
```sh
$ make deps
$ LUET=$GOPATH/bin/luet make build-all create-repo
```
To consume this repository with Luet, add in the `luet.yaml`:

```yaml
repositories:
- name: "geaaru-repo-index"
  description: "Geaaru Repository index"
  type: "http"
  enable: true
  cached: true
  priority: 1
  urls:
  - "https://raw.githubusercontent.com/geaaru/repo-index/gh-pages"
```

or create this file under luet repositories dir (/etc/luet/repos.conf.d/geaaru-repo-index.yml):

```yaml
name: "geaaru-repo-index"
description: "Geaaru Repository Index"
type: "http"
enable: true
cached: true
priority: 1
urls:
- "https://raw.githubusercontent.com/geaaru/repo-index/gh-pages"
```

