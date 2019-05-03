require 'fileutils'
require 'open3'
require 'minitest/autorun'
require 'minitest/spec'
require_relative 'rcc'

# NOTE: expected, code
parameters = [
  [42, '42'],
  [0, '0'],
  [21, '5+20-4']
]

describe Rcc do
  before do
    @tmp = 'tmp'
  end

  it 'compiles code written in the subset of C correctly' do
    parameters.each do |expected, code|
      _, status = Open3.capture2(
        "gcc -x assembler - -o #{@tmp} && ./#{@tmp}",
        stdin_data: Rcc.call(code)
      )

      assert_equal expected, status.exitstatus
    end
  end

  after do
    FileUtils.remove_file(@tmp, force = true)
  end
end
