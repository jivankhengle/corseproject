PSQL="psql --username=freecodecamp --dbname=salon -t -q -c"

# Main menu loop
until false; do
  # Display salon header
  echo "~~~~~ MY SALON ~~~~~"
  echo ""
  echo "Welcome to My Salon, how can I help you?"
  echo ""
  
  # Display services
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
  
  echo "$SERVICES" | while read SERVICE_ID BAR NAME; do
    if [[ ! -z "$SERVICE_ID" ]]; then
      echo "$SERVICE_ID) $NAME"
    fi
  done
  
  # Get service selection
  read SERVICE_ID_SELECTED
  
  # Validate service_id
  SERVICE_RESULT=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
  
  if [[ -z "$SERVICE_RESULT" ]]; then
    echo ""
    echo "I could not find that service. What would you like today?"
    echo ""
    continue
  fi
  
  # Service is valid, continue
  break
done

# Get service name
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;" | xargs)

echo ""
echo "What's your phone number?"
read CUSTOMER_PHONE

# Check if customer exists
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';" | xargs)

# If customer doesn't exist, get their name and create record
if [[ -z "$CUSTOMER_ID" ]]; then
  echo ""
  echo "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  
  # Insert new customer
  $PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');" > /dev/null
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';" | xargs)
else
  # Get existing customer name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';" | xargs)
fi

echo ""
echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

# Insert appointment
$PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');" > /dev/null

# Display confirmation
echo ""
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
