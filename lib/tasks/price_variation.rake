namespace :price_variation do

  desc "Recreate All Graph"
    task :recreate_all_graph => :environment do

      # Affichage de Rake en cours
      p '#############################'
      p '#        Recreate All Grap             #'
      p '#############################'

      Product.find(:all).each do |product|
        price_variation=PriceVariation.find(:first,:conditions=>["product_id=?",product.id])
        if !price_variation.nil?
          price_variation.draw_graph
        else
           price_variation=PriceVariation.create({:product_id=>product.id,:value=>product.master_price,:change_date=>Date.today.to_s[0..6]})
           price_variation.draw_graph
        end
        p "Draw graph Product =#{product.name}"
      end
    end

end