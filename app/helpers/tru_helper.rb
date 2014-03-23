module TruHelper

  def state_draw_markers(page) # also returns the sidebar html

    html = ''
    county_names = []
    for county in @counties
      html += "<a href='/tru/county?state_id=#{@state_id}&county_id=#{county.id}'>#{county.name}</a> <br />"
      #puts "#{county.id}: #{county.name}"
      county_names << "'#{county.name}'"
    end
    criteria_str = county_names.join(',')
    counties = TruCounty.get_county_info(criteria_str)
    
    color2icons = init_color_icons(page)
    geopoints = []
    for county in counties
      puts "#{county.id}: #{county.name}"
      geopoints << {:lat => county.lat, :lng => county.lng}
      icon = get_icon(color2icons, 1, 900)
      page << @map.add_overlay(GMarker.new([county.lat.to_f, county.lng.to_f], 
                                  :icon => icon,
                                  :title => county.name,
                                  :info_window => '')) 
    end
    
    page << @map.set_center(GLatLng.new(find_geo_center(geopoints)), find_scale_level(geopoints)) 
    #page << @map.set_center(GLatLng.new(find_geo_center(geopoints)), 9) 

    html
  end

end
