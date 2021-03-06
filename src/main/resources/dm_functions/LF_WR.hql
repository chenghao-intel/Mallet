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

USE mallet_db;
DROP VIEW IF EXISTS wrv;
CREATE VIEW wrv AS
SELECT d_date_sk wr_return_date_sk
      ,t_time_sk wr_return_time_sk
      ,i_item_sk wr_item_sk
      ,c1.c_customer_sk wr_refunded_customer_sk
      ,c1.c_current_cdemo_sk wr_refunded_cdemo_sk
      ,c1.c_current_hdemo_sk wr_refunded_hdemo_sk
      ,c1.c_current_addr_sk wr_refunded_addr_sk
      ,c2.c_customer_sk wr_returning_customer_sk
      ,c2.c_current_cdemo_sk wr_returning_cdemo_sk
      ,c2.c_current_hdemo_sk wr_returning_hdemo_sk
      ,c2.c_current_addr_sk wr_returing_addr_sk
      ,wp_web_page_sk wr_web_page_sk 
      ,r_reason_sk wr_reason_sk
      ,wret_order_id wr_order_number
      ,wret_return_qty wr_return_quantity
      ,wret_return_amt wr_return_amt
      ,wret_return_tax wr_return_tax
      ,wret_return_amt + wret_return_tax AS wr_return_amt_inc_tax
      ,wret_return_fee wr_fee
      ,wret_return_ship_cost wr_return_ship_cost
      ,wret_refunded_cash wr_refunded_cash
      ,wret_reversed_charge wr_reversed_charge
      ,wret_account_credit wr_account_credit
      ,wret_return_amt+wret_return_tax+wret_return_fee
       -wret_refunded_cash-wret_reversed_charge-wret_account_credit wr_net_loss
FROM s_web_returns s
LEFT OUTER JOIN date_dim d ON (s.wret_return_date = d.d_date)
LEFT OUTER JOIN time_dim t ON (hour(s.wret_return_time) = t.t_hour AND minute(s.wret_return_time) = t.t_minute AND second(s.wret_return_time) = t.t_second)
LEFT OUTER JOIN item i ON (s.wret_item_id = i.i_item_id)
LEFT OUTER JOIN customer c1 ON (s.wret_return_customer_id = c1.c_customer_id)
LEFT OUTER JOIN customer c2 ON (s.wret_refund_customer_id = c2.c_customer_id)
LEFT OUTER JOIN reason r ON (s.wret_reason_id = r.r_reason_id)
LEFT OUTER JOIN web_page w ON (s.wret_web_page_id = w.wp_web_page_id)
WHERE i_rec_end_date IS NULL AND wp_rec_end_date IS NULL;

INSERT INTO TABLE web_returns SELECT * FROM wrv;
DROP VIEW wrv;
