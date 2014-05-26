require 'test_helper'

class ChunkTest < ActiveSupport::TestCase

  test 'username' do
    chunk = Chunk.new
    user = users(:mmuster)
    chunk.user = user
    assert_equal(chunk.username, user.username)
  end


  test 'chunk_section_validates_format_of' do
    chunk = Chunk.new

    assert !chunk.save

    chunk.section = "sdf"


  end


end
