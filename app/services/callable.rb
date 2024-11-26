module Callable
  extend ActiveSupport::Concern

  Result = Struct.new(:success?, :errors, :object)

  class_methods do
    def call(*args, **kwargs)
      new(*args, **kwargs).call
    end
  end

  def result(success:, errors: [], object: nil)
    Result.new(success, errors, object)
  end
end
