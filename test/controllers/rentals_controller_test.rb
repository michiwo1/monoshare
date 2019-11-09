require 'test_helper'

class RentalsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get rentals_create_url
    assert_response :success
  end

  test "should get destroy" do
    get rentals_destroy_url
    assert_response :success
  end

end
