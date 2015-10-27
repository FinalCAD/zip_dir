class Dir
  class << self
    def clean_entries(dir)
      entries = entries(dir)
      entries.delete "."
      entries.delete ".."
      entries
    end
  end
end