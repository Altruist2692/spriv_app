class User < ApplicationRecord
  DEFAULT_VALUES = { status_id: 1, status_timeout: 0}
  validates :first_name, :last_name, :user_login, :company_id, :email, :phone,
            :person_id, :status_id, :status_timeout, presence: true
  validates :phone, presence: true, numericality: true,
                 :length => { :minimum => 10, :maximum => 15 }
  validates :company_id, numericality: true
end
