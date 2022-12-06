#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
NUMBER_TO_GUESS=$((1 + $RANDOM % 1000))
echo "Number to guess: $NUMBER_TO_GUESS" # REMOVE WHEN FINISHED TESTING
echo "Enter your username:"
read USERNAME
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME';")
if [[ -n $GAMES_PLAYED ]]
then
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME';")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
else
  INSERT_USER_RESPONSE=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME');")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi
echo "Guess the secret number between 1 and 1000:"
GUESS=""
GUESSES=0
until [[ $GUESS -eq $NUMBER_TO_GUESS ]]
do
  read GUESS
  GUESSES=$((GUESSES + 1))
  if [[ $GUESS =~ [0-9]+ ]]
  then
    if [[ $GUESS -gt $NUMBER_TO_GUESS ]]
    then
      echo "It's lower than that, guess again:"
    elif [[ $GUESS -lt $NUMBER_TO_GUESS ]]
    then
      echo "It's higher than that, guess again:"
    fi
  else
    echo "That is not an integer, guess again:"
  fi
done
echo "You guessed it in $GUESSES tries. The secret number was $NUMBER_TO_GUESS. Nice job!"
GAMES_PLAYED=$(($GAMES_PLAYED + 1))
if [[ $GAMES_PLAYED -eq 1 ]]
then
  BEST_GAME=$GUESSES
elif [[ $GUESSES -lt $BEST_GAME ]]
then
  BEST_GAME=$GUESSES
fi
UPDATE_USER_RESPONSE=$($PSQL "UPDATE users SET (games_played, best_game) = ($GAMES_PLAYED, $BEST_GAME) WHERE username = '$USERNAME';")

