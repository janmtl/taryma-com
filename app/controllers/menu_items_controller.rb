class MenuItemsController < ApplicationController
  before_filter :require_login
  
  #admin actions
  
  def index
    @menu_items = MenuItem.find(:all, :order => :position)
  end
  
  def new
    @menu_item = MenuItem.new
  end

  def create
    @menu_item = MenuItem.new(params[:menu_item])

    if @menu_item.save
      redirect_to @menu_item, :notice => 'Menu Item was successfully created. <a href="'+new_menu_item_path+'" class="btn">Create another</a>'.html_safe
    else
      render :action => "new"
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
    if @menu_item.update_attributes(params[:menu_item])
      redirect_to @menu_item, :notice => 'Menu Item was successfully updated.'
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @menu_item = MenuItem.find(params[:id])
    @menu_item.destroy
    redirect_to menu_items_url
  end
end