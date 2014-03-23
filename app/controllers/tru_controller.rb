class TruController < ApplicationController

  def initialize
    @app_base=app_base
    @app_name='TRU'
    @title='Tru'
    @tagline='iFanSee.com'
    @theme='aqualicious'
  end

  def get_parameters
    @state_id = params[:state_id]
    @county_id = params[:county_id]
  end

  def index
    
  end

  def state
    get_parameters
    
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([37.420644, -121.021325], 6) # center of California
    load_markers(@map)
  end

  def refresh_state
    get_parameters 
    puts @state_id
    
    @counties = IfsCounty.find_all_by_state_id(@state_id, :order => 'name')
  end

  def county
    get_parameters
    
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([37.420644, -121.021325], 6) # center of California
    load_markers(@map)
  end

  def refresh_county
    get_parameters

    puts @county_id
    
    
    @counties=TruSummary.find_all_by_stat_type_and_reference_id('county', @county_id)
    for county in @counties
      puts county.num_listed
    end
  end

  def city
    
  end

  def zipcode
    
  end

end
