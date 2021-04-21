module CreateTaskSupport
  def create_task(task)
    click_link "New task"
    fill_in "Title", with: task.title
    fill_in "Content", with: task.content
    select task.status, from: "Status"
    fill_in "Deadline", with: task.deadline
    click_button "Create Task"
    # task.save
  end
end

RSpec.configure do |config|
  config.include CreateTaskSupport
end
