class CreateTaskNotificationMailer < ApplicationMailer
	default from: 'no-reply@example.com'
  
	def one_day_task_reminder_notification(user, task)
		@user = user
		@task = task
		mail(to: @user.email, subject: 'Reminder: 1 Day left remaing')
	end

	def one_hour_task_reminder_notification(user, task)
		@user = user
		@task = task
		mail(to: @user.email, subject: 'Reminder: 1 hour remaining ')
	end 
end
