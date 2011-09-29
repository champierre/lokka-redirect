module Lokka
  module Rewrite
    def self.registered(app)
      app.get '/admin/plugins/rewrite' do
        redirect '/admin/plugins/rewrite/rules'
      end

      app.get '/admin/plugins/rewrite/rules' do
        @rules = Option.lokka_rewrite_rules ? JSON.parse(Option.lokka_rewrite_rules) : []
        haml :"plugin/lokka-rewrite/views/rules/index", :layout => :"admin/layout"
      end

      app.get '/admin/plugins/rewrite/rules/new' do
        haml :"plugin/lokka-rewrite/views/rules/new", :layout => :"admin/layout"
      end

      app.post '/admin/plugins/rewrite/rules' do
        @rules = Option.lokka_rewrite_rules ? JSON.parse(Option.lokka_rewrite_rules) : []
        @rules.push params['rule']
        Option.lokka_rewrite_rules = @rules.to_json
        flash[:notice] = 'Rewrite Rule was successfully created.'
        redirect '/admin/plugins/rewrite/rules'
      end

      app.get '/admin/plugins/rewrite/rules/:id/edit' do |id|
        @rules = Option.lokka_rewrite_rules ? JSON.parse(Option.lokka_rewrite_rules) : []
        @rule = @rules[id.to_i]
        haml :"plugin/lokka-rewrite/views/rules/edit", :layout => :"admin/layout"
      end

      app.put '/admin/plugins/rewrite/rules/:id' do |id|
        @rules = Option.lokka_rewrite_rules ? JSON.parse(Option.lokka_rewrite_rules) : []
        @rules[id.to_i] = params['rule']
        Option.lokka_rewrite_rules = @rules.to_json
        flash[:notice] = 'Rewrite Rule was successfully updated.'
        redirect '/admin/plugins/rewrite/rules'
      end

      app.delete '/admin/plugins/rewrite/rules/:id' do |id|
        @rules = Option.lokka_rewrite_rules ? JSON.parse(Option.lokka_rewrite_rules) : []
        @rules.delete_at(id.to_i)
        Option.lokka_rewrite_rules = @rules.to_json
        flash[:notice] = 'Rewrite Rule was successfully deleted.'
        redirect '/admin/plugins/rewrite/rules'
      end

      app.get '*' do |path|
        pass if path =~ /^\/admin\//

        @rules = Option.lokka_rewrite_rules ? JSON.parse(Option.lokka_rewrite_rules) : []
        @rules.each do |rule|
          pattern = rule['pattern']
          substitution = rule['substitution']
          if pattern && substitution
            regexp = Regexp.new(pattern)
            if path =~ regexp
              redirect path.gsub(regexp, substitution), 301
            end
          end
        end
        pass
      end
    end
  end
end