class MessagesController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  
  #admin actions
  
  def index
    @messages = Message.find(:all)
  end
  
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      redirect_to new_message_path, notice: 'Your request has been submitted. Thank you. We will respond to you in 48 hours.'
      MessageMailer.notify(@message).deliver
    else
      render :new
    end
  end
  
  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])
    if @message.update(message_params)
      redirect_to @message, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  def mark_read
    @message = Message.find(params[:id])
    if @message.update_attributes(:read => true)
      redirect_to messages_path, :notice => 'Message was marked as read.'
    else
      render :action => "edit"
    end
  end

  def mark_unread
    @message = Message.find(params[:id])
    if @message.update_attributes(:read => false)
      redirect_to messages_path, :notice => 'Message was marked as unread.'
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to messages_url
  end

  private
  
  def message_params
    params.require(:message).permit(:content, :email, :from, :read, :date_created)
  end
end
