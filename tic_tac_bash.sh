#!/bin/bash

USER=X
COMPT=O

s=([1]=1 [2]=2 [3]=3 [4]=4 [5]=5 [6]=6 [7]=7 [8]=8 [9]=9)
num_re='^[1-9]$'

grid() {
  echo "User sym: ${USER}, AI sym: ${COMPT}"
  echo " ${s[7]} | ${s[8]} | ${s[9]} "
  echo "---+---+---"
  echo " ${s[4]} | ${s[5]} | ${s[6]} "
  echo "---+---+---"
  echo " ${s[1]} | ${s[2]} | ${s[3]} "
}

player() {
  [[ $1 == "$USER" ]] && printf "User" || printf "Computer"
}

user() {
  printf "what is your move (1-9): "
  read -r user_move

  if ! [[ $user_move =~ $num_re ]]; then
    echo "Invalid position"
    user
    return
  fi

  if ! [[ ${s[$user_move]} =~ $num_re ]]; then
    echo "too late, try again"
    user
    return
  fi

  s[$user_move]=$USER
}

ai() {
  echo "ai is thinking..."
  sleep 1
  ai_move=$((1 + RANDOM % 9))

  if ! [[ ${s[$ai_move]} =~ $num_re ]]; then
    ai
    return
  fi

  s[$ai_move]=$COMPT
}

wins() {
  local winner_sym=$1
  echo "================================================"
  echo "                         $(player "$winner_sym") wins!!!"
  echo "================================================"
  grid
  exit 0
}

winner() {
  local i j k winner_sym

  for i in 1 4 7; do
    j=$((i + 1))
    k=$((i + 2))
    winner_sym=${s[$i]}
    if [[ $winner_sym == "${s[$j]}" && $winner_sym == "${s[$k]}" && ($winner_sym == "$USER" || $winner_sym == "$COMPT") ]]; then
      wins "$winner_sym"
    fi
  done

  for i in 1 2 3; do
    j=$((i + 3))
    k=$((i + 6))
    winner_sym=${s[$i]}
    if [[ $winner_sym == "${s[$j]}" && $winner_sym == "${s[$k]}" && ($winner_sym == "$USER" || $winner_sym == "$COMPT") ]]; then
      wins "$winner_sym"
    fi
  done

  winner_sym=${s[5]}
  if [[ $winner_sym == "${s[1]}" && $winner_sym == "${s[9]}" && ($winner_sym == "$USER" || $winner_sym == "$COMPT") ]]; then
    wins "$winner_sym"
  fi

  if [[ $winner_sym == "${s[7]}" && $winner_sym == "${s[3]}" && ($winner_sym == "$USER" || $winner_sym == "$COMPT") ]]; then
    wins "$winner_sym"
  fi
}

while true; do
  grid
  user
  winner
  ai
  winner

  full=true
  for i in {1..9}; do
    if [[ ${s[$i]} =~ $num_re ]]; then
      full=false
      break
    fi
  done

  if [[ $full == true ]]; then
    grid
    echo "It's a draw!"
    exit 0
  fi
done
