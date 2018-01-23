# reviewdog
A code review dog who keeps your codebase healthy

[![wercker status](https://app.wercker.com/status/bykey/8a01c68eb445002007cab2fba4f2a12b/m/master "wercker status")](https://app.wercker.com/project/bykey/bykey/8a01c68eb445002007cab2fba4f2a12b)

# Options

- `exclude` (optional) Exclude certain files. Uses `grep -ve` to do the exclude.
- `threshold-warn` (optional) Number of lints which outputs as warning. default: 5
- `threshold-fail` (optional) Number of lints to allow. default: 10

# Examples

```yaml
build:
    steps:
        - blueoceans/reviewdog
```

Using an exclude filter:

```yaml
build:
    steps:
        - blueoceans/reviewdog
            exclude: "\.pb\.go"
```
