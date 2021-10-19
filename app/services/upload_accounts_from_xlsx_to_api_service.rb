# frozen_string_literal: true

class UploadAccountsFromXlsxToApiService
  def run(file)
    upload_accounts_to_api(file) # sending data from file to API.
  end

  private

  def upload_accounts_to_api(file)
    sheet = file.sheet(0)

    accounts(sheet).each do |item|
      next if validate_parameters(item)

      membership_attributes = {
        "membership": {
          "address": {
            "name": item[:name],
            "company": item[:company],
            "full_address": item[:full_address]
          },
          "phone": item[:phone],
          "email": item[:email].gsub(/<\/?[^>]+>/, ''),
          "plan": {
            "id": payment_plans[item[:plan_name]]
          },
          "starts_at": item[:starts_at].to_date.strftime('%Y/%m/%d'),
          "first_invoice_at": item[:first_invoice_at].to_date.strftime('%Y/%m/%d')
        }
      }

      ImportService.new.run(membership_attributes)
    end
  end

  private

  def accounts(sheet)
    sheet.parse(name: 'Name*',
                company: 'Company',
                full_address: 'Address',
                email: 'Email',
                phone: 'Phone',
                plan_name: 'Plan Name*',
                starts_at: 'Start Date* (DD/MM/YY)',
                first_invoice_at: 'Next Invoice Date*')
  end

  def payment_plans
    response = PaymentPlansService.new.run # Getting payment plans for converting them to ID.
    plans = {}
    response.each { |item| plans[item[:name]] = item[:id] }
    plans
  end

  def validate_parameters(row)
    row[:name].nil? ||
      row[:full_address].nil? ||
      row[:plan_name].nil? ||
      row[:starts_at].nil? ||
      row[:first_invoice_at].nil?
  end
end

