# frozen_string_literal: true

module TimeHelper
  def current_utc_timestamp
    Time.now.utc.to_i
  end

  def create_utc_timestamp(year, month, day, hour = 0, minute = 0, second = 0)
    Time.utc(year, month, day, hour, minute, second).to_i
  end
end
