function stop
    set -l what $argv[1]
    set -l n (string length "$what")

    if test $n -lt 3
        echo "Expect sizeof($what) >= 3"
        return 1
    end

    if test (ps -ef | rg $what | rg -vw rg | wc -l) -gt 6
        echo "Too many result that matched"
        return 1
    end

    ps -ef | rg $argv[1] | rg -v rg | awk '{print $2}' | xargs -t -I {} kill -9 {}
end
