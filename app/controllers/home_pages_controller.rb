# frozen_string_literal: true

class HomePagesController < ApplicationController
  def index
    @categories = Category.all
  end
end
