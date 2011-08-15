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
      @invitation_request.decline!
    rescue
    end
    respond_with(@invitation_request)
  end

  def invite
    @invitation_request = InvitationRequest.find(params[:id])
    prms = @invitation_request.attributes
    %w{status notes}.each{|col|    prms.delete(col)}
    @user = User.generate_for_invite(prms)
    if @user.save
      begin
        fdl = FakeDataLoader.new :user_id => @user.id,
                                 :number_of_items => 10,
                                 :images_data_dir => File.join('data','images_for_inv_users')
        fdl.run
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
    @user = User.generate_for_invite(prms)
    if @user.save
        fdl = FakeDataLoader.new :user_id => @user.id,
                                 :number_of_items => 10,
                                 :images_data_dir => File.join('data','images_for_inv_users')
        fdl.run
        Notification.accept_invitation_request_email(@user).deliver
        @user = User.new
    end
  end
end

