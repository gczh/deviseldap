require "cancan/matchers"
require 'spec_helper'

describe Ability do
	describe "destroying a post" do
		describe "guest user" do
			let(:ability) { Ability.new nil }
			it "cannot destroy a post" do
				ability.should_not be_able_to(:destroy, Post.new(user: nil))
				ability.should_not be_able_to(:destroy, Post.new)
			end
		end
	end
end
