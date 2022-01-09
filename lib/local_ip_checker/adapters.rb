# frozen_string_literal: true

require "resolv"

require "local_ip_checker/adapters/base"
require "local_ip_checker/adapters/domain"
require "local_ip_checker/adapters/ip_address"

module LocalIPChecker
  module Adapters
    DOMAIN_REGEX = /(\w+\.?)+/.freeze

    module_function

    def build(value)
      if value.match?(Resolv::IPv4::Regex) || value.match?(Resolv::IPv6::Regex)
        LocalIPChecker::Adapters::IPAddress
      elsif value.match?(DOMAIN_REGEX)
        LocalIPChecker::Adapters::Domain
      else
        raise "ValueError #{value}"
      end.new(value)
    end
  end
end
