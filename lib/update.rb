require './lib/status'

class Update

  attr_reader :ip, :hostnames
  attr_accessor :status

  def initialize(hostnames, ip)
    @hostnames = hostnames
    @hostname = hostnames.first
    @ip = ip
  end

  def update
    return false unless can_update?

    if record_needs_update?
      begin
        change_record
        self.status = Status.good(ip)
        true
      rescue Exception => e
        self.status = Status.abuse
      end
    else
      self.status = Status.nochg(ip)
    end
  end

  def hostname
    "#{@hostname}."
  end

  private

  def can_update?
    if hostnames.empty?
      self.status = Status.notfqdn
      return false
    elsif hostnames.size > 1
      self.status = Status.numhost
      return false
    elsif ip.nil?
      self.status = Status.nochg
      return false
    elsif record_set.nil?
      self.status = Status.nohost
      return false
    end

    true
  end

  def change_record
    client.change_resource_record_sets(zone_hash)
  end

  def record_needs_update?
    record.resource_records[0].value != ip
  end

  def zone_hash
    {
      hosted_zone_id: hosted_zone_id,
      change_batch: {
        comment: "DDNS update",
        changes: [{
          action: "UPSERT",
          resource_record_set: {
            name: hostname,
            type: "A",
            ttl: 60,
            resource_records: [{
              value: ip
            }]
          }
        }]
      }
    }
  end

  def record_set
    @record_set ||= begin
      resp = client.list_resource_record_sets(hosted_zone_id: hosted_zone_id)
      record = resp.resource_record_sets.detect {|rrs| rrs.name == hostname}
   end
  end

  def client
    @client ||= AWS::Route53::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  def hosted_zone_id
    ENV['AWS_HOSTED_ZONE_ID']
  end
end

class IpNotChangedError < StandardError; end
class IpChangeError < StandardError; end
class HostnameNotFoundError < StandardError; end

