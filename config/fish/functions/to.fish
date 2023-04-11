function to -d "tmux "
  set -l n (count $argv)
  if test $n -ne 1
    echo "Usage: to <session>"
    echo '  list all sessions by: tmux ls -F "#{session_name}"'
    return 1
  end

  if set -q TMUX
    echo 'tmux has already been opened'
    return 1
  end

  tmux new -s $argv[1] || tmux a -t $argv[1]
end
