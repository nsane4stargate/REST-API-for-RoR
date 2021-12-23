require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#validation' do  # Use '#' prefix to test INSTANCE methods
    let(:article) { create(:article) }

    it 'test that factory is valid' do
      expect(article).to be_valid
      article.save!
    end

    it 'has an invalid title' do
      article.title = ''
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end
    
    it 'has invalid content' do
      article.content = ''
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it 'has invalid slug' do
      article.slug = ''
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include("can't be blank")
    end

    it 'has a unique slug' do                             
      article_two = build(:article, slug: article.slug)
      expect(article_two).not_to be_valid
      expect(article_two.errors[:slug]).to include('has already been taken')
    end
  end

  describe '.recent' do # Use '.' prefix to test methods that belongs to a class
    it 'returns article in correct order' do
      recent = create(:article)
      older = create(:article, created_at: 1.hour.ago)
      
      # NOTE: ONLY testing to see if the model's articles are STORED in descending order
      # based of the time the were added/updated. For this we DO NOT NEED TO MAKE A GET 
      # REQUEST. Equivalent to evaluating if an array is in oder on a algorithm that 
      # a web app. ONLY test GET responses in the spec/routing folder
      expect(described_class.recent).to eq( [recent, older] )

      # Update the 'recent' article 
      recent.update_column(:created_at, 2.hour.ago)

      # Should expect a different result
      expect(described_class.recent).to eq( [older, recent] )
    end
  end
end
