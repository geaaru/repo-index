BACKEND?=dockerv3
CONCURRENCY?=1
CI_ARGS?=
PACKAGES?=

# Abs path only. It gets copied in chroot in pre-seed stages
export LUET?=/usr/bin/luet-build
export ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DESTINATION?=$(ROOT_DIR)/build
COMPRESSION?=zstd
CLEAN?=false
export TREE?=$(ROOT_DIR)/packages
BUILD_ARGS?=--no-spinner --image-repository geaaru/rindex-amd64-cache
GENIDX_ARGS?=--only-upper-level --compress=false
CONFIG?= --config conf/luet.yaml
REPO_NAME?=geaaru-index
REPO_DESC?="Macaroni OS Repositories"
REPO_URL?="https://dl.macaronios.org/repos/geaaru-repo-index"

SUDO?=
VALIDATE_OPTIONS?=-s

.PHONY: all
all: deps build

.PHONY: clean
clean:
	$(SUDO) rm -rf build/ *.tar *.metadata.yaml

.PHONY: build
build: clean
	mkdir -p $(ROOT_DIR)/build
	$(SUDO) $(LUET) build $(CONFIG) $(BUILD_ARGS) --tree=$(TREE)  $(PACKAGES) --destination $(DESTINATION) --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: build-all
build-all: clean
	mkdir -p $(ROOT_DIR)/build
	$(SUDO) $(LUET) build $(CONFIG) $(BUILD_ARGS)  --tree=$(TREE) --full --destination $(DESTINATION) --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: rebuild
rebuild:
	$(SUDO) $(LUET) build $(CONFIG) $(BUILD_ARGS) --tree=$(TREE) $(PACKAGES) --destination $(DESTINATION) --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: rebuild-all
rebuild-all:
	$(SUDO) $(LUET) build $(CONFIG) $(BUILD_ARGS) --tree=$(TREE) --full --destination $(DESTINATION) --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: genidx
genidx:
	$(SUDO) $(LUET) tree genidx $(GENIDX_ARGS) --tree=$(TREE)

.PHONY: create-repo
create-repo: genidx
	$(SUDO) $(LUET) create-repo $(CONFIG) --tree "$(TREE)" \
    --output $(DESTINATION) \
    --packages $(DESTINATION) \
    --name "$(REPO_NAME)" \
    --descr "$(REPO_DESC)" \
    --urls "$(REPO_URL)" \
    --tree-compression $(COMPRESSION) \
    --tree-filename tree.tar.zst \
    --with-compilertree \
    --type http

.PHONY: serve-repo
serve-repo:
	LUET_NOLOCK=true $(LUET) serve-repo --port 8000 --dir $(ROOT_DIR)/build

validate:
	$(LUET) tree validate --tree $(TREE) $(VALIDATE_OPTIONS)
