# frozen_string_literal: true

module SolidusSubscriptions
  module Dispatcher
    class FailureDispatcher < Base
      def dispatch
        order.cancel
        installment.failed!(order)
      end
    end
  end
end
