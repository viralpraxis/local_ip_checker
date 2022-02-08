# Local IP Checker

Simple ruby gem that provides checking if given URL resolves to local IPv4/IPv6 address.

## Abstract

If your system makes HTTP requests to an URL provided by 3rd-party it's important to check if this URL resolves to some kind of local IP address. This gem performs checks against the following types of local IP addresses:

1. IPv4 and IPv6 localhost addresses.
2. IPv4 `0.0.0.0` and IPv6 `::` addresses.
3. IPv4 private address ranges (e. g. `10.0.0.0/8`).
4. IPv6 unique local addresses (`fc00::/7`).
5. IPv6 site-local address (`fec0::/10`)
6. IPv4 and IPv6 link-local addresses.

## Usage

Example:
```ruby
require "local_ip_checker"

LocalIPChecker.local?("google.com") # => false
LocalIPChecker.nonlocal?("google.com") => true
LocalIPChecker.local?("localhost") => true
LocalIPChecker.local?("::") # => true
```
