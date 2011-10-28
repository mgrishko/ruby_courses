@javascript
Feature: Test packages
  In order to test existing Base Item
  As a supplier
  I want to create, edit and drop valid packaging tree.

  Scenario: Test packages
    Given "supplier" has gln "1234" and password "1234"
    And I have a base_item
    When I logged in as "supplier"
    And I go to the base_item page
    And I follow "edit_base_item_btn"
    And I wait for 1 second
    And I hover element ".edited.pi"
    And I wait for 1 second
    And I follow "pi_edit" within "#first_pi"
    And I follow "packaging_item_packaging_name_link"
    ##without Pallet
    And I follow "Bag"
    And I follow "pack_apply"
    And I check "base_item_order_unit"
    And I check "base_item_consumer_unit"
    And I press "base_item_submit"
    And I wait for 1 seconds
    And I hover element ".edited.pi"
    And I follow "pack"
    And I fill in "packaging_item_number_of_next_lower_item" with "4"
    And I fill in hidden_field "packaging_item_packaging_name" with "BX"
    And I fill in "packaging_item_gtin" with "43210121"
    And I fill in "packaging_item_height" with "5"
    And I fill in "packaging_item_width" with "5"
    And I fill in "packaging_item_depth" with "5"
    And I fill in "packaging_item_gross_weight" with "5"
    And I check "packaging_item_order_unit"
    And I press "packaging_item_submit"
    And I wait for 1 seconds
    And I hover element "#pi-1.edited.pi" within ".edited.pi-cont"
    And I follow "pack" within "#pi-1"
    And I fill in "packaging_item_number_of_next_lower_item" with "6"
    And I fill in hidden_field "packaging_item_packaging_name" with "PB"
    And I fill in "packaging_item_gtin" with "43220120"
    And I fill in "packaging_item_height" with "30"
    And I fill in "packaging_item_width" with "30"
    And I fill in "packaging_item_depth" with "30"
    And I fill in "packaging_item_gross_weight" with "30"
    And I check "packaging_item_order_unit"
    And I check "packaging_item_consumer_unit"
    And I press "packaging_item_submit"
    And I wait for 1 seconds
    Then I should see img_id "consumer_unit" within "#first_pi"
    And I should see img_id "order_unit" within "#first_pi"
    And I wait for 1 seconds
    And I should see img_id "order_unit" within "#pi-1"
    And I should see img_id "consumer_unit" within "#pi-2"
    And I should see img_id "order_unit" within "#pi-2"
    And I should see "4 bags" within "#pi-1"
    And I should see "24 bags" within "#pi-2"
    And I wait for 1 seconds
    When I hover element "#pi-2.edited.pi" within ".edited.pi-cont"
    And I follow "pi_edit" within "#pi-2"
    And I fill in "packaging_item_number_of_next_lower_item" with "8"
    And I fill in hidden_field "packaging_item_packaging_name" with "PK"
    And I fill in "packaging_item_height" with "50"
    And I fill in "packaging_item_width" with "50"
    And I fill in "packaging_item_depth" with "50"
    And I fill in "packaging_item_gross_weight" with "50"
    And I uncheck "packaging_item_order_unit"
    And I press "packaging_item_submit"
    And I wait for 1 seconds
    Then I should see img_id "consumer_unit" within "#first_pi"
    And I should see img_id "order_unit" within "#first_pi"
    And I wait for 1 seconds
    And I should see img_id "order_unit" within "#pi-1"
    And I should see img_id "consumer_unit" within "#pi-2"
    And I should see "4 bags" within "#pi-1"
    And I should see "32 bags" within "#pi-2"
    And I wait for 1 seconds
    When I hover element "#pi-2.edited.pi" within ".edited.pi-cont"
    And I follow "pack" within "#pi-2"
    And I fill in "packaging_item_number_of_next_lower_item" with "1"
    And I fill in hidden_field "packaging_item_packaging_name" with "PB"
    And I fill in "packaging_item_gtin" with "00000000000000"
    And I fill in "packaging_item_height" with "50"
    And I fill in "packaging_item_width" with "50"
    And I fill in "packaging_item_depth" with "50"
    And I fill in "packaging_item_gross_weight" with "50"
    And I check "packaging_item_order_unit"
    And I check "packaging_item_consumer_unit"
    And I press "packaging_item_submit"
    And I wait for 1 seconds
    And I hover element "#pi-3.edited.pi" within ".edited.pi-cont"
    And I follow "pi_delete" within "#pi-3"
    And I wait for 1 seconds
    And I confirm popup
    And I wait for 1 seconds
    Then the element matched by "#first_pi" should exist
    And the element matched by "#pi-1" should exist
    And the element matched by "#pi-2" should exist
    And the element matched by "#pi-3" should not exist
    When I hover element "#pi-2.edited.pi" within ".edited.pi-cont"
    And I follow "pack" within "#pi-2"
    And I press "packaging_item_submit"
    And I wait for 1 seconds
    Then the element matched by ".siblings_errors" should exist
    And I should see "16 errors prohibited this packaging item from being saved" within ".siblings_errors"
    And I should see "Gtin can't be blank & is not a number & is invalid" within ".siblings_errors"
    And I should see "Packaging type can't be blank" within ".siblings_errors"
    And I should see "Number of next lower item is not a number & can't be blank" within ".siblings_errors"
    And I should see "Number of bi items is not a number & can't be blank" within ".siblings_errors"
    And I should see "Gross weight is not a number & can't be blank" within ".siblings_errors"
    And I should see "Height is not a number & can't be blank" within ".siblings_errors"
    And I should see "Depth is not a number & can't be blank" within ".siblings_errors"
    And I should see "Width is not a number & can't be blank" within ".siblings_errors"
    When I follow "Cancel" within ".new_packaging_item"
    And I hover element "#pi-2.edited.pi" within ".edited.pi-cont"
    And I follow "pack" within "#pi-2"
    And I fill in "packaging_item_number_of_next_lower_item" with "2"
    And I follow "packaging_item_packaging_name_link"
    And I follow "Pallet"
    And I follow "pack_apply"
    And I fill in "packaging_item_gtin" with "00000000000000"
    And I fill in "packaging_item_height" with "500"
    And I fill in "packaging_item_width" with "500"
    And I fill in "packaging_item_depth" with "500"
    And I fill in "packaging_item_gross_weight" with "500"
    And I fill in "packaging_item_quantity_of_trade_items_per_pallet_layer" with "5"
    And I fill in "packaging_item_quantity_of_layers_per_pallet" with "5"
    And I fill in "packaging_item_stacking_factor" with "5"
    And I check "packaging_item_order_unit"
    And I check "packaging_item_consumer_unit"
    And I press "packaging_item_submit"
    And I wait for 1 seconds
    And I hover element "#pi-1.edited.pi" within ".edited.pi-cont"
    And I wait for 1 seconds
    And I follow "pack" within "#pi-1"
    And I follow "Cancel"
    And I wait for 3 seconds
    #edit, cancel, edit
    And I wait for 1 seconds
    And I hover element "#pi-1.edited.pi" within ".edited.pi-cont"
    And I wait for 2 seconds
    Then should be visible "pack_pi"
    And I wait for 2 seconds
    And I unhover element "#pi-1.edited.pi" within ".edited.pi-cont"
    When I hover element "#pi-3.edited.pi" within ".edited.pi-cont"
    Then should not be visible "pack_pi"
    And I should see img_id "consumer_unit" within "#first_pi"
    And I should see img_id "order_unit" within "#first_pi"
    And I wait for 1 seconds
    And I should see img_id "order_unit" within "#pi-1"
    And I should see img_id "consumer_unit" within "#pi-2"
    And I should see img_id "order_unit" within "#pi-3"
    And I should see img_id "consumer_unit" within "#pi-3"
    And I should see "4 bags" within "#pi-1"
    And I should see "32 bags" within "#pi-2"
    And I should see "64 bags" within "#pi-3"
    And I press "base_item_submit"
    And I go to the base_items page
    And I follow "4607085440385"
    Then I should see the alt_img text "4" within "#first_pi"
    And I wait for 1 seconds
    And I should see the alt_img text "11" within "#pi-1"
    And I should see the alt_img text "31" within "#pi-2"
    And I should see the alt_img text "32" within "#pi-3"
    And I should see "4607085440385" within "#first_pi"
    And I wait for 1 seconds
    And I should see "43210121" within "#pi-1"
    And I should see "43220120" within "#pi-2"
    And I should see "00000000000000" within "#pi-3"
