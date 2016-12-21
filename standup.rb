class Standup
  def initialize
    @todo = []
    @completed = []
    @blockers = []
  end

  def add_todo(task)
    @todo << task
  end

  def add_completed(task)
    @completed << task
  end

  def add_blocker(task)
    @blockers << task
  end

  def slack
    puts "For Slack:\n"
    puts "*What Did I Accomplish Yesterday?*"
    @completed.each do |task|
      puts "  :white_check_mark: #{task}"
    end
    puts "*What Do I Plan to Do Today?*"
    @todo.each do |task|
      puts "  :white_large_square: #{task}"
    end
    puts "*What's Blocking Me?*"
    @blockers.each do |task|
      puts "  • #{task}"
    end
  end

  def github
    puts "For GitHub Wiki:\n"
    puts "* **What Did I Accomplish Yesterday?**"
    @completed.each do |task|
      puts "  * [x] #{task}"
    end
    puts "* **What Do I Plan to Do Today?**"
    @todo.each do |task|
      puts "  * [ ] #{task}"
    end
    puts "* **What's Blocking Me?**"
    @blockers.each do |task|
      puts "  * #{task}"
    end
  end
end

if(ARGV.size > 0)
  tasks = %w(completed todo blocker)
  file = File.open(ARGV[0], 'r')
  @standup = Standup.new

  task_index = 0
  file.each_line do |line|
    if line.chomp.empty?
      task_index += 1
    else
      @standup.send("add_#{tasks[task_index]}", line)
    end
  end
else
  @standup = Standup.new
  %w(completed todo blocker).each do |category|
    loop do
      puts "Enter new #{category}: "
      new_task = gets.chomp
      break if new_task.empty?
      @standup.send("add_#{category}", new_task)
    end
  end
end

@standup.slack
puts "\n"
@standup.github
