# Performs natural order sorting of an array. Natural order is the way in
# which a human might sort a list of files that are incremented by
# one.  They will sort normally as long as they have leading zeros,
# however this doesn't look good and is hard to read.  What natural sorting
# does is allow the following to be sorted properly (as shown):
#
# file1
# file2
# file4
# file22
# file30
# file100
#
# Code used is from http://zijab.blogspot.com/2007/05/natural-order-string-comparison-for.html
#

module AastraXmlApi
  module ArrayExtension
    # Method which sort an array composed of strings with embedded numbers by
    # the 'natural' representation of numbers inside a string.
    def natsort
      reg_number = /\d+/
        # We call the sort method of the Array class.
        self.sort do |str1, str2|

        # We try to find an embedded number
        a = str1.match(reg_number)
        b = str2.match(reg_number)

        # If there is no number
        if [a,b].include? nil
          str1 <=> str2
        else
          while true
            begin
              # We compare strings before the number. If there
              # are equal, we will have to compare the numbers
              if (comp = a.pre_match <=> b.pre_match) == 0
                # If the numbers are equal
                comp = (a[0] == b[0]) ? comp = a[0] + a.post_match <=> b[0] + b.post_match :
                  comp = a[0].to_i <=> b[0].to_i
              end

              str1, str2 = a.post_match, b.post_match
              a = str1.match(reg_number)
              b = str2.match(reg_number)
            rescue
              break
            end
          end
          comp
        end
        end
    end

    # Same as 'natsort' but replace in place.
    def natsort!
      self.replace(natsort)
    end
  end
end
