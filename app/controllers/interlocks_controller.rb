# frozen_string_literal: true

class InterlocksController < ApplicationController
  def index
    @interlocks = Interlock.includes(:turnouts).order(:name).all
  end

  def new
    @interlock = Interlock.new
  end

  def create
    @interlock = Interlock.new(new_interlock_params)

    unless @interlock.save
      render :new, status: :bad_request
      return
    end

    redirect_to interlocks_path
  end

  private

  def new_interlock_params
    params.require(:interlock)
          .permit(:name)
  end
end
