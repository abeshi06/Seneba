class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all.order(:done, :due_date)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: '登録が完了しました！' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: '更新が完了しました！' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    # 入力したやることの内容
    @search_name = params['search']['name']
    # 選択したユーザーのID
    @search_user = params['search']['user']
    # 選択したカテゴリーのID
    @search_category = params['search']['category']
    # やることの内容と部分一致するタスクを取得
    @tasks = Task.where("name LIKE '%#{@search_name}%'").order(:done, :due_date)
    # もしもユーザーが選択されていたら
    if @search_user.present?
      # 部分一致検索をした結果に対して、更にユーザーで絞り込む
      @tasks = @tasks.where(user_id: @search_user)
    end
    # もしもカテゴリーが選択されていたら
    if @search_category.present?
      # 部分一致検索をした結果に対して、更にカテゴリーで絞り込む
      @tasks = @tasks.where(category_id: @search_category)
    end
    # ちなみに、ユーザーやカテゴリーを選択していなかった場合、絞り込まなかった結果（すべてのユーザーとかすべてのカテゴリーとか）を取得することになる

    render :index
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: '削除が完了しました！' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:due_date, :category_id, :name, :done, :user_id)
    end
end
