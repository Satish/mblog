class PagesController < ApplicationController
 
  before_filter :find_page

  def show; end

  #------------------------- private ----------------------------
  private

  def find_page
    @page = Page.active.find_by_permalink(params[:permalink])
    flash[:error] = PAGE_NOT_FOUND and redirect_to root_path and return unless @page
  end

end