class ApiGrowth < ActiveRecord::Base

  def self.get_state_top_x_schools(stype, year, top_x)
    sql=%Q(
      select * 
      from api_growths
      where school_type='#{stype}' 
      and year='#{year}'
      and state_rank <= #{top_x}
      order by state_rank
    ) #'
    ApiGrowth.find_by_sql(sql)
  end

  def self.get_state_top_x_schools_in_region(stype, year, region, top_x)
    sql=%Q(
      select * 
      from api_growths
      where school_type='#{stype}' 
      and year='#{year}'
      and region = '#{region}'
      and state_rank <= #{top_x}
      order by state_rank
    ) #'
    ApiGrowth.find_by_sql(sql)
  end

  def self.get_region_top_x_schools(stype, year, region, top_x)
    sql=%Q(
      select * 
      from api_growths
      where school_type='#{stype}' 
      and year='#{year}'
      and region = '#{region}'
      and region_rank <= #{top_x}
      order by state_rank
    ) #'
    ApiGrowth.find_by_sql(sql)
  end

  def self.get_county_top10_schools(stype, year, county_name)
    # api scores and ranks
    sql=%Q(
      select * 
      from api_growths
      where school_type='#{stype}' 
      and year='#{year}'
      and county_name='#{county_name}'
      and county_rank <= 10
      order by county_rank
    ) #'
    ApiGrowth.find_by_sql(sql)
  end

  def self.get_state_top50_in_county(stype, year, county_name)
    # api scores and ranks
    sql=%Q(
      select * 
      from api_growths
      where school_type='#{stype}' 
      and year='#{year}'
      and county_name='#{county_name}'
      and state_rank <= 50
      order by state_rank
    ) #'
    ApiGrowth.find_by_sql(sql)
  end

  def self.district_top10(stype, year, county_name, district_name)
    sql=%Q(
      select *
      from api_growths
      where school_type = '#{stype}'
      and year='#{year}'
      and county_name='#{county_name}'
      and district_name = '#{district_name}'
#      and district_rank <= 10
      order by district_rank
    ) #'
    cds2school={}
    schools=ApiGrowth.find_by_sql(sql)
    for school in schools
      cds= "%02d%05d%07d" % [school.county_code, school.district_code, school.school_code]
      cds2school[cds] = school
    end
    cds2school
  end

  def self.get_district_names(stype, year, county_name)
    stype='H' if not stype
    sql=%Q(
      select county_code, district_code, school_code, district_name
      from api_growths
      where school_type = '#{stype}'
      and year = #{year}
      and county_name = '#{county_name}'
      order by district_name
    )
    ApiGrowth.find_by_sql(sql)
  end

  def self.get_district_codes(year, county_name)
    sql=%Q(
      select school_type, min(district_code) district_code
      from api_growths
      where year = #{year}
      and county_name = '#{county_name}'
      group by school_type
    )  
    ApiGrowth.find_by_sql(sql)
  end

  def self.find_school_by_district_code(stype, year, district_code)
    sql=%Q(
      select *
      from api_growths
      where school_type = '#{stype}'
      and year = #{year}
      and district_code = #{district_code}
      order by district_rank
    )  
    ApiGrowth.find_by_sql(sql)
  end

  def self.get_county_names
    sql=%Q(
      select county_code, county_name, min(district_code) district_code
      from api_growths
      group by county_code, county_name
      order by county_name
    )
    ApiGrowth.find_by_sql(sql)
  end

end
