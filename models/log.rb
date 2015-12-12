class Log < ActiveRecord::Base

  def self.last_entry_for(hostname)
    where("data->>'hostname' = ?", hostname.sub(/\.$/, '')).last
  end

  def method_missing(id)
    data && data.fetch(id.to_s, nil)
  end

end
