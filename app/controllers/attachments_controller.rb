class AttachmentsController < ApplicationController
  before_action :find_attachment

  respond_to :js

  def destroy
    if current_user.author_of?(@attachment.attachable)
      respond_with(@attachment.destroy)
    else
      flash.now[:alert] = "You can't delete someone else's attachment"
    end
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
