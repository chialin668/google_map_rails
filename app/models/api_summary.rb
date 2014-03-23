class ApiSummary < ActiveRecord::Base

  def self.get_district_apis(stype, year, county_name)

    sql = %Q(
      select * 
      from api_summaries
      where year = '#{year}'
      and county_name = '#{county_name}'
      and school_type = '#{stype}'
      order by district_name
    )
    self.find_by_sql(sql)
  end

end
