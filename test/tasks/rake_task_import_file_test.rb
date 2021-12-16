require "test_helper"
require "rake"

class RakeTaskImportFileTest < ActiveJob::TestCase

    describe 'transfers:import' do
        def setup
        #   @tt = Fabricate(:object_with_attributes_i_need_to_change)
          WbcSalesApi::Application.load_tasks if Rake::Task.tasks.empty?
          Rake::Task["transfers:import"].invoke
        end
    
        it "should import the existing JSON file and return the amount of accounts contained." do
          @tt.reload
          values = @tt.attribute_i_changed
          refute_includes values, "thing I don't want"
          assert_includes values, "thing I do want"
        end
    
      end

end

