require 'rubygems'
#require_gem 'ym4r'
require 'ym4r'

class CnsController < ApplicationController

  def initialize
    @app_base=app_base
    @app_name='CNS'
    @title='iFanSee.com'
    @tagline='Beta 1 (Date: 03/11/08)'
    @theme='aqualicious'
    @current_year=current_year
    
    @capi_url_base="http://www.ifansee.com"
    @capi_api_app_base="/capi"
    
  end

  def index
    
  end
  
  
  def get_parameters
    @html_type = params[:html_type]
    @cds=params[:cds]
    
    @county_name = params[:county_name] 
    @district_name = params[:district_name] 
    @stype = params[:stype]
    @scount = params[:scount]
    @region = params[:region]
    @district_cds = params[:district_cds]
    @mtype = params[:mtype]
    @app_base=app_base

  end

  def get_polygons_by_county_name
      counties = CnsCounty.find_all_by_county_name(@county_name) 
      @polygons=[]
      for county in counties 
        polygon = CnsCountyPolygon.find_all_by_polygon_id(county.polygon_id)
        
        latlngs=[]
        for point in polygon
          if point.geotype=='C'
            if @map_center
              @map_center = [(point.lat.to_f+@map_center[0])/2, (point.lng.to_f+@map_center[1])/2] 
            else
              @map_center = [point.lat.to_f, point.lng.to_f]
            end
          elsif point.geotype=='P'
            latlngs << [point.lat.to_f, point.lng.to_f]
          end
        end
        @polygons << latlngs
      end
  end

  def get_polygons_by_district_name
    #
    # district polygons
    #
    district_types = "('S', 'U')" if @stype=='H'
    district_types = "('E', 'U')" if @stype=='E' or @stype=='M'

    # NOTE: the length of district_name in cns_schools is 30 (even it's varchar(64))
    @district_name = @district_name[0..29]
    district_name = "('#{@district_name}')" if @stype=='H'
    district_name = "('#{@district_name}', '#{@district_name} Elementary')" if @stype=='E' or @stype=='M'
    
    district=CnsSchool.find_district_by_name_and_types(district_name, district_types)

    @district_polygons=[]
    if district.size > 0
      polygon=CnsSchoolPolygon.find_all_by_polygon_id_and_district_type(district[0].polygon_id, district[0].district_type)

      latlngs=[]
      for point in polygon
        if point.geotype=='C'
          if @map_center
            @map_center = [(point.lat.to_f+@map_center[0])/2, (point.lng.to_f+@map_center[1])/2] 
          else
            @map_center = [point.lat.to_f, point.lng.to_f]
          end
        elsif point.geotype=='P'
          latlngs << [point.lat.to_f, point.lng.to_f] 
        end
      end
      # for 'refresh'
      @district_polygons << latlngs
    end
  end

  ################################################################################
  def state
    get_parameters
    
    @title='California'
    @tagline='www.ifansee.com'

    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
#    @map.center_zoom_init([37.420644, -121.021325], 6) # center of California
    load_markers(@map)
    
    refresh_state
  end

  def refresh_state
    get_parameters

    if @scount != ''

      @schools = ApiGrowth.get_state_top_x_schools(@stype, @current_year, @scount)
      
      cdslist = []
      for school in @schools
        cds= "%02d%05d%07d" % [school.county_code, school.district_code, school.school_code]
        cdslist << cds
      end
      
      @school_cds2geo = IfsSchool.get_school_geo_by_cds(@stype, cdslist.join(','))
    end  
  end


  def region
    get_parameters
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
#    @map.center_zoom_init([37.420644, -121.021325], 8) # center of California
    load_markers(@map)
    
    refresh_region
  end

  def refresh_region
    get_parameters

    if @region and @mtype and @scount != '' 

      @schools = ApiGrowth.get_state_top_x_schools_in_region(@stype, @current_year, @region, @scount) if @mtype=='state'
      @schools = ApiGrowth.get_region_top_x_schools(@stype, @current_year, @region, @scount) if @mtype=='region'
      
      cdslist = []
      for school in @schools
        cds= "%02d%05d%07d" % [school.county_code, school.district_code, school.school_code]
        cdslist << cds
      end
      
      @school_cds2geo = IfsSchool.get_school_geo_by_cds(@stype, cdslist.join(','))
    end  
  end

  def county
    get_parameters

    @title="#{@county_name} County"
    @tagline='www.ifansee.com'

    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    load_markers(@map)
    
    get_polygons_by_county_name
    
    refresh_county
  end

  def refresh_county
    get_parameters

    #
    # Regrieve county polygons
    #
    get_polygons_by_county_name
    
    # 
    # Retrieve markers
    #
    case @mtype
      when 'district'
        @districts = ApiSummary.get_district_apis(@stype, @current_year, @county_name)
        @district_cds2gso=IfsSchool.get_district_geo_info (@stype, @county_name)
      when 'county'  
        @schools = ApiGrowth.get_county_top10_schools(@stype, @current_year, @county_name)
        @school_cds2geo = IfsSchool.get_school_geo_info(@stype, @county_name)
      when 'state'  
        @schools = ApiGrowth.get_state_top50_in_county(@stype, @current_year, @county_name)
        @school_cds2geo = IfsSchool.get_school_geo_info(@stype, @county_name)
    end    
  end


  def county_list
  end

  def district
    get_parameters

    @title="#{@county_name} County"
    @tagline='www.ifansee.com'

    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([37.420644, -121.021325], 6) # center of California
    load_markers(@map)
    
    get_polygons_by_county_name
    
    refresh_district
  end

  def refresh_district
    get_parameters

    get_polygons_by_county_name

    if @district_cds 
      district_code = @district_cds[2..6]
      @schools = ApiGrowth.find_school_by_district_code(@stype, @current_year, district_code)
  
      cdslist = []
      for school in @schools
        cds= "%02d%05d%07d" % [school.county_code, school.district_code, school.school_code]
        cdslist << cds
      end
      
      @district_name = @schools[0].district_name
      get_polygons_by_district_name 
      
      @school_cds2geo = IfsSchool.get_school_geo_by_cds(@stype, cdslist.join(','))
    else
      # to avoid exceptions (???????)
      @district_polygons = []
      @schools = []
    end  
  end


end
    

