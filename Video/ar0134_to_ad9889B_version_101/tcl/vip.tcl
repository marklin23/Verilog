






   # go sig
   master_write_32 $my_service_path 0x0200 0x01
   master_write_32 $my_service_path 0x0000 0x01
   master_write_32 $my_service_path 0x0400 0x01
   
   master_read_32 $my_service_path 0x0204 0x1
   master_read_32 $my_service_path 0x0004 0x1
   master_read_32 $my_service_path 0x0404 0x1
   
   
   #scaler Output Width
   master_write_32 $my_service_path 0x0c 800 
   #scaler Output Width
   master_write_32 $my_service_path 0x0f 600

   #cvo Output Width
   master_write_32 $my_service_path 0x0c 800 
   #cvo Output Width
   master_write_32 $my_service_path 0x0f 600