# frozen_string_literal: true

require "socket"

module LocalIPChecker
  class Executor
    HOST_IP_ADDRESSES = (%w[0.0.0.0 ::] + Socket.ip_address_list.map(&:ip_address)).freeze
    IPV6_LINKLOCAL_ADDRESSES = IPAddr.new("169.254.0.0/16").freeze

    class << self
      def local?(value)
        new(value).local?
      end

      def nonlocal?(value)
        !local?(value)
      end
    end

    def initialize(value)
      @value = value
    end

    def local?
      Enumerator.new do |enum|
        enum << localhost?
        enum << loopback?
        enum << local_network?
        enum << link_local?
      end.any?(&:itself)
    end

    private

    attr_reader :value

    def localhost?
      (HOST_IP_ADDRESSES & resolved_ips.map(&:ip_address)).any?
    end

    def loopback?
      check_ips { |ip| ip.ipv4_loopback? || ip.ipv6_loopback? }
    end

    def local_network?
      check_ips { |ip| ip.ipv4_private? || ip.ipv6_sitelocal? || ip.ipv6_unique_local? }
    end

    def link_local?
      check_ips { |ip| ip.ipv6_linklocal? || IPV6_LINKLOCAL_ADDRESSES.include?(ip.ip_address) }
    end

    def check_ips(&block)
      resolved_ips.any?(&block)
    end

    def resolved_ips
      @resolved_ips ||=
        Addrinfo.getaddrinfo(value, 80, nil, :STREAM).map do |ip|
          ip.ipv6_v4mapped? ? ip.ipv6_to_ipv4 : ip
        end
    end
  end
end
