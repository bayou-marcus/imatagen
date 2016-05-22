# Ala http://stackoverflow.com/questions/22051345/breaking-a-mathematical-range-in-equal-parts
class Bucketeer

  @buckets = nil # Symbolic only

  def self.create_buckets(max_size=10000, min_size=0, bucket_size=500)
    diff = (max_size - min_size) / (max_size / bucket_size)
    lower_bound = nil # This value matters not
    upper_bound = -1
    @buckets = []

    while upper_bound < (max_size - diff) do
      lower_bound = upper_bound + 1
      upper_bound = upper_bound + diff
      @buckets << (lower_bound..upper_bound)
    end
    @buckets
  end

  def self.get_bucket_for(width=nil)
    @buckets.each do |b|
      if b.include?(width)
        return b
      end
    end
  end

end
