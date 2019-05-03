require 'fileutils'
require 'open3'
require 'minitest/autorun'
require 'minitest/spec'
require_relative 'rcc'

describe Rcc do
  before do
    @tmp = 'tmp'
  end

  it 'compiles an input integer' do
    [
      [42, '42'],
      [0, '0']
    ].each do |expected, code|
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
