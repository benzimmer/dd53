class Status
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

