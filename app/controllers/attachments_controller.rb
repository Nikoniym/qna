class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])

    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
      flash.now[:notice] = 'Your attachment successfully destroy'
    else
      flash.now[:alert] = "You can't delete someone else's attachment"
    end
  end
end
