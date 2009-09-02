class PriceVariation < ActiveRecord::Base

  belongs_to :product

  after_save :draw_graph

  named_scope :ordered, :order=>"change_date DESC"


    def draw_graph
      require 'gruff'



      g = Gruff::Line.new("200x125")  #width size
      g.theme=self.theme_spree
      g.hide_legend=true
      g.top_margin=5
      g.left_margin=10
      g.font = File.expand_path('usr/share/fonts/truetype/ttf-dejavu/DejaVuSansMono-Bold.ttf',"/")


      g.bottom_margin=0
      g.marker_font_size=40 #Font size of label

      prices=PriceVariation.find_by_sql(" SELECT *
      FROM price_variations
      INNER JOIN (
      SELECT product_id
      FROM price_variations
      WHERE price_variations.id =#{self.id}
      ) AS ptmp ON ( price_variations.product_id = ptmp.product_id )
      WHERE change_date>#{1.year.ago.to_s(:db).to_date.to_s[0..6]}
      ORDER BY change_date")
      return if prices.nil?

      x_axis=[]
      y_axis={}

      month_before_price=nil
      date_temp=1.year.ago.to_date
      (0..12).each do |index|
        price=prices.find{ |i| date_temp.to_s[0..6]==i.change_date.to_s}
        if price
           x_axis << price.value
           month_before_price=price.value
        else
           x_axis << month_before_price
        end
        #Show only even month
        if index.modulo(2)!=0
          y_axis.merge!({index=>I18n.t(:"date.abbr_month_names")[date_temp.month]})
        end
        date_temp=date_temp>>1
      end

      g.data("",x_axis)
      g.labels = y_axis

      find_min_val=prices.min {|a,b| a.value <=> b.value }.value.to_i-100
      if find_min_val>0
        g.minimum_value= find_min_val
      else
        g.minimum_value=0
      end

      directory="#{RAILS_ROOT}/public/assets/price_variation/#{prices.first.product_id}"

      FileUtils.makedirs(directory) if !File::exist?(directory)

      g.write("#{directory}/prices.png")
    end

    protected
      def theme_spree
        # Colors
        @blue='#00c1cb'
        @yellow='#f7a50d'
        @green = '#00ff00'
        @grey = '#333333'
        @orange = '#ff5d00'
        @red = '#f61100'
        @white = 'white'
        @light_grey = '#999999'
        @black = 'black'
        @colors = [@blue,@yellow,@orange,@green, @grey, @red, @white, @light_grey, @black]

        theme = {
          :colors => @colors,
          :marker_color => '#7e7e7e',
          :font_color => '#7e7e7e',
          :background_colors => ['#ffffff', '#eeeeee']
        }
      end
end
