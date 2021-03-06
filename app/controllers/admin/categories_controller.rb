class Admin::CategoriesController < ApplicationController
  layout "admin"
  before_action :load_category, except: [:index]
  before_action :require_admin

  def index
    @search_categories = Category.search(params[:category_name])
      .paginate(page: params[:page], per_page: Settings.categories_per_page)
    @categories = Category.all.order("left_node")
  end

  def new
    @categories = Category.all
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.set_category params[:parent_id]
        flash[:success] = t ".add_category_successful"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t ".category_updated"
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t ".update_failed"
      render :edit
    end
  end

  def edit
  end

  def destroy
    @category.destroy
    flash[:success] = t ".category_deleted"
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit :category_name, :description
  end

  def load_category
    @category = Category.find_by id: params[:id]
  end
end
