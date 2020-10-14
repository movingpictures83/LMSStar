awk -F "\"*,\"*" '{print $1,"  ",$col}' col="${2}" $1
