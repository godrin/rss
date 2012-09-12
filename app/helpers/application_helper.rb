# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
end

class Array
  def average
    if length==0
      return nil
    end
    select{|x|x}.inject(0){|a,b|a+b}/length
  end
end

def assert
  result=yield
  if result==false or result==nil
    raise "Assertion failed ! #{caller.inspect}"
  end
end

def ensure_type(object,klass)
  assert{object.is_a?(klass)}
end

def check_signature(objects,klasses)
  assert{objects.length==klasses.length}
  0.upto(objects.length-1){|i|
    ensure_type(objects[i],klasses[i])
  }
end

def deprecated
end