class CnsCounty < ActiveRecord::Base
  
  def self.find_all_county_names
    sql=%Q(
      select distinct county_name
      from cns_counties
      order by county_name
    )
    CnsCounty.find_by_sql(sql)
  end
end
