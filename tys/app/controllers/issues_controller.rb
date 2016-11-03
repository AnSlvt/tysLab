class IssuesController < ApplicationController

  before_action :logged_in?

  def index
    @stack_trace = StackTrace.find(params[:stack_trace_id])
  end

  def new
    @stack_trace = StackTrace.find(params[:stack_trace_id])
    @issue = Issue.new
  end

  def create
    @stack_trace = StackTrace.find(params[:stack_trace_id])
    github_issue = SessionHandler.instance.create_stack_trace_issue(@stack_trace.application.github_repository, create_params[:title], create_params[:body])
    @issue = Issue.create!({
      github_repository: @stack_trace.application.github_repository,
      github_number: github_issue.number,
      stack_trace_id: params[:stack_trace_id]
      })
    redirect_to user_application_stack_trace_issues_path(@issue.stack_trace.application.author, @issue.stack_trace.application, @issue.stack_trace)
  end

  def edit_label
    render file: 'public/403.html', status: 403 unless current_user.name == params[:user_id]
    @issue = Issue.find(params[:issue_id])
    SessionHandler.instance.add_label_to_a_stack_trace_issue(@issue.github_repository, @issue.github_number, [params[:label]])
    redirect_to user_application_stack_trace_issues_path(@issue.stack_trace.application.author, @issue.stack_trace.application, @issue.stack_trace)
  end

  def edit_state
    render file: 'public/403.html', status: 403 unless current_user.name == params[:user_id]
    @issue = Issue.find(params[:issue_id])
    if params[:state] == 'closed'
      SessionHandler.instance.close_stack_trace_issue(@issue.github_repository, @issue.github_number)
    else
      SessionHandler.instance.reopen_stack_trace_issue(@issue.github_repository, @issue.github_number)
    end
    redirect_to user_application_stack_trace_issues_path(@issue.stack_trace.application.author, @issue.stack_trace.application, @issue.stack_trace)
  end

  private
  def create_params
    params.require(:issue).permit(:title, :body)
  end

end
