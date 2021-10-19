# frozen_string_literal: true

class PaymentPlansService
  ACCESS_TOKEN = 'token-hard-coded-for-the-challenge-only'
  SUBDOMAIN = 'test-space'

  def run
    get_payment_plans # get payment plans from Cobot Space.
  end

  private

  def get_payment_plans
    cobot_client.get(
      SUBDOMAIN, '/plans'
    )
  rescue CobotClient::TooManyRequests => e
    sleep e.response.headers[:retry_after].to_i
    retry
  rescue RestClient::Exception => e
    nil
  end

  def cobot_client
    CobotClient::ApiClient.new(ACCESS_TOKEN)
  end
end
