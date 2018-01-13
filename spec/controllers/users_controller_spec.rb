describe UsersController, type: :controller do
	describe "index action" do
	  it 'returns a list of users' do
			create_list(:user, 10)

			get 'index'

			json = JSON.parse(response.body)

			expect(response).to be_success

			expect(json.length).to eq(10)
		end

		context "more than 25 users" do 
			it 'cuts off at 25 results' do
				create_list(:user, 100)

				get 'index'

				json = JSON.parse(response.body)


				expect(response).to be_success

				expect(json.length).to eq(25)
			end

			it "passing the page parmeter returns more results" do
				create_list(:user, 37)

				get 'index', params: {page: 2}

				json = JSON.parse(response.body)

				# test for the 200 status-code
				expect(response).to be_success

				expect(json.length).to eq(12)
			end

			it "if the page exceeds the reults return an empty array" do
				create_list(:user, 37)

				get 'index', params: {page: 3}

				json = JSON.parse(response.body)

				# test for the 200 status-code
				expect(response).to be_success

				expect(json.empty?).to be(true)
			end
		end
	end
	
	describe "show" do
		context "the user exists and matches the id" do
			it "returns the user" do 
				user = create(:user)

				get 'show', params: {id: user.user_id}

				json = response.body

				expect(response).to be_success

				expect(json).to eq("[" + user.to_json + "]")
			end
		end
		context "the user does not exist" do
			it "returns the user" do 

				get 'show', params: {id: 3}

				json = response.body

				expect(response).to be_success

				expect(json).to eq("[]")
			end
		end
	end


end
