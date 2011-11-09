module Lokka
  module Redirect
    class Rule < OpenStruct; end

    def self.registered(app)
      app.get '/admin/plugins/redirect' do
        redirect '/admin/plugins/redirect/rules'
      end

      app.get '/admin/plugins/redirect/rules' do
        @rules = Option.lokka_redirect_rules ? JSON.parse(Option.lokka_redirect_rules) : []
        haml :"plugin/lokka-redirect/views/rules/index", :layout => :"admin/layout"
      end

      app.get '/admin/plugins/redirect/rules/new' do
        @rule = Rule.new
        haml :"plugin/lokka-redirect/views/rules/new", :layout => :"admin/layout"
      end

      app.post '/admin/plugins/redirect/rules' do
        rule = params[:lokka_redirect_rule]
        rules = Option.lokka_redirect_rules ? JSON.parse(Option.lokka_redirect_rules) : []
        rules.push rule
        Option.lokka_redirect_rules = rules.to_json
        flash[:notice] = 'Redirect Rule was successfully created.'
        redirect '/admin/plugins/redirect/rules'
      end

      app.get '/admin/plugins/redirect/rules/:id/edit' do |id|
        rules = Option.lokka_redirect_rules ? JSON.parse(Option.lokka_redirect_rules) : []
        @rule = Rule.new(rules[id.to_i])
        @rule.id = id
        haml :"plugin/lokka-redirect/views/rules/edit", :layout => :"admin/layout"
      end

      app.put '/admin/plugins/redirect/rules/:id' do |id|
        rules = Option.lokka_redirect_rules ? JSON.parse(Option.lokka_redirect_rules) : []
        rules[id.to_i] = params[:lokka_redirect_rule]
        Option.lokka_redirect_rules = rules.to_json
        flash[:notice] = 'Redirect Rule was successfully updated.'
        redirect '/admin/plugins/redirect/rules'
      end

      app.delete '/admin/plugins/redirect/rules/:id' do |id|
        rules = Option.lokka_redirect_rules ? JSON.parse(Option.lokka_redirect_rules) : []
        rules.delete_at(id.to_i)
        Option.lokka_redirect_rules = rules.to_json
        flash[:notice] = 'Redirect Rule was successfully deleted.'
        redirect '/admin/plugins/redirect/rules'
      end

      app.get '*' do |path|
        pass if path =~ /^\/admin\//

        rules = Option.lokka_redirect_rules ? JSON.parse(Option.lokka_redirect_rules) : []
        rules.each do |rule|
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
