require './environment'

set :username, ENV['USERNAME']
set :password, ENV['PASSWORD']

use Rack::Auth::Basic do |username, password|
  username == settings.username && password == settings.password
end

get '/nic/update' do
  hostnames = params.fetch('hostname', '').split(',')
  ip = params.fetch('myip', nil)

  return Response.notfqdn if hostnames.empty?
  return Response.numhost if hostnames.size > 1
  return Response.nochg if ip.nil?

  updater = IpUpdater.new(hostnames.first, ip)
  begin updater.update
    return Response.good(ip)
  rescue IpChangeError
    return Response.abuse
  rescue IpNotChangedError
    return Response.nochg(ip)
  rescue HostnameNotFoundError
    return Response.nohost
  end
end

module Response
  ABUSE = 'abuse'
  GOOD = 'good'
  NOCHG = 'nochg'
  NOHOST = 'nohost'
  NOTFQDN = 'notfqdn'
  NUMHOST = 'numhost'

  class << self

    def good(ip)
      [GOOD, ip].join(' ')
    end

    def abuse
      ABUSE
    end

    def nochg(ip=nil)
      [NOCHG, ip].compact.join(' ')
    end

    def nohost
      NOHOST
    end

    def notfqdn
      NOTFQDN
    end

    def numhost
      NUMHOST
    end

  end

end

class IpUpdater

  attr_reader :ip

  def initialize(hostname, ip)
    @hostname = hostname
    @ip = ip
  end

  def update
    if record_changed?
      begin
        change_record
        true
      rescue Exception => e
        raise IpChangeError, e
      end
    else
      IpNotChangedError
    end
  end

  def hostname
    "#{@hostname}."
  end

  private

  def change_record
    client.change_resource_record_sets(zone_hash)
  end

  def record_changed?
    resp = client.list_resource_record_sets(hosted_zone_id: hosted_zone_id)
    record = resp.resource_record_sets.detect {|rrs| rrs.name == hostname}

    raise HostnameNotFoundError if record.nil?

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

  def record_sets
    @record_sets ||= begin

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
