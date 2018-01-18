class SelectApply
  class << self
    def caclulate_applies apply, role = nil
      if apply.present?
        total = apply.size
        hashes = {waitting: 0, joined: 0, interview_scheduled: 0,
          interview_passed: 0, offer_sent: 0, test_scheduled: 0}
        apply_status = apply.group_by &:status
        apply_status.each do |status|
          if hashes.keys.include? status.first.to_sym
            hashes[status.first.to_sym] = if role == Settings.caclulate_applies_size
              status.second.size
            else
              (((status.second.size.to_f) / total)*
                Settings.dashboard.hundred).round(Settings.dashboard.mod)
            end
          end
        end
      end
      hashes
    end
  end
end
