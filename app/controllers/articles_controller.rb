class ArticlesController < ApplicationController  # Controller class and it's actions(a.k.a methods)
    # Include the controllers/concerns/paginable.rb
    include Paginable
    
    def index
        paginated = paginate(Article.recent) # '.recent' GET articles in recent -> older order
        render_collection(paginated)
    end

    def serializer
        ArticleSerializer   
    end

end