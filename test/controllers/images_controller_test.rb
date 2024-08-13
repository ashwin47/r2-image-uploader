require "test_helper"

class ImagesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @image = images(:one)
    @user = users(:one)
    login_as(@user)
  end

  test "should get index" do
    get images_url
    assert_response :success
  end

  test "should get new" do
    get new_image_url
    assert_response :success
  end

  test "should create image" do
    assert_difference("Image.count") do
      post images_url, params: { 
        image: { 
          name: "New Image", 
          file: fixture_file_upload('test_image.jpg', 'image/jpeg')
        } 
      }
    end

    assert_redirected_to image_url(Image.last)
    assert_enqueued_with(job: ActiveStorage::AnalyzeJob)
  end

  test "should show image" do
    get image_url(@image)
    assert_response :success
  end

  test "should get edit" do
    get edit_image_url(@image)
    assert_response :success
  end

  test "should update image" do
    patch image_url(@image), params: { image: { name: "Updated Name" } }
    assert_redirected_to image_url(@image)
    @image.reload
    assert_equal "Updated Name", @image.name
  end

  test "should destroy image" do
    assert_difference("Image.count", -1) do
      delete image_url(@image)
    end

    assert_redirected_to images_url
  end

  private

  def login_as(user)
    post session_url, params: { email_address: user.email_address, password: 'password' }
  end
end