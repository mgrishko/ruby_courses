require 'spec_helper'

describe Admin do
  let(:admin) { Fabricate(:admin) }

  it { should validate_presence_of(:email) }

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
end
