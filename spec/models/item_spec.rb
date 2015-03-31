require 'rails_helper'

RSpec.describe Item, type: :model do

  it('has valid factories') { expect(build :image).to be_valid }
  it('has valid factories') { expect(build :video).to be_valid }

end
