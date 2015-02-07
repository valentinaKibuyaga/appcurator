#!/usr/bin/awk -f
BEGIN { 
    app_num="";
    FS="[|] ";
} 
{ 
  if ( $1 ~ /app_id/ ) {
      app_num = $2;
  } else if ( $1 ~ /^logo/ ) {
      system("curl " $2 " -o foo");
      system("sips -Z 100 -p 100 100 -s format png foo --out app_icon_" $app_num ".png");
  }
}
#END { print " - DONE -"; } 

