This plugin is no longer maintained, plz use https://github.com/Fbrisset/asdf-pandoc

<div align="center">

# asdf-pandoc [![Build](https://github.com/sys9kdr/asdf-pandoc/actions/workflows/build.yml/badge.svg)](https://github.com/sys9kdr/asdf-pandoc/actions/workflows/build.yml) [![Lint](https://github.com/sys9kdr/asdf-pandoc/actions/workflows/lint.yml/badge.svg)](https://github.com/sys9kdr/asdf-pandoc/actions/workflows/lint.yml)

[pandoc](https://github.com/jgm/pandoc) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `git`, `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add pandoc https://github.com/sys9kdr/asdf-pandoc.git
```

pandoc:

```shell
# Show all installable versions
asdf list-all pandoc

# Install specific version
asdf install pandoc latest

# Set a version globally (on your ~/.tool-versions file)
asdf global pandoc latest

# Now pandoc commands are available
pandoc --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/sys9kdr/asdf-pandoc/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Daiki Noda](https://github.com/sys9kdr/)
