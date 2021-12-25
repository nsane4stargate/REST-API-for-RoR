    module Paginable
    # NOTE: 'extend' is like calling a static method in Java or C++    ex. <Classname>.<class_method>
    # NOTE: 'include' requires an instance (.new) of the class to call its methods    ex<Classname>.new.<class_method>

    extend ActiveSupport::Concern

    def paginate(collection)
        paginator.call(
            collection,
            params: pagination_params,
            base_url: request.url      # Is used to generated 'last','previous', etc...
        )
    end

    def paginator
        JSOM::Pagination::Paginator.new
    end

    def pagination_params
        # JSONAPI specification for pagination hash with keys: {number: size:}
        params.permit![:page]
    end

    def render_collection(paginated)
        # NOTE: If Failure/Error: expect(json['links'].length).to eq(5) pops up during testing, add 'options'
        options = { 
            meta: paginated.meta.to_h, 
            links: paginated.links.to_h 
        }
        
        results = serializer.new(paginated.items, options)
         
        # 1) One way to render the JSON response. Just comment out 'results' variable above 
        # render json: serializer.new(collect.items, options), status: :ok

        render json: results, status: :ok
    end
end