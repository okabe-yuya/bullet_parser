# frozen_string_literal: true

require_relative "outputs/csv"

module BulletParser
  module Outputs
    def save(tokens, extension:, filename:)
      case extension
      when :csv
        Csv.new(tokens).save(filename)
      end
    end

    module_function :save
  end
end
