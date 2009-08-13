# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class PriceVariationExtension < Spree::Extension
  version "1.0"
  description "Add Price Variation to Products"
  url "http://yourwebsite.com/spree_price_variation"

  def activate
    # admin.tabs.add "Spree Accessories", "/admin/spree_accessories", :after => "Layouts", :visibility => [:all]

    Product.class_eval do
      has_many :price_variations
      after_save :save_price

      def save_price
        if regular_price_changed? or special_price_changed?
          price=PriceVariation.find(:first,:conditions=>{:product_id=>self.id,:change_date=>Date.today.to_s[0..6]})
          if price.nil?
            PriceVariation.create({:product_id=>self.id,:value=>self.final_price,:change_date=>Date.today.to_s[0..6]})
          else
            price.update_attributes({:value=>self.final_price})
          end
        end
      end
    end

    # register Accessories product tab
    Admin::BaseController.class_eval do
      before_filter :add_price_variations_tab

      private
      def add_price_variations_tab
        @product_admin_tabs << {:name => t('price_variations'), :url => "selected_admin_product_price_variations_url"}
      end
    end

  end
end