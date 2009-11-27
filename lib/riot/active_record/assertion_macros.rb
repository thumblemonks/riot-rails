class Riot::Assertion

  # An ActiveRecord assertion that expects to fail when a given attribute is validated after a nil value
  # is provided to it.
  #
  #    context "a User" do
  #      setup { User.new }
  #      topic.validates_presence_of(:name)
  #    end
  assertion(:validates_presence_of) do |actual, attribute|
    msg = "expected to validate presence of #{attribute.inspect}"
    error_from_writing_value(actual, attribute, nil) ? pass : fail(msg)
  end

  # An ActiveRecord assertion that expects to pass with a given value or set of values for a given
  # attribute.
  #
  #    context "a User" do
  #      setup { User.new }
  #      topic.allows_values_for :email, "a@b.cd"
  #      topic.allows_values_for :email, "a@b.cd", "e@f.gh"
  #    end
  assertion(:allows_values_for) do |actual, attribute, *values|
    bad_values = []
    values.each do |value|
      bad_values << value if error_from_writing_value(actual, attribute, value)
    end
    msg = "expected #{attribute.inspect} to allow value(s) #{bad_values.inspect}"
    bad_values.empty? ? pass : fail(msg)
  end

  # An ActiveRecord assertion that expects to fail with a given value or set of values for a given
  # attribute.
  #
  #    context "a User" do
  #      setup { User.new }
  #      topic.does_not_allow_values_for :email, "a"
  #      topic.does_not_allow_values_for :email, "a@b", "e f@g.h"
  #    end
  assertion(:does_not_allow_values_for) do |actual, attribute, *values|
    good_values = []
    values.each do |value|
      good_values << value unless error_from_writing_value(actual, attribute, value)
    end
    msg = "expected #{attribute.inspect} not to allow value(s) #{good_values.inspect}"
    good_values.empty? ? pass : fail(msg)
  end

  # An ActiveRecord assertion that expects to fail with an attribute is not valid for record because the
  # value of the attribute is not unique. Requires the topic of the context to be a created record; one
  # that returns false for a call to +new_record?+.
  #
  #    context "a User" do
  #      setup { User.create(:email => "a@b.cde", ... ) }
  #      topic.validates_uniqueness_of :email
  #    end
  assertion(:validates_uniqueness_of) do |actual, attribute|
    actual_record = actual
    if actual_record.new_record?
      fail("topic is not a new record when testing uniqueness of #{attribute}")
    else
      copied_model = actual_record.class.new
      actual_record.attributes.each do |dup_attribute, dup_value|
        copied_model.write_attribute(dup_attribute, dup_value)
      end
      copied_value = actual_record.read_attribute(attribute)
      msg = "expected to fail because #{attribute.inspect} is not unique"
      error_from_writing_value(copied_model, attribute, copied_value) ? pass : fail(msg)
    end
  end

  # An ActiveRecord assertion macro that expects to pass when a given attribute is defined as +has_many+
  # association. Will fail if an association is not defined for the attribute and if the association is
  # not +has_many.jekyll
  #
  #   context "a Room" do
  #     setup { Room.new }
  #
  #     topic.has_many(:doors)
  #     topic.has_many(:floors) # should probably fail given our current universe :)
  #   end
  assertion(:has_many) do |actual, attribute|
    reflection = actual.class.reflect_on_association(attribute)
    static_msg = "expected #{attribute.inspect} to be a has_many association, but was "
    if reflection.nil?
      fail(static_msg + "not")
    elsif "has_many" != reflection.macro.to_s
      fail(static_msg + "a #{reflection.macro} instead")
    else
      pass
    end
  end
private

  def error_from_writing_value(model, attribute, value)
    model.write_attribute(attribute, value)
    model.valid?
    model.errors.on(attribute)
  end

end # Riot::Assertion
