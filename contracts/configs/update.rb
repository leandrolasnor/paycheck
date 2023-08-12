# frozen_string_literal: true

class UpdateConfigContract < Dry::Validation::Contract
  params do
    required(:paycheck).schema do
      required(:paycheck_file_path).filled(:string)
      required(:people_file_path).filled(:string)
    end

    required(:action_mailer).schema do
      required(:raise_delivery_errors).filled
      required(:delivery_method).filled

      required(:smtp_settings).schema do
        required(:address).filled(:str?)
        required(:domain).filled(:str?)
        required(:port).filled(:integer)
        required(:authentication).value(eql?: :login)
        required(:ssl).value(:bool?)
        required(:user_name).filled(:str?)
        required(:password).filled(:str?)
      end
    end
  end
end
