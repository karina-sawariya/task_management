class TaskReminderJob < ApplicationJob
  queue_as :default

  def perform(task)
    now = Time.current

    if task.end_date > now
      if (task.end_date - now).to_i == 1.day.seconds.to_i
        CreateTaskNotificationMailer.one_day_task_reminder_notification(task.user, task).deliver_now
      elsif (task.end_date - now).to_i == 1.hour.seconds.to_i
        CreateTaskNotificationMailer.one_hour_task_reminder_notification(task.user, task).deliver_now
      end
    end
  end
end
