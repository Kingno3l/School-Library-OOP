class Teacher < Person
  attr_reader :specialization

  def initialize(id, age, specialization, name = 'Unknown', parent_permission: true)
    super(age, name, specialization)
    @specialization = specialization
  end

  def can_use_services?
    true
  end
end
