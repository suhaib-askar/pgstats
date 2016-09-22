﻿DROP VIEW IF EXISTS synth_ma.synth_county_condition_stats;

CREATE VIEW synth_ma.synth_county_condition_stats AS

SELECT cs_dim.ct_fips
    , cond_dim.condition_name
    , CASE WHEN f.pop > 0 THEN f.pop ELSE 0 END AS pop
    , CASE WHEN f.pop_male > 0 THEN f.pop_male ELSE 0 END AS pop_male
    , CASE WHEN f.pop_female > 0 THEN f.pop_female ELSE 0 END AS pop_female
    , CASE WHEN MIN(county_v.pop) = 0 THEN 0 WHEN f.pop > 0 THEN f.pop / MIN(county_v.pop) ELSE 0 END AS rate
    
FROM synth_ma.synth_cousub_dim AS cs_dim
    
LEFT JOIN synth_ma.synth_condition_facts AS f
    ON cs_dim.cs_fips = f.cs_fips

INNER JOIN synth_ma.synth_condition_dim AS cond_dim
    ON f.condition_id = cond_dim.condition_id

LEFT JOIN synth_ma.synth_county_pop_stats AS county_v
    ON cs_dim.ct_fips = county_v.ct_fips
    
GROUP BY cs_dim.ct_fips
    , cond_dim.condition_name
    , f.pop
    , f.pop_male
    , f.pop_female
;
ALTER TABLE synth_ma.synth_county_condition_stats
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_county_condition_stats TO synth_ma;
    