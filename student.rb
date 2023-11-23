class Student < Person
  attr_accessor :classroom

  def initialize(id, age, name = 'Unknown', parent_permission: true)
    super(id, age, name, parent_permission)
    @classroom = nil
  end

  def assign_to_classroom(classroom)
    return unless classroom.is_a?(Classroom)

    @classroom&.remove_student(self)
    @classroom = classroom
    classroom.add_student(self)
  end

  def play_hooky
    '¯\\(ツ)/¯'
  end
end
