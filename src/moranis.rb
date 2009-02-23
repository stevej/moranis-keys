#!/usr/bin/ruby

# Example Moranis Key generator. Assumes the following:
# 64-bit key
# HO 32-bits is unix epoch (time in seconds)
# LO 32-bits is a random number.
class MoranisKeys
  # Returns the current time.
  # Our example assumes positive unsigned 32-bit number.
  def get_time
    Time.now.to_i
  end

  # Returns a random number upper-bounded by the number parameter.
  # Our example assumes a positive unsigned 32-bit number.
  def random(number)
    rand(number)
  end

  # Returns a bitpacked 64-bit number, the HO 32-bits are the
  # epoch and the LO 32-bits are a random number.
  def generate
    (get_time << 32) | random(0xFFFFFFFF)
  end
  
  # The String format is: HO bits as base-10, a colon, then the
  # LO 32-bits as base-10. This format is only useful for human consumption.
  def MoranisKeys.to_s(key)
    first = key >> 32
    second =  (key & 0xFFFFFFFF)
    "#{first}:#{second}"
  end
end
