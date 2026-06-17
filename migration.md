# Migrating to ark Custom Resources

Ark is now a custom-resource-only cookbook. The `ark::default` recipe and `node['ark']` attributes have been removed.

## What Changed

* Declare `ark` and `ark_prereq` resources directly in your own recipes.
* Replace `node['ark']` defaults with explicit resource properties.
* Manage prerequisite packages with `ark_prereq` or with the `ark` resource's `package_dependencies` and `install_dependencies` properties.

## Attribute Replacements

| Removed attribute | Replacement |
| --- | --- |
| `node['ark']['prefix_root']` | `ark` property `prefix_root` |
| `node['ark']['prefix_bin']` | `ark` property `prefix_bin` |
| `node['ark']['prefix_home']` | `ark` property `prefix_home` |
| `node['ark']['package_dependencies']` | `ark_prereq` property `package_dependencies` or `ark` property `package_dependencies` |
| `node['ark']['tar']` | `ark` property `tar_binary` |
| `node['ark']['sevenzip_binary']` | `ark` property `sevenzip_binary` |

## Before

```ruby
include_recipe 'ark'

node.default['ark']['prefix_root'] = '/opt'
```

## After

```ruby
ark 'example' do
  url 'https://example.com/example.tar.gz'
  prefix_root '/opt'
  action :install
end
```

For custom prerequisites:

```ruby
ark_prereq 'example prerequisites' do
  package_dependencies %w(tar unzip xz)
end
```
