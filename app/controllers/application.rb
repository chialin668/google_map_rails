# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_gmap_session_id'

  def current_year
    return '2007'
  end

  def app_base
#    return '/gmap'
    return ''
  end

  def gmap_boundary_by_zoom_level
    #
    # To retrieve information, use: 
    # http://localhost:3000/gmap_geobound.html
    #
    boundary=[]
    boundary[0] = [[-89.72647879678343, -180], [89.93411921886802, 180]]
    boundary[1] = [[-82.02137801950886, -180], [88.07532853412853, 180]]
    boundary[2] = [[-48.92249926375824, 120.23437499999997], [79.56054626376365, -4.21875]]
    boundary[3] = [[-7.885147283424331, 178.9453125], [66.01801815922042, -63.28125]]
    boundary[4] = [[16.04581345375217, -151.611328125], [54.1109429427243, -92.724609375]]
    boundary[5] = [[27.254629577800063, -136.845703125], [46.40756396630067, -107.40234375]]
    boundary[6] = [[32.491230287947594, -129.5068359375], [42.08191667830631, -114.78515625000001]]
    boundary[7] = [[35.00300339527669, -125.826416015625], [39.80009595634838, -118.46557617187501]]
    boundary[8] = [[36.230981283477924, -123.98071289062499], [38.62974534092597, -120.30029296874999]]
    boundary[9] = [[36.84006462037767, -123.06335449218751], [38.039438891821725, -121.22314453125001]]
    boundary[10] = [[37.14170874010794, -122.6019287109375], [37.74139927315054, -121.68182373046875]]
    boundary[11] = [[37.292081740702365, -122.37190246582031], [37.59192743186127, -121.91184997558595]]
    boundary[12] = [[37.366882922327626, -122.2568893432617], [37.516806367148575, -122.02686309814455]]
    boundary[13] = [[37.404391941703665, -122.19938278198242], [37.479353670749205, -122.08436965942383]]
    boundary[14] = [[37.42313941392658, -122.17062950134277], [37.46062027927878, -122.11312294006348]]
    boundary[15] = [[37.43254546808027, -122.15629577636717], [37.45128589232625, -122.12754249572755]]
    boundary[16] = [[37.437213976341035, -122.14908599853514], [37.44658419061043, -122.13470935821535]]
    boundary[17] = [[37.43955663991349, -122.1454918384552], [37.444241747049816, -122.13830351829529]]
    
    # Google map has 17 zoom levels
    0.upto(17) do |i|
      (nw, se) = boundary[i]
      (nw_lat, nw_lng) = nw
      (se_lat, se_ng) = se
      
      puts "@gpoint2scale[#{i}] = [#{se_lat-Nw_lat}, #{se_ng-Nw_lng}]"
    end
  end

  def load_markers(map)
    # blank markers
    map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/markers/largeTDRedIcons/blank.png",                                       
                                      :icon_size => GSize.new(20,34),
                                      :icon_anchor => GPoint.new(12,34),
                                      :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                      :shadow_size => GSize.new(37,34),
                                      :info_window_anchor => GPoint.new(9,2)), 
                                      "icon_blank_red")    

    map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/markers/largeTDGreenIcons/blank.png",                                       
                                      :icon_size => GSize.new(20,34),
                                      :icon_anchor => GPoint.new(12,34),
                                      :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                      :shadow_size => GSize.new(37,34),
                                      :info_window_anchor => GPoint.new(9,2)), 
                                      "icon_blank_green")    

    map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/markers/largeTDBlueIcons/blank.png",                                       
                                      :icon_size => GSize.new(20,34),
                                      :icon_anchor => GPoint.new(12,34),
                                      :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                      :shadow_size => GSize.new(37,34),
                                      :info_window_anchor => GPoint.new(9,2)), 
                                      "icon_blank_blue")    

    map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/markers/largeTDYellowIcons/blank.png",                                       
                                      :icon_size => GSize.new(20,34),
                                      :icon_anchor => GPoint.new(12,34),
                                      :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                      :shadow_size => GSize.new(37,34),
                                      :info_window_anchor => GPoint.new(9,2)), 
                                      "icon_blank_yellow")    

    map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/0-99/blank.png",                                       
                                      :icon_size => GSize.new(20,34),
                                      :icon_anchor => GPoint.new(12,34),
                                      :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                      :shadow_size => GSize.new(37,34),
                                      :info_window_anchor => GPoint.new(9,2)), 
                                      "icon_blank")    

    # numbered markers
    1.upto(50) do |i|
      map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/markers/largeTDRedIcons/marker#{i}.png",
                                        :icon_size => GSize.new(20,34),
                                        :icon_anchor => GPoint.new(12,34),
                                        :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                        :shadow_size => GSize.new(37,34),
                                        :info_window_anchor => GPoint.new(9,2)), 
                                        "icon_red#{i}")    
    end

    1.upto(50) do |i|
      map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/markers/largeTDGreenIcons/marker#{i}.png",
                                        :icon_size => GSize.new(20,34),
                                        :icon_anchor => GPoint.new(12,34),
                                        :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                        :shadow_size => GSize.new(37,34),
                                        :info_window_anchor => GPoint.new(9,2)), 
                                        "icon_green#{i}")    
    end

    1.upto(50) do |i|
      map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/markers/largeTDYellowIcons/marker#{i}.png",
                                        :icon_size => GSize.new(20,34),
                                        :icon_anchor => GPoint.new(12,34),
                                        :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                        :shadow_size => GSize.new(37,34),
                                        :info_window_anchor => GPoint.new(9,2)), 
                                        "icon_yellow#{i}")    
    end

    1.upto(50) do |i|
      map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/markers/largeTDBlueIcons/marker#{i}.png",
                                        :icon_size => GSize.new(20,34),
                                        :icon_anchor => GPoint.new(12,34),
                                        :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                        :shadow_size => GSize.new(37,34),
                                        :info_window_anchor => GPoint.new(9,2)), 
                                        "icon_blue#{i}")    
    end

    1.upto(50) do |i|
      map.icon_global_init(GIcon.new(:image => "#{app_base}/images/icons/0-99/marker#{i}.png", 
                                        :icon_anchor => GPoint.new(12,34),
                                        :shadow => "#{app_base}/images/icons/google/shadow50.png",
                                        :shadow_size => GSize.new(37,34),
                                        :info_window_anchor => GPoint.new(9,2)), 
                                        "icon#{i}")    
    end
  end


end
