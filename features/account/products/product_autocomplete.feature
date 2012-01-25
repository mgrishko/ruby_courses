Feature: Autocompletion for product form fields
  In order to fill out product forms faster
  An editor
  Should be able to use autocompletion

  Background: Account exists
    Given an activated account
    And that account has a product
    And an authenticated user with editor role on edit product page
  
  @javascript
  Scenario: Editor edits product brand using autocomplete
    Given another product with brand "brand123"
    And another product with brand "brand456"
    Then he should not see "brand123, brand456" autocomplete options
    When he enters "brand" into "Brand" field 
    Then he should see "brand123, brand456" autocomplete options
    When he selects the first autocomplete option in "Brand" field
    And he submits the product form
    Then he should see product brand "brand456"
  
  #@javascript
  #Scenario: Editor edits product manufacturer using autocomplete
  #  Given another product with manufacturer "manufacturer123"
  #  And another product with manufacturer "manufacturer456"
  #  Then he should not see "manufacturer123, manufacturer456" autocomplete options
  #  When he enters "manufacturer" into "Manufacturer" field
  #  Then he should see "manufacturer123, manufacturer456" autocomplete options
  #  When he selects the first autocomplete option in "Manufacturer" field
  #  And he submits the product form
  #  Then he should see product manufacturer "manufacturer456"
  
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
