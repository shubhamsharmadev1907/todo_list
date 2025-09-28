class Ability
  include CanCan::Ability

  def initialize(user)
    # Guests
    user ||= User.new(role: "guest") # guest user (not persisted)

    if user.admin?
      can :manage, :all
    else
      # Regular users can read and manage their own tasks
      can :read, Task, user_id: user.id
      can :create, Task
      can :update, Task, user_id: user.id
      can :destroy, Task, user_id: user.id

      # guests (not logged in) cannot do anything; authorize checks will require authentication
    end
  end
end
