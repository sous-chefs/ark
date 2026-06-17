# ark

Manages software archive download, extraction, optional build/configure steps, and convenience links.

## Actions

| Action | Description |
| --- | --- |
| `:install` | Downloads, extracts, creates a friendly home link, and optionally links binaries. |
| `:put` | Downloads and extracts the archive into the requested path without creating home links. |
| `:dump` | Extracts archive contents into the requested path. |
| `:unzip` | Extracts zip-compatible archives into the requested path. |
| `:cherry_pick` | Extracts a specific file from an archive. |
| `:install_with_make` | Extracts, configures, builds, and runs `make install`. |
| `:setup_py_build` | Extracts and runs `python setup.py build`. |
| `:setup_py_install` | Extracts and runs `python setup.py install`. |
| `:setup_py` | Extracts and runs `python setup.py`. |
| `:configure` | Extracts and runs autogen/configure steps. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | String | name property | Archive name. |
| `owner` | String | platform default | Owner for extracted content. |
| `group` | String, Integer | `0` | Group for extracted content. |
| `url` | String | required | Remote URL or `file://` URL for the archive. |
| `path` | String | action-specific | Extraction path. |
| `full_path` | String | `nil` | Deprecated compatibility property. |
| `append_env_path` | true, false | `false` | Adds the extracted `bin` directory to PATH. |
| `checksum` | String | `nil` | SHA-256 checksum for the archive. |
| `has_binaries` | Array | `[]` | Relative binary paths to link into `prefix_bin`. |
| `creates` | String | `nil` | File used as an extraction guard for selective actions. |
| `release_file` | String | generated | Local cache path for the downloaded archive. |
| `strip_leading_dir` | true, false, nil | `nil` | Deprecated strip behavior compatibility property. |
| `strip_components` | Integer | `1` | Number of leading archive path components to strip. |
| `mode` | Integer, String | `0755` | Mode for created directories. |
| `prefix_root` | String | `/usr/local` | Base path for versioned installs. |
| `prefix_home` | String | `/usr/local` | Base path for friendly home links. |
| `prefix_bin` | String | `/usr/local/bin` | Directory where binary links are created. |
| `version` | String | `1` | Archive version used in generated paths. |
| `home_dir` | String | generated | Friendly symlink path for install actions. |
| `win_install_dir` | String | `nil` | Windows install path override. |
| `environment` | Hash | `{}` | Environment for extraction and build commands. |
| `autoconf_opts` | Array | `[]` | Options passed to `configure`. |
| `make_opts` | Array | `[]` | Options passed to `make` and `make install`. |
| `extension` | String | inferred | Archive extension when it cannot be inferred from the URL. |
| `package_dependencies` | Array | platform default | Packages installed by `ark_prereq`. |
| `install_dependencies` | true, false | `true` | Whether to install prerequisite packages. |
| `tar_binary` | String | platform default | Tar binary path. |
| `sevenzip_binary` | String | registry/platform default | 7-Zip binary path on Windows. |
| `backup` | false, Integer | `5` | Backup count passed to `remote_file`. |

## Examples

### Basic Install

```ruby
ark 'ivy' do
  url 'https://example.com/ivy.tar.gz'
  version '2.2.0'
  checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
  action :install
end
```

### Extract To A Directory

```ruby
ark 'my_jars' do
  url 'https://example.com/bunch_of_jars.zip'
  path '/usr/local/tomcat/lib'
  creates 'mysql.jar'
  action :dump
end
```
