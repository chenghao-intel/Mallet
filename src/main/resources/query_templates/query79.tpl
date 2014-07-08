--
-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements. See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License. You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

DEFINE COMMENT = "-- ";
[COMMENT] QUERY_ID=79;

 define DEPCNT=random(0,9,uniform);
 define YEAR = random(1998,2000,uniform);
 define VEHCNT=random(-1,4,uniform);
 define _LIMIT=100;
 
 select 
  c_last_name,c_first_name,substr(s_city,1,30) as sc,ss_ticket_number,amt,profit
  from
   (select ss_ticket_number
          ,ss_customer_sk
          ,store.s_city
          ,sum(ss_coupon_amt) amt
          ,sum(ss_net_profit) profit
    from 
        store_sales join date_dim
          on store_sales.ss_sold_date_sk = date_dim.d_date_sk
          and date_dim.d_dow = 1
          and date_dim.d_year in ([YEAR],[YEAR]+1,[YEAR]+2) 
        join store
          on store_sales.ss_store_sk = store.s_store_sk  
          and store.s_number_employees between 200 and 295
        join household_demographics
          on store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk
    where (household_demographics.hd_dep_count = [DEPCNT] or household_demographics.hd_vehicle_count > [VEHCNT])
    group by ss_ticket_number,ss_customer_sk,ss_addr_sk,store.s_city)
   ms join customer
    on ms.ss_customer_sk = customer.c_customer_sk
 order by c_last_name,c_first_name,sc, profit
[_LIMITC];

