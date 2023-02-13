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
# get winner team id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
# if not found insert winner team
if [[ -z $WINNER_ID ]]
then
  INSERT_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
fi
# get new winner team id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
# get opponent team id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
# if not found insert opponent team
if [[ -z $OPPONENT_ID ]]
then
  INSERT_OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
fi
# get new opponent team id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
# insert the rest infos
  INSERT_REST=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
   VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")

fi
done
