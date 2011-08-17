require "rexslt"

class OdtsController < ApplicationController
  unloadable
  layout "base"

  helper :attachments
  include AttachmentsHelper

  before_filter :find_project, :authorize, :only => :index

  def index
    # @odts = Odt.find(:all)
  end


  def upload
     st = my_handle_file(params[:description], params[:filename])

     redirect_to :action => 'index', :project_id => Project.find(params[:project_id])
     flash[:notice] = "Uploaded file as '#{params[:description]}'"
     return
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end


  def my_handle_file(thetitle, filename)
    # unzip odt file
    mypath = deflate_content(filename)
    content = File.join(mypath, 'content.xml')

    # run xslt transformation to file
    str = my_xslt_transform(content, mypath)

    # upload page content to wiki
    thepage = my_upload_to_wiki(thetitle, str)

    # MS -office   images
    if File.exist?(mypath + "/media")
      imagedir = Dir.new(mypath + "/media")
      imagedir.each { |x| my_upload_image(thepage, mypath + "/media/" + x)}    
    end
   
    # OpenOffice images
    if File.exist?(mypath + "/Pictures")
      imagedir = Dir.new(mypath + "/Pictures")
      imagedir.each { |x| my_upload_image(thepage, mypath + "/Pictures/" + x)}
    end


    FileUtils.remove_dir(mypath)

    return ""
  end


  def my_upload_image(page, x)
    # if it is a directory, return

    if File.directory?(x)
      return ""
    end


    tmpfile = File.basename(x) + "-#{Time.now.to_i}.tmp"

    af = ActionController::UploadedTempfile.new(tmpfile)
    af.binmode
    af.write(IO.read(x))
    af.original_path = x

    if File.fnmatch?('*.png', x)
      af.content_type = "image/png"
    else
      af.content_type = "image/jpeg"
    end

    af.rewind


    att = Attachment.create(
      :container => page,
      :file => af,
      :description => "autoloaded image",
      :author => User.current  )

    af.unlink
  end

  def my_xslt_transform(xmlfile, path)
    result = "ERROR IN TRANSFORM"
    begin
      xsltfile = Rails.root.join("vendor/plugins/redmine_odts/conv1.xsl")
      tmpfile = "/tmp/xsltoutput.txt"
      
      # we trust here that it is executable
      if File.exists?("/usr/bin/xsltproc")
        xsltproc = "/usr/bin/xsltproc"
      elsif File.exists?("/opt/bitnami/common/bin/xsltproc")
        xsltproc = "/opt/bitnami/common/bin/xsltproc"
      end
      
      system(xsltproc + " -o #{tmpfile} #{xsltfile} #{xmlfile}")
      
    rescue Errno::ENOENT => msg
      f = File.new("/tmp/xslt-error.txt", "w")
      f.write( xsltproc + " -o #{tmpfile} #{xsltfile} #{xmlfile}\n\n")
      f.write(msg)
      f.close()
      flash[:error] = msg
    end
 
    result = IO.readlines(tmpfile)

    return result.to_s
  end

#  def my_xslt_transform_rubyxslt(xmlcontent, path)
#    convfile = File.join(TEMPLATE_DIR, "conv1.xsl")
#    stylesheet = File.readlines(convfile.expandpath()).to_s
#    xms_doc = File.readlines(xmlcontent).to_s
#    
#    sheet = XSLT::Stylesheet.new(stylesheet, arguments)
#
#    str = ""
#    sheet.output [ str ]
#    sheet.apply(xml_doc)
#
#      f = File.new("/tmp/output.txt", "w")
#      f.write(msg)
#      f.close()
#
#
#    f = File.new("/tmp/output.txt", "w+")
#    sheet.apply(xml_doc, f)
#    f.close()
#  end



  def my_upload_to_wiki(title, wikicontent)
    page_title = title
    page_title ||= "odts-#{Time.now.to_i}"
    project = Project.find(params[:project_id])
#    wiki = project.wiki
    @auto_page = project.wiki.find_or_new_page(page_title)
    @auto_page.content = WikiContent.new(:text => wikicontent.to_s, 
					:comments => "added by automate",
					:author  => User.current)

    @auto_page.save
    return @auto_page
  end



  def deflate_content(filename)
    # setup a temporary path
    workdir = File.join(Dir.tmpdir, "odts-#{Time.now.to_i}")
    Dir.mkdir workdir
    realname = filename.path()

    # write entry to database, why bother?
#    @file = Odt.new
#    @file.filename = filename.original_filename
#    @file.save

    # unzip to temporary path
    command = "/usr/bin/unzip #{realname} -d #{workdir}"
    success = system(command)

    success && $?.exitstatus == 0
    return workdir
  end

end
