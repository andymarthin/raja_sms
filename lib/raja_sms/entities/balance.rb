module RajaSms
  module Entities
    class Balance < Base
      extend ModelAttribute

      attribute :amount, :string
      attribute :expired, :string

      def initialize(attributes = {})
        set_attributes(attributes)
      end

    end
  end
end