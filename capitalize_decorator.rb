require_relative 'decorator' # Make sure to include the path to your BaseDecorator

class CapitalizeDecorator < BaseDecorator
  def correct_name
    super.capitalize
  end
end
