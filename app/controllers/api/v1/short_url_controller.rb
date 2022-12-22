class Api::V1::ShortUrlController < ApiController
  def create
    # @company = Company.new(company_params)
    @company = current_user.companies.new(company_params)
    if @company.save
      render json: @company, status: :ok
    else
      render json: { data: @company.errors.full_messages, status: "failed" }, status: :unprocessable_entity
    end
  end
end
