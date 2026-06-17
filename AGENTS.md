# AGENTS.md

## Cookbook Purpose

The ark cookbook provides custom resources for fetching, unpacking, and optionally building software archives that are not managed as native OS packages. The public API is the `ark` resource for archive workflows and the `ark_prereq` resource for prerequisite package installation.

## Agent Findings

* Full custom resource migration removes the public `ark::default` recipe and node attribute API. Use resource properties such as `prefix_root`, `prefix_home`, `prefix_bin`, `package_dependencies`, `tar_binary`, and `sevenzip_binary` instead.
* Archive fixtures under `files/default` are intentional. They keep Kitchen coverage deterministic and avoid depending on external TLS endpoints while testing a cookbook whose domain is archive extraction.
* Windows local archive URLs must use canonical file URI form (`file:///C:/path/archive.tar.gz`). The `ark` resource normalizes `file://C:/...` to that form before passing it to `remote_file`.
* The Kitchen `default` suite exercises Linux, macOS, and Unix-style archive workflows through `test::default`. The `windows` suite runs separately through `test::windows` on the GitHub Windows runner.

## Package Availability

Ark does not install a vendor product from upstream package repositories. It installs platform prerequisites used to download and unpack archives.

### APT (Debian/Ubuntu)

* Uses distribution packages such as `libtool`, `autoconf`, `ca-certificates`, `make`, `unzip`, `rsync`, `gcc`, `autogen`, `bzip2`, `xz-utils`, `shtool`, and `pkg-config`.

### DNF/YUM (RHEL family)

* Uses distribution packages such as `autoconf`, `automake`, `bzip2`, `gcc`, `make`, `rsync`, `tar`, `unzip`, `xz`, and related platform defaults.

### Zypper (SUSE)

* Uses distribution packages such as `autoconf`, `automake`, `bzip2`, `gcc`, `make`, `rsync`, `tar`, `unzip`, and `xz`.

## Architecture Limitations

No architecture-specific vendor packages are managed by this cookbook. Archive compatibility depends on the archive supplied by the caller and the extraction/build tools available on the target node.

## Source/Compiled Installation

The `ark` resource can run `configure`, `make`, `make install`, and Python `setup.py` actions after extraction. Callers are responsible for product-specific build dependencies beyond ark's generic prerequisite packages.

## Known Issues

* The `:remove` action remains documented as TODO and is not implemented by the migrated resource.
* `:dump` is documented as zip-oriented behavior and should be expanded carefully if tar dump semantics are changed.

## Test and CI Notes

* Linux CI uses Dokken via `kitchen.dokken.yml`.
* macOS and Windows CI use the exec driver via `kitchen.exec.yml`.
* Unit tests use `spec/fixtures/cookbooks/ark_spec`; Kitchen integration uses `test/cookbooks/test`.
