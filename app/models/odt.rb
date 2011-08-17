class Odt < ActiveRecord::Base
  unloadable
  belongs_to :project




  def update(filename)
    increment(:yes)
  end

#has_attachment :content_type => :other,
#	:storage => :file_system,
#	:max_size => 20000.kilobytes
#
#validates_as_attachment

  def upload(filename)
  end

  def add_file(filename)
    @Odt << {:filename => filename}
  end
end
