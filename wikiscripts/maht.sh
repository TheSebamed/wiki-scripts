BEGIN {
  FS="[()]"
  sizegb=0
}

/size: / {
  match($2, "[0-9]+")
  value=substr($2, RSTART, RLENGTH)
  suffix=substr($2, RLENGTH+1)
  if (suffix == "KB")
    sizegb += value / (1000*1000)
  else if (suffix == "MB")
    sizegb += value / 1000
  else if (suffix == "GB")
    sizegb += value
  else if (suffix == "TB")
    sizegb += value * 1000
  else if (suffix == "PB")
    sizegb += value * 1000 * 1000
}

END {
  printf "%dGB\n", sizegb
}
