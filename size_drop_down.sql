SELECT
  id as userID,
  country as country,
  cd99 as TestName,
  case
  when cd100_11 is not null then 'ControlSingleWithToggle'
  when cd100_22 is not null then 'SingleNoToggle'
  when cd100_33 is not null then 'DoubleManufacturer'
  when cd100_44 is not null then 'DoubleCountryCode'
  end as TestVariant,
  device as device,
  date,
  -- sessions as sessionID,
  -- sku as sku,
  EXACT_COUNT_DISTINCT(id) as users,
  EXACT_COUNT_DISTINCT(sessions) as sessions,
  coalesce (sum (orders),0) as orders,
  coalesce (sum (revenue)/pow(10,6),0) as revenue,
  coalesce (sum (sku_sold),0) as sku_sold,
  coalesce (sum (bounces),0) as bounces,
  sum (if(exits is not null,1,0 )) as exits,
  count (PDP_PI) as PDP_PI,    
  count (Add2Cart) as Add2Cart, 
  count (Add2WL) as Add2WL,
  count (DropDown_Click) as DropDown_Click,
  count (Size_Select) as Size_Select,
  count (EU_Size_Select) as EU_Size_Select,
  count (Manufacture_Size_Select) as Manufacture_Size_Select,
  FROM (
    SELECT
      date,
      fullvisitorId,
      MAX(IF(hits.customDimensions.index = 188,hits.customDimensions.value,null) ) WITHIN RECORD AS id,
      max(if(hits.page.hostname is not null, upper(right (hits.page.hostname,2)), null)) within record as country,
      max(if(hits.appInfo.appVersion is null, device.deviceCategory, Null)) WITHIN RECORD AS device,
      CONCAT(fullvisitorId, STRING(visitId)) as sessions,
    --  upper(regexp_extract(hits.page.pagePath, r'(\w+-\w+).html')) as sku,
      MAX(IF(hits.customdimensions.index=99 and hits.customdimensions.value like '%DoubleDropdown%' ,hits.customdimensions.value,NULL)) WITHIN RECORD AS cd99,
        
           
      MAX(IF(hits.customdimensions.index=100 and hits.customdimensions.value like '%PDPDropdownControlSingleWithToggle%'  ,1,0)) WITHIN RECORD AS cd100_1,
      MAX(IF(hits.customdimensions.index=100 and hits.customdimensions.value like '%PDPDropdownSingleNoToggle%'  ,1,0)) WITHIN RECORD AS cd100_2,
      MAX(IF(hits.customdimensions.index=100 and hits.customdimensions.value like '%PDPDropdownDoubleManufacturer%'  ,1,0)) WITHIN RECORD AS cd100_3,
      MAX(IF(hits.customdimensions.index=100 and hits.customdimensions.value like '%PDPDropdownDoubleCountryCode%'  ,1,0)) WITHIN RECORD AS cd100_4,      
      
      
      MAX(IF(hits.customdimensions.index=100 and hits.customdimensions.value like '%PDPDropdownControlSingleWithToggle%'  ,'ControlSingleWithToggle',Null)) WITHIN RECORD AS cd100_11,
      MAX(IF(hits.customdimensions.index=100 and hits.customdimensions.value like '%PDPDropdownSingleNoToggle%'  ,'SingleNoToggle',null)) WITHIN RECORD AS cd100_22,
      MAX(IF(hits.customdimensions.index=100 and hits.customdimensions.value like '%PDPDropdownDoubleManufacturer%'  ,'DoubleManufacturer',Null)) WITHIN RECORD AS cd100_33,
      MAX(IF(hits.customdimensions.index=100 and hits.customdimensions.value like '%PDPDropdownDoubleCountryCode%'  ,'DoubleCountryCode',null)) WITHIN RECORD AS cd100_44,
    
      sum(if(hits.product.productSku IS NOT NULL AND totals.transactions>=1 AND hits.eCommerceAction.action_type = '6'  ,hits.product.productQuantity, Null)) within record AS sku_sold, 
      MAX(IF(hits.customDimensions.value='CATALOG_ARTICLE'  AND hits.type='PAGE', hits.isExit, NULL)) WITHIN RECORD AS exits,
      MAX(IF(hits.customDimensions.value='CATALOG_ARTICLE' , totals.bounces, NULL)) WITHIN RECORD AS bounces,
      MAX(IF(hits.customDimensions.value='CATALOG_ARTICLE' , totals.transactions,0)) WITHIN RECORD AS orders,
      MAX(IF(hits.customDimensions.value='CATALOG_ARTICLE' , totals.totalTransactionRevenue,0)) WITHIN RECORD AS revenue,
      MAX(IF(hits.customDimensions.value='CATALOG_ARTICLE' AND hits.type='PAGE', hits.customDimensions.value,null)) WITHIN hits AS PDP_PI,       
      MAX(IF(hits.eventInfo.eventCategory='product detail page' AND hits.eventInfo.eventAction ='add to cart' , hits.eventInfo.eventAction, null)) WITHIN hits AS Add2Cart,
      MAX(IF(hits.eventInfo.eventCategory='product detail page' AND hits.eventInfo.eventAction ='add to wishlist' ,hits.eventInfo.eventAction , null)) WITHIN hits AS Add2WL,
     
MAX(IF(hits.eventInfo.eventCategory='product detail page' AND hits.eventInfo.eventAction ='click' AND hits.eventInfo.eventLabel ='size dropdown'   ,hits.eventInfo.eventLabel , null)) WITHIN hits AS DropDown_Click,
MAX(IF(hits.eventInfo.eventCategory='product detail page' AND hits.eventInfo.eventAction ='click' AND hits.eventInfo.eventLabel ='size'  ,hits.eventInfo.eventLabel , null)) WITHIN hits AS Size_Select,
MAX(IF(hits.eventInfo.eventCategory='product detail page' AND hits.eventInfo.eventAction ='click' AND hits.eventInfo.eventLabel ='eu size'  ,hits.eventInfo.eventLabel , null)) WITHIN hits AS EU_Size_Select,
MAX(IF(hits.eventInfo.eventCategory='product detail page' AND hits.eventInfo.eventAction ='click' AND hits.eventInfo.eventLabel ='manufacturer size'  ,hits.eventInfo.eventLabel , null)) WITHIN hits AS Manufacture_Size_Select,
     
     
     
     FROM
     
     TABLE_DATE_RANGE([oval-unity-88908:97549349.ga_sessions_], TIMESTAMP('2017-05-18'), TIMESTAMP('2017-07-05')),
    TABLE_DATE_RANGE([oval-unity-88908:97548844.ga_sessions_], TIMESTAMP('2017-05-18'), TIMESTAMP('2017-07-05')),
     TABLE_DATE_RANGE([oval-unity-88908:97520985.ga_sessions_], TIMESTAMP('2017-05-18'), TIMESTAMP('2017-07-05')),
      
  OMIT  
     RECORD if NOT SOME(IF(hits.eventInfo.eventLabel is not null,hits.eventInfo.eventLabel, NULL) ='size dropdown')

      
      
    having  cd100_1 + cd100_2 + cd100_3 + cd100_4 = 1 and device = 'desktop' 

      )

GROUP BY
  1,
  2,
  3,
  4,
  5, 
  6
  --,7

  having TestName like '%DoubleDropdown%' and TestVariant is not null 