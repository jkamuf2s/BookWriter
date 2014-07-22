module ConversationsHelper
  # Generally: Overloading is not allowed in ruby

  def number_of_all_unreadMessages
    conversations = current_user.mailbox.inbox
    conversations.each do |c|
      number += numberOfunreadMessages(c)
    end
    return number
  end

  def number_of_unreadMessages(conversationInstance)
    number = 0
    conversationInstance.receipts_for(current_user).each do |receipt|
      if !receipt.is_read?
        number += 1
      end
    end
    return number
  end

end
