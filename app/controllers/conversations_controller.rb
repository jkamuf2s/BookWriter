class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  after_filter :read_conversation, :only => [:show] # mark all conversation-Messages as Read
  helper :conversations
  helper_method :mailbox, :conversation

  # /conversations
  def index
    @mailbox = mailbox # Mailbox initialisieren
  end

  # /conversations/new
  def new
    # not needed, because Mailboxer creates a conversation automatically by first "send_message"-method invoke
  end

  # /conversations/create
  def create
    recipient_names = conversation_params(:recipients).split(',')
    recipients = User.where(username: recipient_names).all

    conversation = current_user.send_message(recipients, *conversation_params(:body, :subject)).conversation
    redirect_to conversation
  end

  # /conversations/:id
  def show
    @conversation ||= conversation
    respond_to do |format|
      format.html { render_check_template }
      format.json { render json: @conversation }
    end
  end

  #  /conversations/:id/reply
  def reply
    @conversation = conversation
    current_user.reply_to_conversation(@conversation, *message_params(:body, :subject))
    flash[:notice] = "Message has been sent!"
    redirect_to @conversation
  end

  # /conversations/:id/trash
  def trash
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  private
  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end

  def read_conversation
    conversation.mark_as_read(current_user)
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
        when 0 then self
        when 1 then self[subkeys.first]
        else subkeys.map{|k| self[k] }
      end
    end
  end

end
