class InvitationsController < ApplicationController
  include Devise::Controllers::InternalHelpers
  include Devise::Controllers::Common

  before_filter :authenticate_resource!, :only => [:new, :create]
  before_filter :require_no_authentication, :only => [:edit, :update]
  helper_method :after_sign_in_path_for

  # POST /resource/invitation
  def create
    self.resource = resource_class.send(send_instructions_with, params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      redirect_to after_sign_in_path_for(resource_name)
    else
      render_with_scope :new
    end
  end

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.invitation_token = params[:invitation_token]
    render_with_scope :edit
  end

  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_in_and_redirect(resource_name, resource)
    else
      render_with_scope :edit
    end
  end

  protected
  def send_instructions_with
    :send_invitation
  end
end
