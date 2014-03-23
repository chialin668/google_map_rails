class TruCounty < ActiveRecord::Base

  def self.get_county_info(criteria_str)
    sql=%Q(
      select * 
      from tru_counties
      where name in (#{criteria_str})
    )
    puts sql
    self.find_by_sql(sql)
  end
end
