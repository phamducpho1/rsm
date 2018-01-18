class SelectApply
  class << self
    def caclulate_applies apply
      if apply.present?
        total = apply.size
        hashes = {}
        get_status = ["waitting", "joined", "interview_scheduled", "interview_passed",
          "offer_sent", "test_scheduled"]
        status = Apply.statuses
        status.each do |key, value|
          if get_status.include? key
            hashes[key] = (((Apply.send(key).size.to_f) / total)*
              Settings.dashboard.hundred).round(Settings.dashboard.mod)
          end
        end
      end
      hashes
    end
  end
end
