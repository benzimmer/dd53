require 'feature_spec_helper'

RSpec.describe 'IP update', feature: true do

  let(:hostname) { 'dd.example.com' }
  let(:ip) { '127.0.0.1' }
  let(:updater) { double }

  before do
    allow(Log).to receive(:create)
  end

  context 'all well' do

    before do
      allow(Update).to receive(:new) { updater }
      allow(updater).to receive(:update)
      allow(updater).to receive(:status) { "good #{ip}" }
    end

    it 'returns good + IP' do
      authorize 'test', 'test'

      get "/nic/update?hostname=#{hostname}&myip=#{ip}"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("good #{ip}")
    end

    it 'creates a log entry' do
      authorize 'test', 'test'

      data = {
        ip: ip,
        hostname: hostname,
        user_agent: nil,
        status: "good #{ip}",
      }
      expect(Log).to receive(:create).with(data: data)

      get "/nic/update?hostname=#{hostname}&myip=#{ip}"
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

  context 'wrong hostname' do

    before do
      allow(Update).to receive(:new) { updater }
      allow(updater).to receive(:update)
      allow(updater).to receive(:status) { "nohost" }
    end

    it 'returns nofqdn' do
      authorize 'test', 'test'

      get '/nic/update?hostname=wrong.example.com'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('nohost')
    end

  end

  context 'no IP' do

    let(:remote_addr) { '192.168.101.1' }

    before do
      allow(Update).to receive(:new) { updater }
      allow(updater).to receive(:update)
      allow(updater).to receive(:status) { "good #{remote_addr}" }
    end

    it 'uses request IP' do
      authorize 'test', 'test'

      request "/nic/update?hostname=#{hostname}", {'REMOTE_ADDR' => remote_addr}

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("good #{remote_addr}")
    end

  end

end
