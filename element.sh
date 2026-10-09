#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -X -t --no-align -c"

if [[ -z "$1" ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

RESULT=$($PSQL "
  SELECT
    e.atomic_number,
    e.name,
    e.symbol,
    t.type,
    p.atomic_mass,
    p.melting_point_celsius,
    p.boiling_point_celsius
  FROM elements AS e
  JOIN properties AS p
    ON e.atomic_number = p.atomic_number
  JOIN types AS t
    ON p.type_id = t.type_id
  WHERE e.atomic_number::TEXT = '$1'
     OR e.symbol = '$1'
     OR e.name = '$1';
")

if [[ -z "$RESULT" ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
