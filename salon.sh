#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~ Welcome to Smoke's Salon ~~~\n"



# MAIN_MENU shows all the services we offer and allows customer to select what they want
MAIN_MENU () {
  if [[ $1 ]]
  then
  echo $1
  fi
echo -e "What can we do for you today?"
echo -e "1) hair-cut\n2) hair-do\n3) waxing"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
1) APPOINTMENT;;
2) APPOINTMENT;;
3) APPOINTMENT;;
*) MAIN_MENU "Please select a valid service";;
esac
}

APPOINTMENT() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED" | sed -E 's/^ *| *$//g')
  echo -e "\nWe are going to give you a fine $SERVICE_NAME today! What is your phone number?"
  read CUSTOMER_PHONE
  # get phone number from database
  PHONE_NUMBER_RESULT=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  # if customer phone number is not in our database i.e PHONE_NUMBER_RESULT is empty
  if [[ -z $PHONE_NUMBER_RESULT ]]
  then
  # get customer name
  echo -e "\nWhat is your name?"
  read CUSTOMER_NAME

  # insert customer name and phone number into db
  INSERT_CUSTOMERS_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  else
  # set customer name for returning customers
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'" | sed -E 's/^ *| *$//g')
  # greet returning customer
 # echo -e "\nWelcome back $CUSTOMER_NAME."
 # sleep 2
fi
  # get appointment time
  echo -e "\nWhen would you like to schedule your appointment?"
  read SERVICE_TIME
  
  # get customer_id
   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # schedule appointment by inserting all necessary information into appointments table
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  # Thank you message for booking appointment
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  
}


MAIN_MENU
