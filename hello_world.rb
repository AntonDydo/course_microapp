# frozen_string_literal: true

require 'cuba'
require 'cuba/safe'
require 'pstore'

Cuba.use Rack::Session::Cookie, secret: '__a_very_long_string__'

Cuba.plugin Cuba::Safe

Cuba.define do
  store = PStore.new('data.pstore')
  on get do
    on root do
      res.write 'About'
    end

    on 'get/:key' do |key|
      if !store.transaction { store[key] }.nil?
        res.write store.transaction { store[key] }
      else
        res.write 'not found'
      end
    end

    on 'set/:key/:value' do |key, value|
      store.transaction do
        store[key] = value
      end
      res.write 'accepted'
    end
  end
end
