class StylesheetsController < ApplicationController
  caches_page :style
  
  def style
    respond_to do |format|
      format.css do
        render
      end
    end
    
  end
  
end
