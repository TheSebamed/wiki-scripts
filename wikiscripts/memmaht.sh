BEGIN {
  sizegb=0
}

/size: / {
  match($2, "[0-9]+")
  value=substr($2, RSTART, RLENGTH)
  suffix=substr($2, RLENGTH+1)
  if (suffix == "KiB")
    sizegb += value / (1000*1000)
  else if (suffix == "MiB")
    sizegb += value / 1000
  else if (suffix == "GiB")
    sizegb += value
  else if (suffix == "TiB")
    sizegb += value * 1000
  else if (suffix == "PiB")
    sizegb += value * 1000 * 1000
}

END {
  printf "%dGB\n", sizegb/2
}

