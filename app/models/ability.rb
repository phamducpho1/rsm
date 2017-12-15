class Ability
  include CanCan::Ability

  def initialize user, controller_namespace = nil
    if user.present?
      case controller_namespace
        when "Employers"
          permission_employer user
        else
          if user.employer?
            permission_employer user
          elsif user.admin?
            permission_admin
          end
          permission_user user
      end
      user_permissions user
    else
      undefine_user
    end
  end

  def employer_permissions_dashboard user
    return unless user.employer?
    manage_company user
  end

  def employer_permissions user
    manage_company user
    can :manage, Job, id: user.id
  end

  def admin_permissions user
    return unless user.admin?
    can :manage, :all
  end

  def user_permissions user
    can :read, :all
    can :manage, User, id: user.id
    can :manage, Achievement, user_id: user.id
    can :manage, Certificate, user_id: user.id
    can :manage, Club, user_id: user.id
  end

  private

  def permission_employer user
    return unless user.employer?
    if user.members.present?
      manage_company user
    end
  end

  def manage_company user
    can :update, Company do |company|
      user.is_employer? company
    end
    can :manage, Member
    can :manage, Apply
    can :manage, Job
  end

  def permission_admin
    can :manage, :all
  end

  def permission_user user
    can :read, :all
    can :update, User, id: user.id
    can :manage, Club, user_id: user.id
    can :manage, Achievement, user_id: user.id
    can :manage, Certificate, user_id: user.id
    can :manage, Experience, user_id: user.id
    can :manage, BookmarkLike, user_id: user.id
  end

  def undefine_user
    can :create, Apply
  end
end
