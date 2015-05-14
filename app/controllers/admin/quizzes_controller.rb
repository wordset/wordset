class Admin::QuizesController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin!

  def index
    @quizzes = Quiz.all
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.create(quiz_params)
    flash[:notice] = "Created"
    redirect_to edit_admin_quiz_path(@quiz)
  end

  def publish
    @quiz = Quiz.find(params[:id])
    @quiz.publish!
    flash[:notice] = "Published!"
    redirect_to admin_quizzes_path
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update
    edit
    @quiz.update_attributes(quiz_params)
    flash[:notice] = "Saved"
    render "edit"
  end

 private
  def quiz_params
    params.require(:quiz).permit!
  end
end
