class InvitationRequestsController < ApplicationController
  before_filter :require_admin, :except => [:new, :create, :show]
  respond_to :html, :js
  def index
  
    condition = case params[:view]
      when 'declined'
        {:status => 'declined'}
      when  'invited'
        {:status => 'invited'}
      when  'all'
        {}
      else # params[:view] == 'new'
        {:status => 'new'}
      end
    @invitation_requests = InvitationRequest.where(condition).order('created_at DESC')
    @user = User.new()
    respond_with(@invitation_requests)
  end

  def new
    @invitation_request = InvitationRequest.new    
    respond_with(@invitation_request)
  end
  
  def create
    @invitation_request = InvitationRequest.new(params[:invitation_request])   
     @invitation_request.roles = params[:roles]
    if @invitation_request.save
      redirect_to @invitation_request, :notice=> "Thank you for your interest."
    else
      render :action=>"new"
    end
  end
  
  def show
    @invitation_request = InvitationRequest.new(params[:id])    
    respond_with(@invitation_request)
  end
  
  def decline
    @invitation_request = InvitationRequest.find(params[:id])    
    begin
      #Notification.decline_invitation_request_email(@invitation_request).deliver    
      @invitation_request.decline!
    rescue
    end
    respond_with(@invitation_request)
  end
  
  def invite
    @invitation_request = InvitationRequest.find(params[:id])    
    #TODO code to invite user call generate new user with params from invitation
    prms = @invitation_request.attributes
    %w{company_name status notes}.each{|col|    prms.delete(col)}
    @user = User.generate_for_invite(prms)
    if @user.save
      begin
        Notification.accept_invitation_request_email(@user).deliver    
        @invitation_request.invite!
      rescue Exception => e
        render :text => '' and return
      end
    else
      render :text => '' and return
    end    
    respond_with(@invitation_request)
  end
  
  def add_user
    prms = params[:user]
   # %w{company_name}.each{|col|    prms.delete(col)}
    @user = User.generate_for_invite(prms)
    if @user.save
      begin
        Notification.accept_invitation_request_email(@user).deliver    
        @user = User.new
      rescue Exception => e
        render :text => '' and return
      end    
    end 
  end
end
