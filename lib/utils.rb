# Depreacated module. Currently not being
# used and will be deleted soon if not needed
module Utils
  # TODO: spec this as it is a bit useless for now
  def self.random_string(length = 50)
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...length).map { o[rand(o.length)] }.join
  end
end
