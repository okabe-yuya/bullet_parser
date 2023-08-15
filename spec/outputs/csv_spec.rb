# frozen_string_literal: true

require 'spec_helper'
require 'bullet_parser/tokenizer'
require 'bullet_parser/outputs/csv'

require 'securerandom'

RSpec.describe BulletParser::Outputs::Csv do
  describe 'save' do
    let(:with_callstack_log_path) { 'spec/logs/with_callstack.log' }

    def common_exec(log_file_path)
      file = File.open(log_file_path)
      tokens = BulletParser::Tokenizer.new(file).exec

      timestamp_with_uuid = "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{SecureRandom.uuid}"
      saved_path = "spec/logs/tmp/#{timestamp_with_uuid}.csv"
      described_class.new(tokens).save(saved_path)

      [tokens, saved_path]
    end

    context 'Headers' do
      it 'Header size is 8' do
        _, saved_path = common_exec(with_callstack_log_path)
        CSV.foreach(saved_path) do |row|
          expect(row.size).to eq 8
          break
        end
      end

      it 'Header must be equal Tokenizer::Token fields' do
        _, saved_path = common_exec(with_callstack_log_path)
        CSV.foreach(saved_path) do |row|
          expect_row = [
            'detected_at',
            'log_level',
            'detected_user',
            'http_method',
            'end_point',
            'problem',
            'root_line',
            'callstack',
          ]
          expect(row).to eq expect_row
          break
        end
      end
    end

    context 'body' do
      it 'Csv body Must be include Token fields infomations' do
        tokens, saved_path = common_exec(with_callstack_log_path)
        token_at = 0
        CSV.foreach(saved_path, headers: true) do |row|
          expect(row['detected_at']).to eq tokens[token_at].detected_at
          expect(row['log_level']).to eq tokens[token_at].log_level
          expect(row['detected_user']).to eq tokens[token_at].detected_user
          expect(row['http_method']).to eq tokens[token_at].http_method
          expect(row['end_point']).to eq tokens[token_at].end_point
          expect(row['problem']).to eq tokens[token_at].problem
          expect(row['root_line']).to eq tokens[token_at].root_line
          expect(row['callstack']).to eq tokens[token_at].callstack
          token_at += 1
        end
      end
    end
  end
end
