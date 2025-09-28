class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :done, :created_at, :updated_at
  attribute :owner do
    { id: object.user&.id, email: object.user&.email }
  end
end
