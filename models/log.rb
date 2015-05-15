class Log < ActiveRecord::Base

  def method_missing(id)
    data && data.fetch(id.to_s, nil)
  end

end
