# encoding: utf-8

class Chunk < ActiveRecord::Base

  has_paper_trail :ignore => [:position]

  default_scope { order('position ASC') }

  attr_accessible :title, :section, :content, :user_id, :book_id, :position, :original_updated_at

  belongs_to :user # creates the column user_id
  belongs_to :book # creates the column book_id

  before_validation { self.position ||= book.max_chunk_position + 1 }

  validates_presence_of :title, :book_id, :user_id, :position
  validates :title, :uniqueness => {:scope => :book_id}
  validates :position, :uniqueness => {:scope => :book_id}
  validate :handle_conflict, only: :update
  validates_format_of :section, :with => /^(M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})|[a-zA-Z].\d+|\d+(\.\d+)*)$/, :on => :create, :message => "not a valid section format: Use digits segregated with dots ( eg. 1.2.3 ), a single character and digits segregated with dots ( eg A.13 ) or roman format ( eg. IV)"
  validates_format_of :section, :with => /^(M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})|[a-zA-Z].\d+|\d+(\.\d+)*)$/, :on => :update, :message => "not a valid section format: Use digits segregated with dots ( eg. 1.2.3 ), a single character and digits segregated with dots ( eg A.13 ) or roman format ( eg. IV)"

  def username
    user.username
  end

  def sliced_attributes
    attributes.slice('title', 'section', 'content', 'user_id')
  end

  def original_updated_at
    @original_updated_at || updated_at.to_f
  end

  attr_writer :original_updated_at

  private
  def handle_conflict
    if @conflict || updated_at.to_f > original_updated_at.to_f
      @conflict = true
      @original_updated_at = nil
      errors.add :base, I18n.t('views.chunk.messages.merge_changes')
      changes.each do |attribute, values|
        unless attribute == 'content'
          errors.add attribute, "#{I18n.t('views.chunk.messages.was_changed_to')} #{values.first}."
        else
          errors.add attribute, I18n.t('views.chunk.messages.was_changed')
          self.content = "== #{I18n.t('views.chunk.messages.content_other')} =="
          self.content << values.first
          self.content << "== #{I18n.t('views.chunk.messages.content_own')} =="
          self.content << values.last
        end
      end
    end
  end

end