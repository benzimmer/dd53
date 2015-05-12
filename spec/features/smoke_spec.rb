require 'feature_spec_helper'

RSpec.describe 'IP update', feature: true do

  let(:hostname) { 'dd.example.com' }
  let(:ip) { '127.0.0.1' }

  context 'all well' do

    let(:updater) { double }

    before do
      allow(Update).to receive(:new) { updater }
      allow(updater).to receive(:update)
    end

    it 'returns good + IP' do
      authorize 'test', 'test'

      get "/nic/update?hostname=#{hostname}&myip=#{ip}"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("good #{ip}")
    end

  end

  context 'no hostname' do

    it 'returns nofqdn' do
      authorize 'test', 'test'

      get '/nic/update'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('notfqdn')
    end

  end

  context 'no IP' do

    it 'uses request IP' do
      authorize 'test', 'test'

      get "/nic/update?hostname=#{hostname}"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('nochg')
    end

  end

end
