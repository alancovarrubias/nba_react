require 'test_helper'

class GameDatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_date = game_dates(:one)
  end

  test "should get index" do
    get game_dates_url, as: :json
    assert_response :success
  end

  test "should create game_date" do
    assert_difference('GameDate.count') do
      post game_dates_url, params: { game_date: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show game_date" do
    get game_date_url(@game_date), as: :json
    assert_response :success
  end

  test "should update game_date" do
    patch game_date_url(@game_date), params: { game_date: {  } }, as: :json
    assert_response 200
  end

  test "should destroy game_date" do
    assert_difference('GameDate.count', -1) do
      delete game_date_url(@game_date), as: :json
    end

    assert_response 204
  end
end
