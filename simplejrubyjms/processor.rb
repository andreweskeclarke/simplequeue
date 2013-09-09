class Processor
  @@topic_map = {}
  class<<self
    def subscribes_to destination_name
      @@topic_map[self.name] = destination_name
    end
  end

  def topic
    @@topic_map[self.class.name]
  end
end
