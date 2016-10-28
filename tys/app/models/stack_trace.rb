class StackTrace < ActiveRecord::Base
  belongs_to :application

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
    else
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
    end
  end
end
