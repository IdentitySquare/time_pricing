RubyVM::InstructionSequence.compile_option = {
  tailcall_optimization: true,
  trace_instruction: false
}

require 'time_pricing/plan'
require 'time_pricing/utils'
require 'time_pricing/config'
require 'time_pricing/base'
require 'time_pricing/calculation'

module TimePricing
  class Error < StandardError; end
  class ParameterMissing < StandardError; end

  class << self
    def new(**args)
      config = TimePricing::Config.new(args)
      TimePricing::Base.new(config)
    end
  end
end
