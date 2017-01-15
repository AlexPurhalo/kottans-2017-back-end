require 'helper_spec'

describe 'Sanity GET' do
  def app
    Users
  end

  before do
    get '/'
  end

  it 'has a correct status' do
    expect(last_response.status).to eq(200)
  end
  it 'shows hello message' do
    expect(last_response.body).to  include('hello world'.to_json)
  end
end