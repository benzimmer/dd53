require 'spec_helper'

require './lib/update'

RSpec.describe Update, model: true do

  let(:hostname) { 'dd.example.com' }
  let(:ip) { '127.0.0.1' }

  context 'hostname empty' do

    subject { Update.new([], ip) }

    it 'returns false and sets correct status' do
      expect(subject.update).to eq(false)
      expect(subject.status).to eq('notfqdn')
    end

  end

  context 'too many hostnames' do

    subject { Update.new([hostname, hostname], ip) }

    it 'returns false and sets correct status' do
      expect(subject.update).to eq(false)
      expect(subject.status).to eq('numhost')
    end

  end

  context 'no ip' do

    subject { Update.new([hostname], nil) }

    it 'returns false and sets correct status' do
      expect(subject.update).to eq(false)
      expect(subject.status).to eq('nochg')
    end

  end

  context 'hostname is no configured in Route53' do

    subject { Update.new([hostname], ip) }

    it 'returns false and sets correct status' do
      allow(subject).to receive(:record_set) { nil }

      expect(subject.update).to eq(false)
      expect(subject.status).to eq('nohost')
    end

  end

  context 'record is up to date' do

    subject { Update.new([hostname], ip) }
    let(:record) { double(value: ip) }
    let(:record_set) { double(resource_records: [record]) }

    it 'returns false and sets correct status' do
      allow(subject).to receive(:record_set) { record_set }

      expect(subject.update).to eq(false)
      expect(subject.status).to eq("nochg #{ip}")
    end

  end

  context 'record needs update' do

    subject { Update.new([hostname], ip) }
    let(:record) { double(value: 'something.else') }
    let(:record_set) { double(resource_records: [record]) }

    it 'returns false and sets correct status' do
      allow(subject).to receive(:record_set) { record_set }
      allow(subject).to receive(:update_record!) { true }

      expect(subject.update).to eq(true)
      expect(subject.status).to eq("good #{ip}")
    end

  end

  context 'error while updating' do

    subject { Update.new([hostname], ip) }
    let(:record) { double(value: 'something.else') }
    let(:record_set) { double(resource_records: [record]) }

    it 'returns false and sets correct status' do
      allow(subject).to receive(:record_set) { record_set }
      allow(subject).to receive(:update_record!).and_raise Exception

      expect(subject.update).to eq(false)
      expect(subject.status).to eq("abuse")
    end

  end
end
