Feature: Autocompletion for product form fields
  In order to fill out product forms faster
  An editor
  Should be able to use autocompletion

  Background: Account exists
    Given an activated account
    And that account has a product
    And an authenticated user with editor role on edit product page
    
  @javascript
  Scenario Outline: Editor edits product using autocomplete
    Given another product with <field> "<field>123"
    And another product with <field> "<field>456"
    Then he should not see "<field>123, <field>456" autocomplete options
    When he enters "<field>" into "<label>" field
    Then he should see "<field>123, <field>456" autocomplete options
    When he selects the first autocomplete option in "<label>" field
    And he submits the product form
    Then he should see product <field> "<field>456"
    Examples:
      | field           | label           |
      | variant         | Variant         |
      | manufacturer    | Manufacturer    |
      | brand           | Brand           |
      | sub_brand       | Sub brand       |
      | functional_name | Functional name |
  
  #@javascript
  #Scenario: Editor edits product tags using multi autocomplete
  #  Given another product with tags "tag1, tag2"
  #  Then he should not see "tag1, tag2" autocomplete options
  #  When he enters "tag" into Tags field
  #  Then he should see "tag1, tag2" autocomplete options
  #  When he selects "tag2" multi autocomplete option
  #  And he submits the product form
  #  # Workaround while tags are not shown on the products page 
  #  When he is on the edit product page
  #  Then he should see "tag2" within "token-input-token-goodsmaster"
  #  #Then he should see product tags "tag2"

  @javascript
  Scenario: Editor deletes product tag
    Given the product has tags "tag1, tag2"
    When he deletes tags
    And he submits the product form
    # Workaround while tags are not shown on the products page
    When he is on the edit product page
    Then he should not see tags
    #Then he should not see product tags "tag1, tag2"
