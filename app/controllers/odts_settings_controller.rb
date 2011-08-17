class OdtsSettingsController < ApplicationController
  unloadable
  
  def test_xsltfile
    flash = "error"
    begin
      dirs = Rails.root.join(params[:file]).list.join()
      flash = "notice"
      if dirs == ""
        dirs = "file not found: #{file}"
        flash = "warning"
      else
        dirs = "OK: #{file}"
      end
    rescue Errno::ENOENT => msg
      dirs = msg
    end

    render :text => "<div id=\"test-result\" class=\"flash #{flash}\">#{dirs}</div>"
  end
end
