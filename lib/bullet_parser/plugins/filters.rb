# frozen_string_literal: true

module BulletParser
  module Plugins
    class Filters
      def initialize(tokens)
        @tokens = tokens
        @filters = {}
        @uniq_root = nil
      end

      def exec
        filters = @filters.values
        tokens = @tokens.filter do |token|
          filters.all? { |filter| filter.call(token) }
        end

        if @uniq_root
          @uniq_root.call(tokens)
        else
          tokens
        end
      end

      def uniq_root
        @uniq_root = Proc.new { |tokens| tokens.uniq { |token| token.root_line } }
        self
      end

      def only_callstack
        @filters[:only_callstack] = Proc.new { |token| !token.callstack.nil? }
        self
      end
    end
  end
end
