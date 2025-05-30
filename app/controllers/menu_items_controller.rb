class MenuItemsController < ApplicationController
  before_action :require_login
  
  #admin actions
  
  def index
    @menu_items = MenuItem.find(:all, :order => :position)
  end
  
  def new
    @menu_item = MenuItem.new
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      redirect_to @menu_item, notice: 'Menu Item was successfully created. <a href="'+new_menu_item_path+'" class="btn">Create another</a>'.html_safe
    else
      render :new
    end
  end
  
  def edit
    @menu_item = MenuItem.find(params[:id])
  end

  def show
    @menu_item = MenuItem.find(params[:id])
  end

  def update
    @menu_item = MenuItem.find(params[:id])
    if @menu_item.update(menu_item_params)
      redirect_to @menu_item, notice: 'Menu Item was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @menu_item = MenuItem.find(params[:id])
    @menu_item.destroy
    redirect_to menu_items_url
  end

  private

  def menu_item_params
    params.require(:menu_item).permit(:label, :path, :position)
  end
end