class SkillsController < ApplicationController
  before_action :parameter_check, only: [:create]

  def create
    skill = Skill.new(name: params[:name])
    if skill.save
      render json: skill
    else
      render json: {skill: skill.errors.messages}, status: 422
    end
  end

  def index
    skills = Skill.all
    render json: skills
  end

  private
  def parameter_check
    unless params[:name].present?
      return render json: {error: 'parameter missing for skill'}, status: 422
    end
  end
end
