require 'spec_helper'

RSpec.describe Host, model: true do

  let(:client) { double }
  let(:hostname) { 'test' }
  let(:ip) { '127.0.0.1' }

  subject { Host.new(hostname, ip) }

  before do
    allow(Host).to receive(:client) { client }
    allow(client).to receive(:hosted_zone) { 'example.com.' }
  end

  describe '.all' do

    let(:resource_records) { [double(value: ip)] }
    let(:a_record_set) { double(type: 'A', name: 'test.example.com.',
                                resource_records: resource_records) }
    let(:cname_record_set) { double(type: 'CNAME', name: 'foo.example.com.') }
    let(:record_sets) { [a_record_set, cname_record_set] }

    before do
      allow(client).to receive(:record_sets) { record_sets }
    end

    it 'returns an array of Hosts' do
      expect(Host.all.first).to be_a(Host)
    end

    it 'assigns the right data' do
      host = Host.all.first

      expect(host.name).to eq('test')
      expect(host.ip).to eq(ip)
    end

    it 'returns only A records' do
      expect(Host.all.size).to eq(1)
    end

  end

  describe '.create' do

    it 'creates a new resource record' do
      attributes = { 'name' => hostname, 'ip' =>  '127.0.0.10' }
      expect(client).to receive(:create_record_set).with(hostname, '127.0.0.10')

      Host.create(attributes)
    end

    it 'uses 127.0.0.1 as fallback address' do
      attributes = { 'name' => hostname }
      expect(client).to receive(:create_record_set).with(hostname, '127.0.0.1')

      Host.create(attributes)
    end

  end

  describe '#update' do

    let(:new_ip) { '127.0.0.2' }

    it 'assigns the new ip' do
      expect(client).to receive(:update_record_set).with(hostname, new_ip)
      allow(subject).to receive(:record_needs_update?) { true }

      subject.update(new_ip)

      expect(subject.ip).to eq(new_ip)
    end

    it 'does not update when the record is up to date' do
      expect(client).to_not receive(:update_record_set)
      allow(subject).to receive(:record_needs_update?) { false }

      subject.update(new_ip)
    end

  end

  describe '#record_set' do

    it 'gets the record set for the hostname' do
      expect(client).to receive(:record_set_for).with(hostname)

      subject.record_set
    end

  end

  describe '#record_needs_update?' do

    it 'returns false if the record is up to date' do
      rr = double(value: '127.0.0.1')
      expect(subject).to receive(:first_resource_record) { rr }

      expect(subject.record_needs_update?).to eq(false)
    end

    it 'returns true if the record is not up to date' do
      rr = double(value: '127.0.0.2')
      expect(subject).to receive(:first_resource_record) { rr }

      expect(subject.record_needs_update?).to eq(true)
    end

  end

end
