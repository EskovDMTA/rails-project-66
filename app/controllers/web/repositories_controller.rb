# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    # before_action :authenticate_user!
    before_action :git_client, only: %i[new create]

    def index
      authorize Repository
      @repositories = current_user.repositories.order(created_at: :desc).page(params[:page]).per(20)
    end

    def show
      @repository = Repository.find(params[:id])
      authorize @repository
      @checks = Repository::Check.where(repository_id: @repository.id).page(params[:page]).per(10)
    end

    def new
      @repository = Repository.new(user_id: current_user)
      @user_repositories = @client.fetch_user_repositories_name_and_id
    end

    def create
      repository_id = repository_params['github_id']
      rep_param = @client.repository_params(repository_id).merge(user_id: current_user.id)
      @repository = Repository.find_or_initialize_by(rep_param)
      if @repository.save
        redirect_to repositories_path, notice: t('.success_create')
      else
        render :new, alert: t('.create_failure')
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def git_client
      @client = ApplicationContainer[:git_client].call(user_github_token)
    end

    def user_github_token
      User.find(current_user.id).token || nil
    end
  end
end
