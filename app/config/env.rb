module App; module ENV
  class << self
    def [](key)
      vars["ENV_#{key}"]
    end

    def vars
      @vars ||= info_dictionary.select { |key, value| key.start_with? 'ENV_' }
    end

    def info_dictionary
      NSBundle.mainBundle.infoDictionary
    end
  end
end; end
