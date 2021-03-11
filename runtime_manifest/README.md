## `dependabot-runtime-manifest`

Runtime manifest support for [`dependabot-core`][core-repo].

### Running locally

1. Install Ruby dependencies
   ```
   $ bundle install
   ```

2. Run tests
   ```
   $ bundle exec rspec spec
   ```

**Note:** Integration tests will not pass without environment variables set or passed in.

[core-repo]: https://github.com/dependabot/dependabot-core

### Building and installing the gem

1. Build the gem
    ```
    $ gem build dependabot-runtime-manifest
    ```
2. Install the gem
    ```
    $ gem install dependabot-runtime-manifest
    ```
