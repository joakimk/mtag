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

describe MTag do
	describe 'new' do
		before :each do
		 
		end

		it 'should load track' do
		  @mock_tag = mock
		  ID3Lib::Tag.stubs(:new).with('track.mp3').returns(@mock_tag)
			@mock_tag.expects(:title).returns('track#1')
			
			@mtag = MTag.new('track.mp3')
			@mtag.title.should == 'track#1'
		end

#		it 'should load artist' do
#
#		end
#
#		it 'should load url' do
#			
#		end
#
#		it 'should load album' do
#
#		end
#
#		it 'should load genre' do
#
#		end
#
#		it 'should load track_number' do
#
#		end
	end
end
