require 'spec_helper'

RSpec.describe Route53Client, model: true do

  let(:client) { double }
  let(:hostname) { 'test' }
  let(:ip) { '127.0.0.1' }
  let(:hosted_zone) { 'example.com.' }

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

  describe '#fqdn_for' do

    before do
      allow(subject).to receive(:hosted_zone) { hosted_zone }
    end

    context 'pass fqdn' do

      let(:name) { 'home.example.com' }

      it 'it returns the right format' do
        fqdn = subject.fqdn_for(name)
        expect(fqdn).to eq('home.example.com.')
      end

    end

    context 'pass name only' do

      let(:name) { 'home' }

      it 'it returns the right format' do
        fqdn = subject.fqdn_for(name)
        expect(fqdn).to eq('home.example.com.')
      end

    end

  end

end
