require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest



  test 'Sample Data Loaded' do

    csv = loadSampleData
    assert csv

  end

  test "should get index" do
    get 'http://localhost:3001/reports'
    assert_response :success
  end
  
  test 'report post requests must contain both a distributer ID and a CSV file in the request body.' do
    post 'http://localhost:3001/reports'
    assert @response.status == 422, 'Post requests without a distributer ID should return unprocessable.'
  end
  
  test 'post including only distributer should return unprocessable' do
    post 'http://localhost:3001/reports?distributer_id=1'

    assert @response.status == 422, 'Post requests without an accompanying CSV file should return unprocessable.' 
  end

  test 'post including only csv file without distributer ID should return unprocessable' do

    csv = loadSampleData
    post 'http://localhost:3001/reports', params: {body: csv}

    assert @response.status == 422, 'Post requests of a report without distributer should return unprocessable.'

  end

  test 'Posts including distributer ID and CSV should be processed.' do
    csv = loadSampleData

    post 'http://localhost:3001/reports?distributer_id=1', params: {body: csv.tempfile}

    assert @response.status == 202, 'This should return 202, got ' + String(@response.status)
  end

  private

  def loadSampleData
    csv_file = fixture_file_upload('../sample_orders.csv', 'text/csv')
  end

  


end
