require 'rails_helper'

RSpec.describe Item, type: :model do

  it('has valid factories') { expect(build :image).to be_valid }
  it('has valid factories') { expect(build :video).to be_valid }

  it('is invalid without title')     { expect(build :image, title: '').not_to be_valid }

  it('is invalid without link')      { expect(build :image, link: '').not_to be_valid }

  it('is invalid without user')      { expect(build :image, user: nil).not_to be_valid }

  it('is invalid without kind')      { expect(build :image, kind: '').not_to be_valid }
  it('is invalid with invalid type') { expect(build :image, kind: 'application').not_to be_valid }
end
