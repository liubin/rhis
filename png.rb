require 'RMagick'
include Magick



LINE_HIGHT = 20
CHAR_WIDTH = 8

def make_png(strs)
    width = strs.sort{ |x,y| x.length <=> y.length}.last.length * CHAR_WIDTH + 20
    puts "#{width}"
    height = strs.length * LINE_HIGHT + 20
    puts "#{height}"

    file_name = "/tmp/#{Time.now.to_i}.jpg"
    image = Image.new(width, height)

    text = Draw.new
    strs.each_with_index { |v,i|

        text.annotate(image, 0, 0, 10, 10 + LINE_HIGHT * i , v) do
          text.gravity = NorthWestGravity
          self.pointsize = 16
          self.font_family = "Arial"
          self.font_weight = BoldWeight
          self.stroke = "none"
        end
    }

    image.write(file_name)
    file_name
end

#make_png ["3 files changed, 17 insertions(+), 6 deletions(-)","1 file changed, 5 insertions(+), 1 deletion(-)"]