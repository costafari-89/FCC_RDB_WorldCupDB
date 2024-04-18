#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #get winning team id from teams table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #if winning team id not found
    if [[ -z $WINNER_ID ]]
    then
      #insert winning team into teams
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted winning team into majors, $WINNER
      fi
    fi
    #get losing team id from teams table
    LOSER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if losing team id not found
    if [[ -z $LOSER_ID ]]
    then
      #insert losing team into teams
      INSERT_LOSER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_LOSER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted losing team into majors, $OPPONENT
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #get winner_id and loser_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #echo The winner id is $WINNER_ID
    LOSER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #echo The loser id is $LOSER_ID
    #Insert year round winner_goals opponent_goals winner_id loser_id
    GAME_INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR,'$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $LOSER_ID)")
    #if [[ $GAME_INSERT_RESULT == "INSERT 0 1" ]]
    #then
      #echo Inserted $YEAR $ROUND $WINNER_GOALS $OPPONENT_GOALS $WINNER_ID $LOSER_ID
    #fi
  fi
done