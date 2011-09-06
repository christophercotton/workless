require 'heroku'

module Delayed
  module Workless
    module Scaler

      class Heroku < Base

        require "heroku"

        def up
          w = workers
          if w == 0
            client.set_workers(ENV['APP_NAME'], 1)
          elsif w < 2 and jobs.count > 200
            client.set_workers(ENV['APP_NAME'], 10)
          end
        end

        def down
          client.set_workers(ENV['APP_NAME'], 0) unless jobs.count > 0
        end

        def workers
          client.info(ENV['APP_NAME'])[:workers].to_i
        end

        private

        def client
          @client ||= ::Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
        end

      end

    end
  end
end