require 'helper_spec'

describe 'GET categories' do
  before { Categories.before { env['api.tilt.root'] = 'app/views' } }
  def app; Categories; end

  before do
    Category.create(name: 'fun')
    Category.create(name: 'cartoons')
  end

  describe 'POSITIVE' do
    before { get '/categories' }

    context 'shows following data for categories:' do
      it 'id' do
        expect(last_response.body).to include(:id.to_json, '1', '2')
      end

      it 'name' do
        expect(last_response.body).to include(:name.to_json, 'fun', 'cartoons')
      end
    end
  end
end