class SelectApply
  class << self
    def caclulate_applies total, size_applies
      (size_applies.to_f / total * Settings.percent).round Settings.rounding
    end
  end
end
