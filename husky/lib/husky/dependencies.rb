class Object
  def self.const_missing(c)
    return super if @calling_const_missing

    begin
      @calling_const_missing = true
      require Husky.to_underscore(c.to_s)
      klass = Object.const_get(c)
    rescue Exception => e
      raise e
    ensure
      @calling_const_missing = false
    end

    klass
  end
end
