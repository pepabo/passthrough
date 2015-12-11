# Passthrough

This library provides a pass-through functionality using [net-ssh-gateway](https://github.com/jamis/net-ssh-gateway).

## Usage

```ruby
# Gateway setting
Passthrough.create(:db, 'gateway.example.com', 'readonly-user')

# Destination setting(host + port)
Passthrough.set(:db, :host, 'db.example.com')
Passthrough.set(:db, :port, 3306)

# Establish a connection for TCP port forwarding
Passthrough.open(:db)

# You can create multiple connections like below
Passthrough.create(:search, 'gateway.example.com', 'readonly-user')
Passthrough.set(:search, :host, 'search.example.com')
Passthrough.set(:search, :port, 8983)

# Same as above
Passthrough.open(:search)
```

Use the sets of host and port in some config file.

`database.yml` of Rails:

```yaml
remote:
  database: example_database
  username: readonly_user
  password: ****************
  host:     <%= Passthrough.get(:db, :host) %>
  port:     <%= Passthrough.get(:db, :port) %>
```

`sunspot.yml` for Solr:

```yaml
remote:
  solr:
    hostname: <%= Passthrough.get(:search, :host) %>
    port:     <%= Passthrough.get(:search, :port) %>
```

## Description

Servers such as database or search engine are usually in a local network where you can't access directly. You, however, often want to access them from your local machine, for example, to collect production data for inquiry.

To solve the problem, TCP port forwarding through SSH connection works fine.

```sh
$ ssh -L 12345:db.example.com:3306 gateway.example.com
```

This line creates so-called a pass-through which forwards the connection to `127.0.01:12345` to `db.example.com:3306` via `gateway.example.com`.

This library allows you to do the same as above in a programmatic way.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pepabo/passthrough. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Authors

* Takatoshi Ono
* Kentaro Kuribayashi
