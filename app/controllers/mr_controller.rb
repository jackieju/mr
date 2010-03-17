class MrController < ApplicationController
  before_filter :login_required
  def index
    render :layout=>"index"
  end
end
