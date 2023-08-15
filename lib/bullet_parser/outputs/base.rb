# frozen_string_literal: true

require_relative "../outputs"

module BulletParser
  module Outputs
    class Base
      def initialize(tokens)
        @tokens = tokens
      end

      def save
        raise NotImplementedError.new("No implemnted #{self.class}##{__method__}")
      end
    end
  end
end
