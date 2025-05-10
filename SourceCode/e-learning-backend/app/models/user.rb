# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  acts_as_paranoid

  belongs_to :school, optional: true
  has_one :teacher, dependent: :destroy
  has_one :student, dependent: :destroy
  has_many :forum_posts
  has_many :forum_replies
  has_many :chat_groups, foreign_key: :created_by
  has_many :chat_group_members
  has_many :chat_messages
  has_many :equipment_reports

  validates :username, presence: true
  validates :password, presence: true
  validates :role, presence: true
  validate :username_unique_within_school

  accepts_nested_attributes_for :teacher, allow_destroy: true
  accepts_nested_attributes_for :student, allow_destroy: true

  default_scope { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }

  private

  def username_unique_within_school
    return if school_id.nil?
    if User.where(username: username, school_id: school_id).where.not(id: id).exists?
      errors.add(:username, 'đã tồn tại trong trường này')
    end
  end
end
