# frozen_string_literal: true

require 'test_helper'

class BookTablesControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get book_tables_new_url
    assert_response :success
  end

  test 'should get index' do
    get book_tables_index_url
    assert_response :success
  end

  test 'should get create' do
    get book_tables_create_url
    assert_response :success
  end

  test 'should get show' do
    get book_tables_show_url
    assert_response :success
  end
end
