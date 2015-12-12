require './lib/status'
require './lib/host'

class Update

  attr_reader :host, :hostnames, :ip
  attr_accessor :status

  def initialize(hostnames, ip)
    @hostnames = hostnames
    @ip = ip
    @host = Host.new(hostnames.first)
  end

  def update
    return false unless can_update?

    begin
      if host.update(ip)
        self.status = Status.good(ip)
        true
      else
        self.status = Status.nochg(ip)
        false
      end
    rescue Exception
      self.status = Status.abuse
      false
    end
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
    elsif host.record_set.nil?
      self.status = Status.nohost
      return false
    end

    true
  end

end

class IpNotChangedError < StandardError; end
class IpChangeError < StandardError; end
class HostnameNotFoundError < StandardError; end

