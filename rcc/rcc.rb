module Rcc
  def self.call(code)
    <<~ASM
      .intel_syntax noprefix
      .global main
      main:
        mov rax, #{code.to_i}
        ret
    ASM
  end
end

if __FILE__ == $0
  unless ARGV.length == 1
    STDERR.puts '引数の個数が正しくありません'
    exit 1
  end

  puts Rcc.call(ARGV[0])
end
