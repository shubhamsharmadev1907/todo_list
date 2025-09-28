class TasksController < ApplicationController
  before_action :authenticate_request!
  load_and_authorize_resource

  # GET /tasks
  def index
    tasks = current_user.tasks
    render json: tasks, each_serializer: TaskSerializer
  end

  # GET /tasks/:id
  def show
    # load_and_authorize_resource already fetches @task
    task = Task.find(params[:id])
    render json: task, serializer: TaskSerializer
  end

  # POST /tasks
  def create
    @task.user = current_user unless current_user.admin? # admin can create for any user in future
    @task.assign_attributes(task_params)

    if @task.save
      render json: @task, serializer: TaskSerializer, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/:id
  def update
    @task.update!(task_params)
    if @task.update(task_params)
      render json: @task, serializer: TaskSerializer, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy!
    head :no_content
  end

  private

  def task_params
    params.require(:task).permit(:title, :done)
  end
end
