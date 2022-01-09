# frozen_string_literal: true

require "forwardable"

require "local_ip_checker/version"
require "local_ip_checker/executor"

module LocalIPChecker
  extend SingleForwardable

  def_delegators "LocalIPChecker::Executor", *%i[local? nonlocal?]
end
