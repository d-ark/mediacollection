FactoryGirl.define do
  factory :image, class: Item do
    title "At Berlin 2014 (258)"
    description "The photo of main street of Berlin"
    link "http://www.lindemanns-hotel.de/flashgallery/71599f3d-f89a-4b22-9c80-d3c3223a834d/d573960c-9606-4aec-b149-be273d975da7.jpg"
    kind "image"
    public true
    user_id { find_or_create(:alice).id }
  end

  factory :video, class: Item do
    title "Atlanic ocean 2014 (258)"
    description "The video from Atlanic ocean"
    link "https://youtu.be/retX8Wj7JdM"
    kind "video"
    public false
    user_id { find_or_create(:alice).id }
  end

end
