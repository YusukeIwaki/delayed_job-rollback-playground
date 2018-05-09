# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  username   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  validates :username,
    presence: true,
    uniqueness: true,
    length: { in: 4..16 }
    
  after_create do |record|
    record.delay.notify_created
  end
  
  has_one :user_identity_verification, dependent: :destroy
  
  class IdentityVerificationError < StandardError
  end
  
  # called by UserController in transaction.
  def verify
    if user_identity_verification.blank?
      conn = Faraday.new(url: 'http://requestbin.fullcontact.com/')
      response = conn.post '/s9o13cs9', { type: "identity_verification", username: username }
      date = Time.zone.parse(response.headers["date"]).to_i
      sleep 5
      if date % 2 == 0
        create_user_identity_verification(memo: "OK")
      else
        raise IdentityVerificationError
      end
    end
    user_identity_verification
  end
  
  # called by ActiveRecord callback.
  def notify_created
    conn = Faraday.new(url: 'http://requestbin.fullcontact.com/')
    conn.post '/s9o13cs9', { type: "notify_created", username: username }
  end
end
