class Booksearch
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :is_advanced, :is_public, :title, :author, :genre, :is_published, :publishdate_from, :publishdate_to, :user_id

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted? # model don't need to be persisted
    false
  end

  def search
    books = search_simple.joins(:users).where("users.id" => @user_id.to_i) if(!is_public? && !is_advanced?)
    books = search_simple if(is_public? && !is_advanced?)
    books = search_extended.joins(:users).where("users.id" => @user_id.to_i) if(!is_public? && is_advanced?)
    books = search_extended.joins(:users) if(is_public? && is_advanced?)
    books
  end

  def is_advanced?
    @is_advanced == '1'
  end

  def is_public?
    @is_public == '1'
  end

  def is_for_published_books?
    @is_published == '1'
  end

  private
  def search_simple
    if @title
      Book.where('title LIKE ?', "%#{@title}%")
    else
      Book.scoped
    end
  end

  def search_extended
    if (@title && is_for_published_books?)
      dFrom = Date.new(@publishdate_from.to_i,1,1)
      dTo = Date.new(@publishdate_to.to_i,12,31)
      dTo,dFrom = dFrom,dTo if(dTo < dFrom)
      Book.where('title LIKE ?', "%#{@title}%").where('genre LIKE ?',"%#{@genre}%").where(:published => dFrom..dTo).joins(:users).where('users.username LIKE ?', "%#{@author}%")
    elsif(@title && !is_for_published_books?)
      Book.where('title LIKE ?', "%#{@title}%").where('genre LIKE ?',"%#{@genre}%").joins(:users).where('users.username LIKE ?', "%#{@author}%")
    else
      Book.scoped
    end
  end

end
