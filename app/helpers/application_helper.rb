module ApplicationHelper

  # Displays alert flash message. Flash messages of different type will be omitted.
  def flash_messages
    if flash.key?(:alert)
      render :partial => 'shared/modal_flash_message', :locals => { :type => :alert, :message => flash[:alert] }
    elsif flash.key?(:notice)
      render :partial => 'shared/modal_flash_message', :locals => { :type => :notice, :message => flash[:notice] }
    end
  end
end
