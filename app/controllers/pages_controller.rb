class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:view]
  
  #admin actions
  
  def index
    @pages = Page.find(:all)
  end
  
  def new
    @page = Page.new
    1.times { @page.page_attachments.build }
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to @page, notice: 'Page was successfully created. <a href="'+new_page_path+'" class="btn">Create another</a>'.html_safe
    else
      render :new
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
    if @page.update(page_params)
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render :edit
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
    Rails.logger.debug "Page: #{@page.inspect}"
    @base_path = 'p/' + @page.slug
  end

  private
  
  def page_params
    params.require(:page).permit(:content, :title, :slug, page_attachments_attributes: [:id, :image_id, :_destroy])
  end
end
