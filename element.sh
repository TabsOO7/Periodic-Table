#!/bin/bash


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"



if [[  $1 =~ ^[0-9]+$ ]]
then


ELEMENT_ATOMIC_N_CONDITION=$1


ATOMIC_NUMBER="$($PSQL "SELECT atomic_number  FROM elements WHERE atomic_number = '$ELEMENT_ATOMIC_N_CONDITION'")"

elif [[ $1 =~ ^[a-zA-Z]+$ ]]
then

ELEMENT_NAME_CONDITION=$1
ELEMENT_SYMBOL_CONDITION=$1

NAME="$($PSQL "SELECT name FROM elements WHERE name = '$ELEMENT_NAME_CONDITION' OR symbol = '$ELEMENT_SYMBOL_CONDITION'")"

SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE name = '$ELEMENT_NAME_CONDITION' OR symbol = '$ELEMENT_SYMBOL_CONDITION'")"

fi

if  [[ -z $1 ]]
then
echo "Please provide an element as an argument."

#this is for cheking for the element in the database by using the atomic number

elif [[ $1 == $ATOMIC_NUMBER ]]
then

ELEMENT_ATOMIC_N=$1

NAME="$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT_ATOMIC_N")"

SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_ATOMIC_N")"

TYPE="$($PSQL "SELECT type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ELEMENT_ATOMIC_N")"

ATOMIC_MASS="$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ELEMENT_ATOMIC_N")"

MELTING_POINT="$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ELEMENT_ATOMIC_N")"

BOILING_POINT="$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ELEMENT_ATOMIC_N")"

echo "The element with atomic number $ELEMENT_ATOMIC_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

#this is for cheking whether the element in the database is there by using the symbol or name of the element 

elif [[ $1 == $SYMBOL || $1 == $NAME ]]
then

ELEMENT_SYMBOL=$1
ELEMENT_NAME=$1

ELEMENT_ATOMIC_N="$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ELEMENT_NAME' OR symbol = '$ELEMENT_SYMBOL'")"

NAME="$($PSQL "SELECT name FROM elements WHERE name = '$ELEMENT_NAME' OR symbol = '$ELEMENT_SYMBOL'")"

SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE name = '$ELEMENT_NAME' OR symbol = '$ELEMENT_SYMBOL'")"

TYPE="$($PSQL "SELECT type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$ELEMENT_NAME' OR symbol = '$ELEMENT_SYMBOL'")"

ATOMIC_MASS="$($PSQL "SELECT atomic_mass FROM elements FULL JOIN properties USING(atomic_number) WHERE name = '$ELEMENT_NAME' OR symbol = '$ELEMENT_SYMBOL'")"

MELTING_POINT="$($PSQL "SELECT melting_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE name = '$ELEMENT_NAME' OR symbol = '$ELEMENT_SYMBOL'")"

BOILING_POINT="$($PSQL "SELECT boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE name = '$ELEMENT_NAME' OR symbol = '$ELEMENT_SYMBOL'")"


echo "The element with atomic number $ELEMENT_ATOMIC_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."


#this is for checking whether the element is not in the database

elif  [[ $1 != $ATOMIC_NUMBER &&  $1 =~ ^[0-9]+$ ]]
then 

echo "I could not find that element in the database."

elif [[ $1 != $NAME &&  $1 =~ ^[a-zA-Z]+$ ]]
then 

echo "I could not find that element in the database."

elif [[ $1 != $SYMBOL &&  $1 =~ ^[a-zA-Z]+$ ]]
then 

echo "I could not find that element in the database."

fi 


