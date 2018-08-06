shared_examples_for 'Api Authenticable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      get api_path, params: { format: :json }
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      get api_path, params: { format: :json, access_token: '1234' }
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Check the arguments object' do |resource_name, args, base_path = ''|
  args.each do |attr|
    it "#{resource_name} object contains #{attr}" do
      expect(response.body).to be_json_eql(send(resource_name.to_sym).send(attr.to_sym).to_json).at_path(base_path + attr)
    end
  end
end

shared_examples_for 'Response success' do
  it 'returns 200 status code' do
    expect(response).to be_success
  end
end

shared_examples_for 'Number of objects' do | objects, size, object_path = ''|
  it "returns list of #{objects}" do
    expect(response.body).to have_json_size(size).at_path(object_path)
  end
end
