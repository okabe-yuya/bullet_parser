# frozen_string_literal: true

require_relative "bullet_parser/version"
require_relative "bullet_parser/tokenizer"
require_relative "bullet_parser/outputs"

module BulletParser
  def tokens(log_file_path)
    file = File.open(log_file_path, 'r')
    Tokenizer.new(file).exec
  end

  def save(tokens_, extension:, filename:)
    Outputs.save(tokens_, extension: extension, filename: filename)
  end

  module_function :tokens, :save
end
