# frozen_string_literal: true

module BulletParser
  class Tokenizer
    ##############
    # Format:
    # *timestamp:[level] user
    # *method endpoint
    # *problem
    #   *details
    #   :
    # ?Call stack
    #   *details
    #   :
    ##############
    Token = Struct.new(
      :detected_at,
      :log_level,
      :detected_user,
      :http_method,
      :end_point,
      :problem,
      :root_line,
      :callstack,
    )

    TIMESTAMP_REGEX = /\b\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\b/

    def initialize(file)
      @file = file
    end

    def exec
      tokens = []
      line = @file.gets
      until @file.eof? do
        detected_at = line.slice(TIMESTAMP_REGEX)
        if detected_at
          rest = line.split(TIMESTAMP_REGEX).last.split(' ')
          log_level, _, detected_user = *rest
          token = Token.new(
            detected_at,
            log_level.gsub('[', '').gsub(']', ''),
            detected_user,
          )
          tokens.push(p_api(token))
          line = @file.gets
        else
          line = @file.gets
        end
      end

      tokens
    end

    private

    def p_api(token)
      line = @file.gets
      http_method, end_point = *line.split(' ')
      token.http_method = http_method
      token.end_point = end_point

      p_problem(token)
    end

    def p_problem(token)
      problem = ''
      line = @file.gets
      until line.nil? || line.include?('Call stack') || line.start_with?("\n")
        problem += line
        line = @file.gets
      end

      token.problem = problem
      if line.nil? || line.start_with?("\n")
        token
      else
        p_callstack(token)
      end
    end

    def p_callstack(token)
      callstack = ''
      line = @file.gets
      token.root_line = line
      until line.nil? || line.start_with?("\n")
        callstack += line
        line = @file.gets
      end

      token.callstack = callstack
      token
    end
  end
end
