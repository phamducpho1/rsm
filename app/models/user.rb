class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :achievements, dependent: :destroy
  has_many :clubs, dependent: :destroy
  has_many :certificates, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :friends, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :active_follow, class_name: Relationship.name, foreign_key: "follower_id", dependent: :destroy
  has_many :passive_follow,class_name:Relationship.name, as: :followed
  has_many :active_report, class_name: Report.name, foreign_key: "reporter_id", dependent: :destroy
  has_many :passive_report, class_name: Report.name, as: :reported
  has_many :jobs, dependent: :destroy
  has_many :bookmark_likes, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :applys, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :members, dependent: :destroy
end
