require 'spec_helper'

RSpec.describe Route53Client, model: true do

  let(:client) { double }
  let(:hostname) { 'test' }
  let(:ip) { '127.0.0.1' }

  subject { Route53Client.instance }

  describe '#client' do

    it 'returns an aws sdk route53 client' do
      expect(Aws::Route53::Client).to receive(:new)

      subject.client
    end

  end

  context do

    before do
      allow(subject).to receive(:client) { client }
    end

    describe '#hosted_zone' do

      it 'returns the hosted zones name' do
        response = double(hosted_zone: double(name: 'test'))
        expect(client).to receive(:get_hosted_zone) { response }

        expect(subject.hosted_zone).to eq('test')
      end

    end

    describe '#record_sets' do

      it 'gets the record sets' do
        response = double(resource_record_sets: [])
        expect(client).to receive(:list_resource_record_sets) { response }

        subject.record_sets
      end

    end

  end

end
