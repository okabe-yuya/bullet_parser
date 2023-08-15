# frozen_string_literal: true

require_relative "base"

module BulletParser
  module Outputs
    class Csv < Base
      def save(filename)
        require 'csv'

        CSV.open(filename, 'wb') do |csv|
          csv << header
          @tokens.each do |token|
            csv << [
              token.detected_at,
              token.log_level,
              token.detected_user,
              token.http_method,
              token.end_point,
              token.problem,
              token.root_line,
              token.callstack
            ]
          end
        end

        :ok
      end

      private

      def header
        Tokenizer::Token.members.map(&:to_s)
      end
    end
  end
end
