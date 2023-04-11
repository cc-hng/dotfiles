function proxyon
  myenv proxy > /dev/null \
    && set -f endpoint (myenv proxy) \
    || set -f endpoint "127.0.0.1:1082"
  set -f kv (string split -m 1 ":" -- "$endpoint")
  set -f ip $kv[1]
  set -f port $kv[2]

  echo "proxyon: $ip:$port"
  if nc -z $ip $port > /dev/null
    export http_proxy="http://$ip:$port"
    export https_proxy="http://$ip:$port"
    export no_proxy="kubernetes.docker.internal,localhost,127.0.0.1,mirrors.ustc.edu.cn,mirrors.tencentyun.com"
  else
    echo "proxyon: connected to $ip:$port failed"
    return 1
  end
end
