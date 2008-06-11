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
  
  def expect_change_of(field)
    @mock_tag.expects("#{field}=".to_sym).with("new #{field}")
  end 
  
  def stub_frame_to_do_nothing
    @mock_tag.stubs(:frame).returns({})
  end  

  def stub_frame_to_return_empty_hash_for(id)
    hash = {}
    @mock_tag.stubs(:frame).with(id).returns(hash)
    hash
  end   
  
  def stub_setters(methods)
    methods.each do |method|
      @mock_tag.stubs("#{method}=".to_sym)
    end            
  end  
  
  def setting_artist_should_update_text_for(id)
    hash = stub_frame_to_return_empty_hash_for(id)
    @mtag.artist = 'new artist'
    hash[:text].should == 'new artist'
  end  
end

describe MTag do
  include MTagSpecHelper
  
  before :each do
    @mock_tag = mock
    ID3Lib::Tag.stubs(:new).with('path/to/track.mp3').returns(@mock_tag)		 
    @mtag = MTag.new('path/to/track.mp3')
  end
  
  describe 'new' do
    it 'should set the current file path' do
      @mtag.file_path.should == 'path/to/track.mp3'
    end
    
    it 'should load title' do
      expect_call_to :title
      @mtag.title.should == 'title'
    end

    it 'should load artist' do
      expect_call_to :artist
      @mtag.artist.should == 'artist'
    end

    it 'should load album' do
      expect_call_to :album
      @mtag.album.should == 'album'
    end

    it 'should load genre' do
      expect_call_to :genre
      @mtag.genre.should == 'genre'
    end

    it 'should load url' do
      @mock_tag.expects(:frame).with(:WXXX).returns({ :url => 'address' })
      @mtag.url.should == 'address'
    end

    it 'should load track_number' do
      @mock_tag.expects(:frame).with(:TRCK).returns({ :text => '10' })
      @mtag.track_number.should == 10
    end
  end
  
  describe 'changing values' do	  
    it 'should change the title' do		  
      expect_change_of :title
      @mtag.title = 'new title'
    end
        
    describe 'setting the artist' do
      before :each do
        stub_frame_to_do_nothing
        stub_setters [ :artist, :composer ]
      end
      
      it 'should update the artist field' do
        expect_change_of :artist
        @mtag.artist = 'new artist'
      end  
      
      it 'should update the composer field' do
        @mock_tag.expects(:composer=).with('new artist')
        @mtag.artist = 'new artist'
      end
            
      it 'should update the orig. artist field' do
        setting_artist_should_update_text_for(:TOPE)
      end
      
      it 'should update the copyright field' do
        setting_artist_should_update_text_for(:TCOP)
      end
      
      it 'should update the encoded by field' do
        setting_artist_should_update_text_for(:TENC)
      end
    end
          
    it 'should set the genre with added index for id3-v1 tags' do
      [ 'Trance', 'Dance', 'Metal', 'Pop' ].each do |genre|
        index = ID3Lib::Info::Genres.index(genre)
        @mock_tag.expects(:genre=).with("(#{index})#{genre}")
        @mtag.genre = genre
      end
    end  
    
    it 'should throw a useful error when a genre does not exist' do
      lambda { @mtag.genre = 'Non-Existant-Genre'
      }.should raise_error(ArgumentError,
              'Genre "Non-Existant-Genre" does not exist for ID3 v1')
    end
 
    describe 'setting the url' do
      before :each do
        stub_frame_to_do_nothing
        @mock_tag.stubs(:comment=)
      end
      
      it 'should update the url field' do
        hash = stub_frame_to_return_empty_hash_for(:WXXX)  	    
        @mtag.url = 'new-url'	    
        hash[:url].should == 'new-url'
      end
      
      it 'should set the comment field' do
        @mock_tag.expects(:comment=).with('new-url')
        @mtag.url = 'new-url'
      end                  
    end
                
    it 'should change the track_number' do
      hash = stub_frame_to_return_empty_hash_for(:TRCK)
      @mtag.track_number = 10
      hash[:text].should == '10'
    end
    
    it 'should set the year' do
      @mock_tag.expects(:year=).with("2008")
      @mtag.year = 2008
    end
  end
  
  describe 'save' do
    before :each do
      @mock_tag.stubs(:update!)
      @mtag.stubs(:title).returns('title')
      @mtag.stubs(:artist).returns('artist')      
    end
    
    it 'should update the id3 tags' do
      @mock_tag.expects(:update!)
      @mtag.save
    end
    
    it 'should rename the file' 
    
    it 'should save the new file name' do
      @mtag.save
      @mtag.file_path.should == 'path/to/artist - title.mp3'      
    end
  end
end
