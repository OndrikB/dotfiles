function fish_right_prompt
  set -l dur = $CMD_DURATION
  set -l seconds = (math -s 3 $CMD_DURATION / 1000)
  set -l seconds_trunc = (expr $CMD_DURATION / 1000)
  if [ $CMD_DURATION -gt 60000 ]
    echo (math -s 1 $CMD_DURATION / 1000)" s"
  else
    echo (math -s 3 $CMD_DURATION / 1000)" s"
  end
end
