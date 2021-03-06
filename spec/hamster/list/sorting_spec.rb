require 'spec_helper'

require 'hamster/list'

describe Hamster::List do

  [
    [:sort, lambda { |left, right| left.length <=> right.length }],
    [:sort_by, lambda { |item| item.length }],
  ].each do |method, comparator|

    describe "##{method}" do

      it "is lazy" do
        lambda { Hamster.stream { fail }.send(method, &comparator) }.should_not raise_error
      end

      [
        [[], []],
        [["A"], ["A"]],
        [["Ichi", "Ni", "San"], ["Ni", "San", "Ichi"]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @original = Hamster.list(*values)
          end

          describe "with a block" do

            before do
              @result = @original.send(method, &comparator)
            end

            it "preserves the original" do
              @original.should == Hamster.list(*values)
            end

            it "returns #{expected.inspect}" do
              @result.should == Hamster.list(*expected)
            end

          end

          describe "without a block" do

            before do
              @result = @original.send(method)
            end

            it "preserves the original" do
              @original.should == Hamster.list(*values)
            end

            it "returns #{expected.sort.inspect}" do
              @result.should == Hamster.list(*expected.sort)
            end

          end

        end

      end

    end

  end

end
