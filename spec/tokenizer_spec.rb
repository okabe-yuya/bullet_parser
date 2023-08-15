# frozen_string_literal: true

require 'spec_helper'
require 'bullet_parser/tokenizer'

RSpec.describe BulletParser::Tokenizer do
  describe 'exec' do
    context 'with_callstack.log' do
      let(:with_callstack_log_path) { 'spec/logs/with_callstack.log' }

      it 'Only one token must return' do
        file = File.open(with_callstack_log_path)
        tokens = described_class.new(file).exec

        expect(tokens.size).to eq 1
      end

      it 'Successful parsing into tokens' do
        file = File.open(with_callstack_log_path)
        tokens = described_class.new(file).exec

        token = tokens.first
        expect(token.class).to eq BulletParser::Tokenizer::Token
        expect(token.detected_at).to eq '2023-08-15 15:20:31'
        expect(token.log_level).to eq 'WARN'
        expect(token.detected_user).to eq 'okabe'
        expect(token.http_method).to eq 'GET'
        expect(token.end_point).to eq '/api/v1/products/tags'
        expect(token.problem).to eq "USE eager loading detected\n  Product => [:product_tags]\n  Add to your query: .includes([:product_tags])\n"
        expect(token.root_line).to eq "  /Users/okabe/ruby/app/product_tags_controller.rb:18:in `map'\n"
        expect(token.callstack).to eq "  /Users/okabe/ruby/app/product_tags_controller.rb:18:in `map'\n  /Users/okabe/ruby/app/product_tags_controller.rb:18:in `block in <class:ProductTagsCotroller>'\n  /Users/okabe/ruby/spec/requests/products/tags_spec.rb:30:in `block (3 levels) in <main>'\n"
      end
    end

    context 'counter_cache.log' do
      let(:counter_cache_log_path) { 'spec/logs/counter_cache.log' }

      it 'Only one token must return' do
        file = File.open(counter_cache_log_path)
        tokens = described_class.new(file).exec

        expect(tokens.size).to eq 1
      end

      it 'Successful parsing into tokens' do
        file = File.open(counter_cache_log_path)
        tokens = described_class.new(file).exec

        token = tokens.first
        expect(token.class).to eq BulletParser::Tokenizer::Token
        expect(token.detected_at).to eq '2023-08-15 15:20:31'
        expect(token.log_level).to eq 'WARN'
        expect(token.detected_user).to eq 'okabe'
        expect(token.http_method).to eq 'GET'
        expect(token.end_point).to eq '/api/v1/products/tags'
        expect(token.problem).to eq "Need Counter Cache\n  Product => [:product_tags]\n"
        expect(token.root_line).to be_nil
        expect(token.callstack).to be_nil
      end
    end

    context 'multi.log' do
      let(:multi_log_path) { 'spec/logs/multi.log' }

      it 'Two token must return' do
        file = File.open(multi_log_path)
        tokens = described_class.new(file).exec

        expect(tokens.size).to eq 2
      end

      it 'Successful parsing into tokens' do
        file = File.open(multi_log_path)
        tokens = described_class.new(file).exec

        first_token = tokens[0]
        expect(first_token.class).to eq BulletParser::Tokenizer::Token
        expect(first_token.detected_at).to eq '2023-08-15 15:20:31'
        expect(first_token.log_level).to eq 'WARN'
        expect(first_token.detected_user).to eq 'okabe'
        expect(first_token.http_method).to eq 'GET'
        expect(first_token.end_point).to eq '/api/v1/products/tags'
        expect(first_token.problem).to eq "USE eager loading detected\n  Product => [:product_tags]\n  Add to your query: .includes([:product_tags])\n"
        expect(first_token.root_line).to eq "  /Users/okabe/ruby/app/product_tags_controller.rb:18:in `map'\n"
        expect(first_token.callstack).to eq "  /Users/okabe/ruby/app/product_tags_controller.rb:18:in `map'\n  /Users/okabe/ruby/app/product_tags_controller.rb:18:in `block in <class:ProductTagsCotroller>'\n  /Users/okabe/ruby/spec/requests/products/tags_spec.rb:30:in `block (3 levels) in <main>'\n"

        second_token = tokens[1]
        expect(second_token.class).to eq BulletParser::Tokenizer::Token
        expect(second_token.detected_at).to eq '2023-08-15 15:20:31'
        expect(second_token.log_level).to eq 'WARN'
        expect(second_token.detected_user).to eq 'okabe'
        expect(second_token.http_method).to eq 'GET'
        expect(second_token.end_point).to eq '/api/v1/products/tags'
        expect(second_token.problem).to eq "Need Counter Cache\n  Product => [:product_tags]\n"
        expect(second_token.root_line).to be_nil
        expect(second_token.callstack).to be_nil
      end
    end

    context 'empty.log' do
      let(:empty_log_path) { 'spec/logs/empty.log' }

      it 'Zero token must return' do
        file = File.open(empty_log_path)
        tokens = described_class.new(file).exec

        expect(tokens.size).to eq 0
      end
    end

    context 'large_size.log(log size is 100)' do
      let(:large_size_log_path) { 'spec/logs/large_size.log' }

      it '100 token must return' do
        file = File.open(large_size_log_path)
        tokens = described_class.new(file).exec

        expect(tokens.size).to eq 100
      end
    end
  end
end
