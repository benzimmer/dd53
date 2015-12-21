class Route53Client
  include Singleton

  def client
    @client ||= Aws::Route53::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  def hosted_zone
    @hosted_zone ||= begin
      resp = client.get_hosted_zone(id: hosted_zone_id)
      resp.hosted_zone.name
    end
  end

  def record_sets
    resp = client.list_resource_record_sets(hosted_zone_id: hosted_zone_id)
    resp.resource_record_sets
  end

  def create_record_set(name, ip)
    full_name = fqdn_for(name)

    changes = build_changes_set(:create, full_name, ip)
    zone_hash = build_record_set_change(changes)

    client.change_resource_record_sets(zone_hash)
  end

  def update_record_set(name, ip)
    full_name = fqdn_for(name)
    changes = build_changes_set(:upsert, full_name, ip)
    zone_hash = build_record_set_change(changes)

    client.change_resource_record_sets(zone_hash)
  end

  def record_set_for(name)
    record_sets.detect do |rrs|
      rrs.name == fqdn_for(name)
    end
  end

  def fqdn_for(name)
    name + '.'
  end

  private

  def build_changes_set(action, name, ip)
    [{
      action: action.to_s.upcase,
      resource_record_set: {
        name: name,
        type: "A",
        ttl: 60,
        resource_records: [{
          value: ip
        }]
      }
    }]
  end

  def build_record_set_change(changes)
    {
      hosted_zone_id: hosted_zone_id,
      change_batch: {
        comment: "DDNS update",
        changes: changes
      }
    }
  end

  def hosted_zone_id
    ENV['AWS_HOSTED_ZONE_ID']
  end

end
