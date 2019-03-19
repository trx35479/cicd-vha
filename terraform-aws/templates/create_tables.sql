CREATE TABLE batch_file_control (
  client_name varchar(20) NOT NULL,
  file_type varchar(20) NOT NULL,
  last_record number(20) NOT NULL,
  last_seq_num number(11) NOT NULL,
  last_stream number(11) NOT NULL,
  PRIMARY KEY (client_name,file_type)
) ;

CREATE TABLE bucket_control (
  type number(4) NOT NULL,
  last_record number(20) NOT NULL,
  out_seq_num number(11) NOT NULL,
  last_stream number(4) NOT NULL,
  PRIMARY KEY (type)
);


CREATE TABLE charge_inbucket_data (
   id number(20) NOT NULL,
   partition_id number(4) NOT NULL,
   type number(4) NOT NULL,
   event_time number(11) NOT NULL,
   record_id char(32) NOT NULL,
   record_data varchar(500) NOT NULL,
   PRIMARY KEY (partition_id,type,record_id)
);


CREATE TABLE file_control (
   filename varchar(255) NOT NULL,
   record_count number(11) NOT NULL,
   type number(4) NOT NULL,
   last_record number(20) NOT NULL,
   out_seq_num number(11) NOT NULL,
   last_stream number(4) NOT NULL,
   transfer_time number(11) NOT NULL,
   transfer_complete number(1) NOT NULL,
   PRIMARY KEY (filename)
);

CREATE TABLE schema_info (
   name varchar(255) NOT NULL,
   value varchar(255) NOT NULL,
   PRIMARY KEY (name)
);

CREATE TABLE usage_events (
   record_id number(20) NOT NULL,
   event_type number(4) NOT NULL,
   event_time number(11) NOT NULL,
   event_id char(32) NOT NULL,
   record_data varchar(1000) NOT NULL,
   crm_system varchar(20) DEFAULT NULL,
   usage_origin varchar(20) NOT NULL,
   iscdr number(1) NOT NULL,
   PRIMARY KEY (event_type,event_id) 
 );

