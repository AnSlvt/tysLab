class StackTrace < ActiveRecord::Base
  belongs_to :application
  has_many :issues

  validates_associated :application
  validates :application_id, :error_type, :application_version, :crash_time, presence: true

  def self.st_order_by(unordered, sort_mode)
    if (!sort_mode || sort_mode == '1')
      # grouped by app version number
      out = []
      unordered.group_by(&:application_version).each do |ver, stacks|
        out += stacks.sort { |a, b| a.crash_time <=> b.crash_time }
      end
      out.reverse
    elsif (sort_mode == '2')
      # alphabetical order
      unordered.sort_by { |ex| [ex.error_type, ex.stack_trace_message] }
    elsif (sort_mode == '3')
      # frequency order
      out = []
      dic = {}
      iter = []
      unordered.group_by(&:error_type).each do |type, stacks|
        dic[type] = stacks
        iter << [type, stacks.length]
      end
      iter.sort_by { |row| row[1] }.reverse.each do |tuple|
        out += dic[tuple[0]]
      end
      out
    else
      # fixed status order
      fx = []
      nfx = []
      unordered.group_by(&:fixed).each do |fixed, stacks|
        if fixed
          fx = stacks.sort { |a, b| a.crash_time <=> b.crash_time }
        else
          nfx = stacks.sort { |a, b| a.crash_time <=> b.crash_time }
        end
      end
      nfx + fx
    end
  end
end
