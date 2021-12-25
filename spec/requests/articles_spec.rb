require 'rails_helper'

RSpec.describe ArticlesController do
    describe '#index' do
        it 'returns a success response' do
            get '/articles'
            # expect(response.status).to eq(200)
            expect(response).to have_http_status(:ok)
        end

        it 'returns a proper JSON' do
            article = create(:article)
            get '/articles/'
            #body = JSON.parse(response.body).deep_symbolize_keys # parse the JSON body response # returns symbols instead of strings
            # above line has been simplified. JSON.parse() was moved to spec/support/api_helper.rb. 
            # "Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }" was uncomment and
            #  config.include ApiHelpers was include in the rails_heper.rb file, so that it can access the module "ApiHelpers"
            #  when testing using rspec
            # pp "variable_name" # Print out the body to see the different values

            # 1) One way to test the JSON response body
            expect(json_data.length).to eq(1)
            expected_response = json_data.first
            #pp article
            #pp "//////////////////////////////////////////////"
            #pp expected_response
            aggregate_failures do
                expect(expected_response[:type]).to eq('article')
                expect(expected_response[:id]).to eq(article.id.to_s)
                expect(expected_response[:attributes]).to eq(
                    slug: article.slug,
                    title: article.title,
                    content: article.content
                )

                # 2) Another way to test the JSON respnse body
                # expect(json_data).to eq(
                #     [
                #         { 
                #             id: article.id.to_s, # .to_s convert to string
                #             type: 'article',
                #             attributes: {
                #                 slug: article.slug,
                #                 title: article.title,
                #                 content: article.content
                #             }
                #         }
                #     ]
                # )
            end
        end

        it 'return articles in proper order' do # newer article on top, older articles on bottom
            # recent = create(:article)
            # older = create(:article, created_at: 1.hour.ago)   #NOTE: in this order, it will always pass so lets change the order

            older = create(:article, created_at: 1.hour.ago)
            recent = create(:article)

            get '/articles'
            # check ids order
            ids = json_data.map { |article_item| article_item[:id].to_i }
            expect(ids).to eq(
                [ recent.id, older.id ]
            )
        end

        it 'pagination results' do
            article_one, article_two, article_three = create_list(:article, 3) # Use the create_list method for concised and condensed code

            # After landing on the '/articles' route, GET the index to access the data, based on the params passed
            get '/articles', params: { page: { number: 2, size: 1 } }
            # Return the json_data object to inspect
            aggregate_failures do
                expect(json_data.length).to eq(1)
                expect(json_data.first[:id]).to eq(article_two.id.to_s)
            end
        end


        it 'contains pagination links in the response' do
            article_one, article_two, article_three = create_list(:article, 3) # Use the create_list method for concised and condensed code

            # After landing on the '/articles' route, GET the index to access the data, based on the params passed
            get '/articles', params: { page: { number: 2, size: 1 } }

            # Inspect to see if the 5 JSON default links as SYMBOLS NOT STRINGS, are returned
            aggregate_failures do
                expect(json[:links].length).to eq(5)
                expect(json[:links].keys).to contain_exactly(
                    :first, :next, :prev, :last, :self
                )
            end
        end

        describe '#show' do
            let(:article) { create:article } 
    
            subject { get "/articles/#{article.id}" }
            
            before { subject }
    
            it 'return sucessfull response' do 
                expect(response).to have_http_status(:ok)
            end
    
            it 'returns a proper JSON' do
                aggregate_failures do
                    expect(json_data[:id]).to eq(article.id.to_s)
                    expect(json_data[:type]).to eq('article')
                    expect(json_data[:attributes]).to eq(
                        title: article.title,
                        content: article.content,
                        slug: article.slug
                )
                end 
            end 
        end
    end
end