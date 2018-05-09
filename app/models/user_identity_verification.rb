# == Schema Information
#
# Table name: user_identity_verifications
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  memo       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserIdentityVerification < ApplicationRecord
  belongs_to :user
  
  validates :user_id,
    presence: true,
    uniqueness: true
end
