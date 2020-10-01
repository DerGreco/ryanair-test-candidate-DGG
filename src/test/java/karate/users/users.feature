Feature: User related tests

  Background:
    * url 'http://127.0.0.1:8900'

########################################################################################################################
  # POST /user, this is not accurate, you should make sure this user does not exist already.
  Scenario: create a user and then get it by id
    * def new_user =
      """
      {
        "name": "User_A",
        "email": "User_A@user.com"
      }
      """

    Given path 'user'
    And request new_user
    When method post
    Then status 201

    * def id = response.id
    * print 'created id is: ', id

    Given path 'user'
      And param id = id
    When method get
    Then status 200
    And match response contains new_user

  Scenario: create a user with a non valid email
    * def bad_email_user =
      """
      {
        "name": "bad_email_user",
        "email": "This is not an e-mail"
      }
      """

    Given path 'user'
    And request bad_email_user
    When method post
    Then match response contains { message:"malformed email" }
    And status 400

  Scenario: create a user without name
    * def bad_user_has_no_name =
      """
      {
        "email": "bad_user_has_no_name@user.com"
      }
      """

    Given path 'user'
    And request bad_user_has_no_name
    When method post
    Then match response contains 'name field is mandatory'
    And status 400

  Scenario: create a user with an additional unknown field
    * def user_with_unknown_field =
      """
      {
        "name": "user_with_unknown_field",
        "email": "user_with_unknown_field@user.com",
        "unknown_field": "What is this?"
      }
      """

    Given path 'user'
    And request user_with_unknown_field
    When method post
    Then match response contains 'name field is mandatory'
    And status 400

########################################################################################################################
  Scenario: get all users and then get the first user by id
    Given path 'user/all'
    When method get
    Then status 200

    * def first = response[0]

    Given path 'user'
    # This is not REST compliant, it should be /user/{id}, not user?id={id}
      And param id = first.id
    When method get
    Then status 200

  Scenario: Try to fetch a non-existing user
    Given path 'user'
    And param id = 'IdoNotExist'
    When method get
    Then status 404


  