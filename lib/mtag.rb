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

require 'rubygems'
require 'id3lib'

class MTag
  attr_reader :file_path
  
  def initialize(file_path)
    @tag = ID3Lib::Tag.new(file_path)
    @file_path = file_path
  end
  
  def artist=(new_artist)
    @tag.artist = new_artist
    @tag.composer = new_artist
    @tag.frame(:TOPE)[:text] = new_artist # Orig. Artist
    @tag.frame(:TCOP)[:text] = new_artist # Copyright
    @tag.frame(:TENC)[:text] = new_artist # Encoder
  end
  
  def url
    @tag.frame(:WXXX)[:url]
  end
  
  def url=(new_url)
    @tag.frame(:WXXX)[:url] = new_url
    @tag.comment = new_url
  end
  
  def track_number
    @tag.frame(:TRCK)[:text].to_i
  end
  
  def track_number=(new_number)
    @tag.frame(:TRCK)[:text] = new_number.to_s    
  end
  
  def year=(new_year)
    @tag.year = new_year.to_s
  end
  
  def genre=(new_genre)
    index = ID3Lib::Info::Genres.index(new_genre)
    
    raise ArgumentError,
      "Genre \"#{new_genre}\" does not exist for ID3 v1" unless index
          
    @tag.genre = "(#{index})#{new_genre}"
  end
      
  # Any getters or setters that are the same for MTag and ID3Lib
  # are simply forwarded
  def method_missing(name, arguments = nil)    
    @tag.send(name, arguments)
  end
  
  def save
    @tag.update!
  end  
end
