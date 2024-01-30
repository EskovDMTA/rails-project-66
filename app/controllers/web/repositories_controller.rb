module Web
  class RepositoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[index show new create]
  before_action :git_client, only: %i[new create]

  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = Repository.find(params[:id])
    @checks = Repository::Check.where(repository_id: @repository.id)
  end

  def new
    @repository = Repository.new(user_id: current_user)
    @user_repositories = @client.fetch_user_repositories_name_and_id
  end

  def create
    repository_params = @client.repository_params(repository_id).merge(user_id: current_user.id)
    @repository = Repository.new(repository_params)
    if @repository.save
      redirect_to repositories_path
    else
      render :new
    end
  end

  private

  def repository_id
    params[:repo_id]
  end

  def git_client
    @client = GitClient.new(user_github_token)
  end

  def user_github_token
    User.find(current_user.id).token || nil
  end
  end
end
