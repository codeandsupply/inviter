# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'codeandsupply.co', 'www.codeandsupply.co'
    resource '/invitations',
             headers: :any,
             methods: [:post],
             max_age: 3600
  end
end

Rails.application.config.hosts << 'codeandsupply.co'
Rails.application.config.hosts << 'www.codeandsupply.co'
Rails.application.config.hosts << 'fierce-temple-7331.herokuapp.com'
