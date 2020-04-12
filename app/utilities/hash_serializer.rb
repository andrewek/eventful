# frozen_string_literal: true

# Given our JSONB data columns (which by default present with string keys), we
# want to have something that converts those keys to symbols for more pleasant
# access.
class HashSerializer
  def self.dump(hsh)
    (hsh || {}).to_json
  end

  def self.load(hsh)
    JSON.parse((hsh || "{}"), symbolize_names: true)
  end
end
