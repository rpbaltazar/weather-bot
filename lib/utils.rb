module Utils
  #TODO: spec this as it is a bit useless for now
  def self.random_string length=50
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    string = (0...length).map { o[rand(o.length)] }.join
  end
end
