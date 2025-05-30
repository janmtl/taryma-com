class PagesController < ApplicationController
  before_filter :require_login, :except => [:view]
  
  #admin actions
  
  def index
    @pages = Page.find(:all)
  end
  
  def new
    @page = Page.new
    1.times { @page.page_attachments.build }
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      redirect_to @page, :notice => 'Page was successfully created. <a href="'+new_page_path+'" class="btn">Create another</a>'.html_safe
    else
      render :action => "new"
    end
  end
  
  def edit
    @page = Page.find(params[:id])
  end

  def show
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to @page, :notice => 'Page was successfully updated.'
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to pages_url
  end

  #application actions

  def view
    @page = Page.find(params[:id]) if params[:id]
    @page = Page.find_by_slug(params[:slug]) if params[:slug]
    @base_path = 'p/'+@page.slug
  end
end
