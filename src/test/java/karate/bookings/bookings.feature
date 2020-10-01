Feature: Booking related tests

  Background:
    * url 'http://127.0.0.1:8900'

########################################################################################################################
  # POST /booking, this is not accurate, you should make sure this booking does not exist already.
  Scenario: create a booking associated with some user_id
    * def new_booking =
      """
      {
        "date": "2020-01-01",
        "destination": "AAA",
        "id": "pepe@pepe.pe1-0.1",
        "origin": "BBB"
      }
      """

    Given path 'booking'
    And request new_booking
    When method post
    Then status 201

    * def idBooking = response.idBooking
    * print 'created booking id is: ', idBooking

    Given path 'user'
      And param id = 'pepe@pepe.pe1-0.1'
    When method get
    Then status 200
    #How you are supposed to do this? No single example on Karate docs about variables inside JSON
    And match response contains deep { "idBooking": idBooking}

########################################################################################################################
  # GET /booking
  Scenario: Retrieve the bookings associated with some user_id for specified date

    * def user_id = 'pepe@pepe.pe1-0.1'
    * def date = '2020-01-01'

    Given path 'booking'
      And param id = user_id
      And param date = date
    When method get
    Then status 200
    #Write here assertions about the object I haven't learn how to do, yet




  