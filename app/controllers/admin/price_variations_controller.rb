class Admin::PriceVariationsController < Admin::BaseController
  resource_controller
  before_filter :load_object, :only => [:selected ]
  actions :edit,:update,:delete
  
  belongs_to :product

  def selected
    @price_variations = @product.price_variations.ordered
  end

  update.response do |wants|
    wants.html { redirect_to :action=>:selected }
  end

end
