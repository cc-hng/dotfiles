function myenv -d "my env variable"
  set -l MY_ENV_HOME "$HOME/.config/env"
  mkdir -p $MY_ENV_HOME

  # print all env
  if test (count $argv) -eq 0
    pushd $MY_ENV_HOME > /dev/null
    for k in (ls)
      set -l v (cat $k)
      echo "$k=$v"
    end
    popd > /dev/null
  end

  # setenv
  for arg in $argv
    set -l kv (string split -m 1 "=" -- $arg)
    switch (count $kv)
      case 1
        if ! test -f "$MY_ENV_HOME/$kv[1]"
          echo "Error: $kv[1] not found"
          return 1
        end
        cat "$MY_ENV_HOME/$kv[1]"
      case 2
        if test -n "$kv[2]"
          echo $kv[2] > $MY_ENV_HOME/$kv[1]
        else
          rm -f $MY_ENV_HOME/$kv[1]
        end
    end
  end
end
