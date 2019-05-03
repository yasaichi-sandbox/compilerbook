# frozen_string_literal: true
require 'stringio'
require 'strscan'

module Rcc
  INTEGER_PATTERN = /[1-9]\d*|0/

  class << self
    def call(code)
      ".intel_syntax noprefix\n#{parse(code)}\n"
    end

    private

    def parse(code)
      asm = StringIO.new
      asm.puts <<~CODE
        .global main
        main:
      CODE

      scanner = StringScanner.new(code)
      initial = scanner.scan(INTEGER_PATTERN)
      raise "予期しない文字です: #{scanner.getch}" unless initial

      asm.puts("  mov rax, #{initial}")
      until scanner.eos? do
        case operator = scanner.getch
        when '+'
          asm.puts("  add rax, #{scanner.scan(INTEGER_PATTERN)}")
        when '-'
          asm.puts("  sub rax, #{scanner.scan(INTEGER_PATTERN)}")
        else
          raise "予期しない文字です: #{operator}"
        end
      end
      asm.puts("  ret")

      asm.string
    end
  end
end

if __FILE__ == $0
  raise '引数の個数が正しくありません' unless ARGV.length == 1
  puts Rcc.call(ARGV[0])
end
