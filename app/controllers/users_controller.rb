# frozen_string_literal: true

class UsersController < ApplicationController
  def destroy
    current_user.destroy!
    log_out
    redirect_to root_path, notice: 'アカウントを削除しました'
  end
end
