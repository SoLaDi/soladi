require "application_system_test_case"

class DistributionPointsTest < ApplicationSystemTestCase
  setup do
    @distribution_point = distribution_points(:one)
  end

  test "visiting the index" do
    visit distribution_points_url
    assert_selector "h1", text: "Distribution Points"
  end

  test "creating a Distribution point" do
    visit distribution_points_url
    click_on "New Distribution Point"

    fill_in "City", with: @distribution_point.city
    fill_in "Contact name", with: @distribution_point.contact_name
    fill_in "Housenumber", with: @distribution_point.housenumber
    fill_in "Name", with: @distribution_point.name
    fill_in "Street", with: @distribution_point.street
    fill_in "Zipcode", with: @distribution_point.zipcode
    click_on "Create Distribution point"

    assert_text "Distribution point was successfully created"
    click_on "Back"
  end

  test "updating a Distribution point" do
    visit distribution_points_url
    click_on "Edit", match: :first

    fill_in "City", with: @distribution_point.city
    fill_in "Contact name", with: @distribution_point.contact_name
    fill_in "Housenumber", with: @distribution_point.housenumber
    fill_in "Name", with: @distribution_point.name
    fill_in "Street", with: @distribution_point.street
    fill_in "Zipcode", with: @distribution_point.zipcode
    click_on "Update Distribution point"

    assert_text "Distribution point was successfully updated"
    click_on "Back"
  end

  test "destroying a Distribution point" do
    visit distribution_points_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Distribution point was successfully destroyed"
  end
end
