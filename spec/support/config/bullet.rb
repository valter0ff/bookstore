# frozen_string_literal: true

RSpec.configure do |config|
  if Bullet.enable?
    config.before do
      Bullet.start_request
    end

    config.before(:each, bullet: :skip) do
      Bullet.enable = false
    end

    config.after(:each, bullet: :skip) do
      Bullet.enable = true
    end

    config.after do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end
end
