class TasksController < ApplicationController
  def index; render json: Task.all; end
  def show; render json: Task.find(params[:id]); end
  def create; t=Task.new(task_params); t.save; render json: t; end
  def update; t=Task.find(params[:id]); t.update(task_params); render json: t; end
  def destroy; Task.find(params[:id]).destroy; head :no_content; end
  private
  def task_params; params.require(:task).permit(:title,:done); end
end
