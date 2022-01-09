# frozen_string_literal: true

require "local_ip_checker"
require "socket"

RSpec.describe LocalIPChecker do
  describe ".local_ip?" do
    let(:argument) { nil }

    shared_examples "it returns expected value" do |value|
      it { expect(described_class.local?(argument)).to eq(value) }
    end

    context "with provided valid URL" do
      before do
        allow(Addrinfo)
          .to receive(:getaddrinfo)
          .with(argument, any_args)
          .and_return(Addrinfo.getaddrinfo(resolved_ip, nil, nil, :STREAM))
      end

      let(:argument) { "suspicious-host.hack" }
      let(:resolved_ip) { nil }

      context "with allowed IPv4 address" do
        let(:resolved_ip) { "69.41.160.33" }

        it_behaves_like "it returns expected value", false
      end

      context "with allowed IPv6 address" do
        let(:resolved_ip) { "2001:0db8:85a3:0000:0000:8a2e:0370:7334" }

        it_behaves_like "it returns expected value", false
      end

      context "with allowed IPv4-mapped IPv6 address" do
        let(:resolved_ip) { "::ffff:15.52.165.12" }

        it_behaves_like "it returns expected value", false
      end

      context "with IPv4 localhost address" do
        let(:resolved_ip) { "127.0.0.1" }

        it_behaves_like "it returns expected value", true
      end

      context "with IPv4 0.0.0.0" do
        let(:resolved_ip) { "0.0.0.0" }

        it_behaves_like "it returns expected value", true
      end

      context "with IPv6 localhost address" do
        let(:resolved_ip) { "::" }

        it_behaves_like "it returns expected value", true
      end

      context "with local link address" do
        let(:resolved_ip) { "169.254.24.51" }

        it_behaves_like "it returns expected value", true
      end

      context "with private IPv4 address" do
        let(:resolved_ip) { "10.124.42.14" }

        it_behaves_like "it returns expected value", true
      end

      context "with private IPv6 address" do
        let(:resolved_ip) { "fd12:3456:789a:1::1" }

        it_behaves_like "it returns expected value", true
      end
    end

    context "with provided valid IP address" do
      context "with IPv4 0.0.0.0 address" do
        let(:argument) { "0.0.0.0" }

        it_behaves_like "it returns expected value", true
      end

      context "with IPv6 :: IP address" do
        let(:argument) { "::" }

        it_behaves_like "it returns expected value", true
      end

      context "with non-local IPv4 address" do
        let(:argument) { "126.0.0.124" }

        it_behaves_like "it returns expected value", false
      end
    end
  end
end
