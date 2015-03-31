require 'rails_helper'

RSpec.describe Item, type: :model do

  it('has valid factories') { expect(build :image).to be_valid }
  it('has valid factories') { expect(build :video).to be_valid }

  it('is invalid without title')     { expect(build :image, title: '').not_to be_valid }

  it('is invalid without link')      { expect(build :image, link: '').not_to be_valid }

  it('is invalid without user')      { expect(build :image, user: nil).not_to be_valid }

  it('is invalid without kind')      { expect(build :image, kind: '').not_to be_valid }
  it('is invalid with invalid type') { expect(build :image, kind: 'application').not_to be_valid }

  it('returns list of public items for public scope') do
    create(:video, public: false)
    public_items = [create(:image, public: true)]
    expect(Item.published).to eq public_items
  end

  it('returns list of user\'s items for owned_by scope') do
    create(:video, user: find_or_create(:alice))
    bobs_items = [create(:image, user: find_or_create(:bob))]
    expect(Item.owned_by(find_or_create(:bob))).to eq bobs_items
  end

  it('returns list of public items + own items for opened_for scope') do
    create(:video, user: find_or_create(:alice), public: false)
    public_items = [create(:video, user: find_or_create(:alice), public: true)]
    bobs_items =   [create(:image, user: find_or_create(:bob))]
    expect(Item.opened_for find_or_create(:bob)).to eq public_items + bobs_items
  end

  it('allows to view for public foreign item') do
    item = create(:video, user: find_or_create(:alice), public: true)
    expect(item.can_view? find_or_create(:bob)).to be
  end

  it('disallows to view for not public foreign item') do
    item = create(:video, user: find_or_create(:alice), public: false)
    expect(item.can_view? find_or_create(:bob)).not_to be
  end

  it('disallows to edit for public foreign item') do
    item = create(:video, user: find_or_create(:alice), public: true)
    expect(item.can_edit? find_or_create(:bob)).not_to be
  end

  it('disallows to edit for not public foreign item') do
    item = create(:video, user: find_or_create(:alice), public: false)
    expect(item.can_edit? find_or_create(:bob)).not_to be
  end

  it('allows to view for public own item') do
    item = create(:video, user: find_or_create(:bob), public: true)
    expect(item.can_view? find_or_create(:bob)).to be
  end

  it('allows to view for not public own item') do
    item = create(:video, user: find_or_create(:bob), public: false)
    expect(item.can_view? find_or_create(:bob)).to be
  end

  it('allows to edit for public own item') do
    item = create(:video, user: find_or_create(:bob), public: true)
    expect(item.can_edit? find_or_create(:bob)).to be
  end

  it('allows to edit for not public own item') do
    item = create(:video, user: find_or_create(:bob), public: false)
    expect(item.can_edit? find_or_create(:bob)).to be
  end
end
