# frozen_string_literal: true

require 'rails_helper'

describe Discount, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :percentage }
    it { is_expected.to validate_presence_of :item_quantity }
  end

  describe 'relationship' do
    it { is_expected.to belong_to :merchant }
  end
end
