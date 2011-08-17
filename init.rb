require 'redmine'

TEMPLATE_DIR = "./vendor/plugins/redmine/odts/conv1.xslt"

Redmine::Plugin.register :redmine_odts do
  name 'Redmine Odt plugin'
  author 'Tommi Rintala'
  description 'This is a plugin for uploading ODT (Open Office Writer) documents to Redmine (wiki). 
Bugs: 
* bullet and numbered lists are converted to bullet lists 
* No support for italics, bold or underlining'
  version '0.0.4'
  url 'http://www.wasalab.com/~t2r/odts/'
  author_url 'http://www.wasalab.com/~t2r/'

  settings :default => {"xsltfile" => TEMPLATE_DIR}

  project_module :odts do
    permission :view_odts, :odts => :index
    permission :update_odts, :odts => :update
    permission :upload_odts, :odts => :upload
  end


  menu :project_menu, :odts, { :controller => 'odts', :action => 'index' }, :caption => 'Odts', :after => :activity, :param => :project_id, :before => :settings

end
