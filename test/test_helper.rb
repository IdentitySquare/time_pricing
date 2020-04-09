$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'active_support/all'
require "time_pricing"

# Runs all tests before Ruby exits, using `Kernel#at_exit`.
require "minitest/autorun"

# Enables rainbow-coloured test output.
require 'minitest/pride'

# Enables parallel (multithreaded) execution for all tests.
require 'minitest/hell'