namespace :price_variation do

  desc "Recreate All Graph"
    task :recreate_all_graph => :environment do

      # Affichage de Rake en cours
      p '#############################'
      p '#        Recreate All Grap             #'
      p '#############################'

      Product.find(:all).each do |product|
        price_variation=PriceVariation.find(:first,:conditions=>["product_id=?",product.id])
        price_variation.draw_graph
        p "Draw graph Product =#{product.name}"
      end
    end

end