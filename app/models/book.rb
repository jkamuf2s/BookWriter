class Book < ActiveRecord::Base

  attr_accessible :title, :edition, :published, :genre, :abstract, :tags, :user_ids, :closed

  has_and_belongs_to_many :users
  has_many :chunks

  validates_presence_of :title, :edition

  # custom error message for the author checkboxes displays the translation defined in C:\RubyOnRailsProject\BookWriter\config\locales\*.yml
  validates_presence_of :users, :message => I18n.translate('errors.messages.must_be_selected')


  validates :edition, :uniqueness => {:scope => :title}
  before_destroy :destroy_chunks

  def sliced_attributes
    attributes.slice('title', 'genre', 'abstract', 'tags')
  end

  def published?
    !published.nil?
  end

  def is_author?(author)
    self.users.map(&:id).include?(author.id)
  end

  def has_chunks?
    !chunks.empty?
  end

  def max_chunk_position
    has_chunks? ? chunks.max_by(&:position).position : 0
  end

  def users_list
    users.collect { |u| u.username }.join(',')
  end

  def users_list_real_names
    users.collect { |u| u.first_name + ' ' + u.last_name }.join(',')
  end

  private
  def destroy_chunks
    chunks.each do |chunk|
      chunk.destroy
    end
  end

end