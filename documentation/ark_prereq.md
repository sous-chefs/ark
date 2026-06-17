# ark_prereq

Installs platform prerequisites used by the `ark` resource to fetch and extract archives.

## Actions

| Action | Description |
| --- | --- |
| `:install` | Installs prerequisite packages or the Windows 7-Zip tool. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | String | name property | Resource name used for package resource labeling. |
| `package_dependencies` | Array | platform default | Packages required for archive extraction on the target platform. |

## Examples

### Install Platform Defaults

```ruby
ark_prereq 'default'
```

### Install Custom Dependencies

```ruby
ark_prereq 'minimal' do
  package_dependencies %w(tar unzip)
end
```
