require 'rails_helper'

RSpec.describe 'Upload .xlsx files', type: :feature do
  describe 'successful uploading of a file' do
    before :each do
      stub_request(:get, "https://test-space.cobot.me/api/plans").
        with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip, deflate',
            'Authorization' => 'Bearer token-hard-coded-for-the-challenge-only',
            'Host' => 'test-space.cobot.me',
            'User-Agent' => 'Cobot Client 4.0.0'
          }).
        to_return(status: 200, body: '[{ "id": "973bd9889e2b38be9e29a660eec55fe3", "name": "Basic Plan" },
                                      { "id": "973bd9889e2b38be9e29a660eec56947", "name": "Premium Plan" }]', headers: {})

      stub_request(:post, "https://test-space.cobot.me/api/membership_import").
        with(
          body: "{\"membership\":{\"membership\":{\"address\":{\"name\":\"Harvey Blair\",\"company\":\"Cobot GmbH\",\"full_address\":\"1797 Zumi Heights\"},\"phone\":\"(376) 736-8728\",\"email\":\"vimabal@segdu.ye\",\"plan\":{\"id\":\"973bd9889e2b38be9e29a660eec55fe3\"},\"starts_at\":\"2021/08/29\",\"first_invoice_at\":\"2021/10/01\"}}}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip, deflate',
            'Authorization' => 'Bearer token-hard-coded-for-the-challenge-only',
            'Content-Length' => '281',
            'Content-Type' => 'application/json',
            'Host' => 'test-space.cobot.me',
            'User-Agent' => 'Cobot Client 4.0.0'
          }).
        to_return(status: 200, body: "[]", headers: {})

      stub_request(:post, "https://test-space.cobot.me/api/membership_import").
        with(
          body: "{\"membership\":{\"membership\":{\"address\":{\"name\":\"Tony Glover\",\"company\":\"GitHub Inc.\",\"full_address\":\"791 Pegja Trail\"},\"phone\":null,\"email\":\"irti@hujir.im\",\"plan\":{\"id\":\"973bd9889e2b38be9e29a660eec56947\"},\"starts_at\":\"2021/06/05\",\"first_invoice_at\":\"2021/06/05\"}}}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip, deflate',
            'Authorization' => 'Bearer token-hard-coded-for-the-challenge-only',
            'Content-Length' => '264',
            'Content-Type' => 'application/json',
            'Host' => 'test-space.cobot.me',
            'User-Agent' => 'Cobot Client 4.0.0'
          }).
        to_return(status: 200, body: "[]", headers: {})

      visit '/import/new'
      attach_file('File', './fixtures/import.xlsx')
      click_button 'Upload'
    end

    scenario '.have a successfully uploaded notification' do
      expect(page).to have_content 'Successfully uploaded!'
    end

    scenario '.have a successful status' do
      expect(page).to have_http_status(:success)
    end
  end

  describe 'unsuccessful uploading of a file' do
    before :each do
      visit '/import/new'
      attach_file('File', './fixtures/example.png')
      click_button 'Upload'
    end

    scenario '.have an unsuccessful status' do
      expect(page).to have_http_status(204)
    end
  end
end
