require './lib/route53_client'

class Host

  attr_accessor :name, :ip, :updated_at

  def self.all
    client.record_sets.map do |rrs|
      next unless rrs.type == 'A'
      Host.from_resource_record(rrs)
    end.compact
  end

  def self.create(name, ip='127.0.0.1')
    client.create_record_set(name, ip)
  end

  def self.from_resource_record(record)
    name = record.name.sub(".#{client.hosted_zone}", '')
    ip = record.resource_records.first.value
    new(name, ip)
  end

  def initialize(name, ip=nil)
    @name = name
    @ip = ip
    @updated_at = find_last_update
  end

  def update(new_ip)
    self.ip = new_ip

    return false unless record_needs_update?

    Host.client.update_record_set(name, ip)
  end

  def record_set
    Host.client.record_set_for(name)
  end

  def record_needs_update?
    first_resource_record.value != ip
  end

  private

  def self.client
    ::Route53Client.instance
  end

  def first_resource_record
    record_set.resource_records[1]
  end

  def find_last_update
    if entry = Log.last_entry_for(Host.client.fqdn_for(name))
      entry.created_at
    end
  end

end
