# frozen_string_literal: true
class UserPolicy < ApplicationPolicy

  def token_info?
    record && user && scope.where(id: record.id).exists? && record.id == user.id
  end

  def generate_new_token?
    token_info?
  end

end