# Copyright (c) 2008 Joakim K.
# 
# This software is provided 'as-is', without any express or implied warranty.
# In no event will the authors be held liable for any damages arising from
# the use of this software.
# 
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
# 
# 1. The origin of this software must not be misrepresented; you must
#    not claim that you wrote the original software. If you use this
#    software in a product, an acknowledgment in the product documentation
#    would be appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not
#    be misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

require 'spec/spec_helper.rb'
require 'lib/mtag.rb'

module MTagSpecHelper
  def expect_call_to(method_name)
    @mock_tag.expects(method_name).returns(method_name.to_s)
  end
end

describe MTag do
  include MTagSpecHelper
  
	describe 'new' do
		before :each do
      @mock_tag = mock
		  ID3Lib::Tag.stubs(:new).with('track.mp3').returns(@mock_tag)		 
		  @mtag = MTag.new('track.mp3')
		end

		it 'should load title' do
		  expect_call_to(:title)
			@mtag.title.should == 'title'
		end

		it 'should load artist' do
		  expect_call_to(:artist)
			@mtag.artist.should == 'artist'
		end

		it 'should load url' do
		  @mock_tag.expects(:frame).with(:WXXX).returns({ :url => 'address' })
			@mtag.url.should == 'address'
		end

		it 'should load album' do
      expect_call_to(:album)
      @mtag.album.should == 'album'
		end

		it 'should load genre' do
      expect_call_to(:genre)
      @mtag.genre.should == 'genre'
		end

		it 'should load track_number' do
		  @mock_tag.expects(:frame).with(:TRCK).returns({ :text => '10' })
			@mtag.track_number.should == 10
		end
	end
end
