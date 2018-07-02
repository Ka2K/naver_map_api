class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @post = Post.new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to '/', notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
        format.js {} # 별다른 명시가 없으면 액션명.받는것.erb로 반환(이 경우 create.js.erb)
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def map
  end

  def map_data
    max = JSON.parse(params[:max])
    min = JSON.parse(params[:min]) # JSON string을 rails에서 hash 처럼 쓸 수 있게 해줌
    indices = JSON.parse(params[:indices]) # naver map에 이미 로딩되어 있는 학교들의 id
    school = School.where("(lat BETWEEN ? and ?) and (lng BETWEEN ? and ?)", min["_lat"], max["_lat"], min["_lng"], max["_lng"])
    school_id = school.map{|x| x.id}
    school_id -= indices # 이제 school_id에는 기존 naver map에 로딩되어 있지 않은 학교들의 id만 남아있음.
    if school_id.length == 0
      school = []
    else
      school = school.select{|x| school_id.include? x.id}# school_id에 존재하는 학교들만 school에 저장
    end
    # @school = School.all.limit(1000)
    respond_to do |format|
      format.json {render json: [school, school_id]}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
