RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

require "time_pricing/version"

module TimePricing
  class Error < StandardError; end

  def self.hi
    puts "Hello world!"
  end
end
