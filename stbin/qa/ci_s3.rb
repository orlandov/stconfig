################
require 'fileutils.rb'
require 'net/http'
sync=true

#LOGON TO wikitests  WORKSPACE
@user = 'devnull1@socialtext.com'
@wikitest_user = 'wikitester@ken.socialtext.net'
@pass = 'd3vnu11l'
@host = 'localhost'
#@host = 'www2.socialtext.net'
@port = (20000 + Process.euid).to_s 
#@port = '80'

#LOGON TO TEST ENV
@test_user = 'christopher.mcmahon@gmail.com'
@test_pass = 'd3vnu11l'
@test_host = 'www2.socialtext.net'
@test_port = '80'

@branch = 'trunk'

@workspace = 'wikitests'

#puts "STOPPING LDAP"
#stop_ldap = `~/src/st/current/nlw/dev-bin/st-ldap disable`
#puts stop_ldap

@page_locs = [
    "/data/workspaces/#{@workspace}/pages/calc_testcases/frontlinks",
    "/data/workspaces/#{@workspace}/pages/default_user_testcases/frontlinks",
    "/data/workspaces/#{@workspace}/pages/ldap_testcases/frontlinks",
    "/data/workspaces/#{@workspace}/pages/core_testcases/frontlinks",
    "/data/workspaces/#{@workspace}/pages/file_testcases/frontlinks",
    "/data/workspaces/#{@workspace}/pages/localization_testcases/frontlinks",
    "/data/workspaces/#{@workspace}/pages/report_testcases/frontlinks",
    "/data/workspaces/#{@workspace}/pages/miscellaneous_testcases/frontlinks",
    "/data/workspaces/#{@workspace}/pages/widgets_testcases/frontlinks",
    "/data/workspaces/#{@workspace}/pages/profile_testcases/frontlinks",
    ]

@status_loc = "/data/workspaces/qat/pages/continuous_integration_status"

@outfile = File.new("ci.log","w+")
@outfile.sync = true


while 1 do #INFINITE LOOP
   @number_passed = 0
   @number_failed = 0
   @total_step_count = 0
   @testcases = []

   ################################################

   #GET ALL OF THE TESTCASES USING REST

   def get_testcases

      def get_page(loc)
          puts loc
         http = Net::HTTP.new(@host, @port)
         http.start do |http|
            request =
            Net::HTTP::Get.new(loc,initheader = {'Accept' => 'text/x.socialtext-wiki'})
             request.basic_auth @user, @pass
            response = http.request(request)
            response.value
            @page = response.body
         end #do
            return @page
         end

      @theget = ""
      @page_locs.each do |page_loc|
         @theget = get_page(page_loc)

         #PARSE THE TEST CASE NAMES SO THEY ARE RUNNABLE
        @theget.each do |line|
            match = line.scan(/'>.+<\/a/)
            match = match.to_s
            match.gsub!("'>","")
            match.gsub!("</a", "")
            @testcases << match if match =~ /^Test/
         end #do line
      end #do page_loc
         end #get_testcases

         def put_test_results_to_wiki
            req = Net::HTTP::Put.new(@put_loc, initheader = {'Content-Type' =>'text/x.socialtext-wiki'})
            req.basic_auth @test_user, @test_pass
            req.body = ".pre\n" + @content + "\n.pre"
            response =
            Net::HTTP.new(@test_host, @test_port).start {|http|
            http.request(req) }
            puts "Response #{response.code}#{response.message}:#{response.body}"
         end

         def delete_page_after_test_passes
            req = Net::HTTP::Delete.new(@put_loc, initheader = {'Content-Type' => 'text/x.socialtext-wiki'})
            req.basic_auth @test_user, @test_pass
            response = Net::HTTP.new(@test_host, @test_port).start {|http| http.request(req) }
            puts "Response #{response.code}#{response.message}:#{response.body}"
         end

         def run_all_tests

            @queue_name = 'test-data'

            start_time = Time.now
            @outfile.puts "Starting  at #{start_time} on #{@env_port}"
            puts
            puts "Starting  at #{start_time} on #{@env_port}"
            puts

            def deploy_branch

                rmplugins = `rm -rf ~/src/st/socialtext-plugins/#{@branch}`
                puts rmplugins
                getplugins = `scm checkout https://repo.socialtext.net:8999/svn/plugins/#{@branch} ~/src/st/plugins/#{@branch}`
                puts getplugins

               rmreports = `rm -rf ~/src/st/socialtext-reports/#{@branch}`
               puts rmreports
               getreports = `scm checkout https://repo.socialtext.net:8999/svn/socialtext-reports/#{@branch} ~/src/st/socialtext-reports/#{@branch}`
               puts getreports

               rmcontrol = `rm -rf ~/src/st/control#{@branch}/`
               puts rmcontrol
               getcontrol = `scm checkout https://repo.socialtext.net:8999/svn/control/#{@branch} ~/src/st/control/#{@branch}`
               puts getcontrol

               rmappliance = `rm -rf ~/src/st/appliance/#{@branch}`
               puts rmappliance
               getappliance = `scm checkout https://repo.socialtext.net:8999/svn/appliance/#{@branch} ~/src/st/appliance/#{@branch}`
               puts getappliance

               remove = `rm -rf ~/src/st/#{@branch}`
               puts remove
               checkout = `scm checkout https://repo.socialtext.net:8999/svn/socialtext/#{@branch} ~/src/st/#{@branch}`
               puts checkout
               
               puts "CHECKING OUT #{@dev_user}"
               setbranch = `~/stbin/set-branch #{@branch}\n`
               puts setbranch
               
               freshdev = system("~/src/st/current/nlw/dev-bin/fresh-dev-env-from-scratch")
               puts freshdev

               puts "DOING CREATE-TEST-DATA-WORKSPACE"
               createtest = `~/src/st/current/nlw/dev-bin/create-test-data-workspace`
               puts createtest

               puts "SETTING BENCHMARK MODE"
               set_benchmark = `~/src/st/current/nlw/bin/st-config set benchmark_mode 1`
               puts set_benchmark

               puts "DOING ST-MAKE-JS"
               makejs = `~/src/st/current/nlw/dev-bin/st-make-js`
               puts makejs
               
               clearceq = system("~/src/st/current/nlw/bin/ceq-rm /.+/")
               puts clearceq
               
               import_wikitests = `~/src/st/current/nlw/dev-bin/wikitests-to-wiki`
               puts import_wikitests
                             
               import_reports_data = `~/src/st/current/nlw/dev-bin/st-populate-reports-db`
               puts import_reports_data
               
               import_reports_data2 = `~/src/st/current/nlw/dev-bin/st-populate-reports-db`
               puts import_reports_data2

               set_s3 = `~/src/st/current/nlw/bin/st-admin set-workspace-config --workspace test-data skin_name s3`
               puts set_s3

               #start_ldap = `~/scre/st/current/nlw/dev-bin/st-bootstrap-openldap --daemonize start`
               #puts start_ldap
            end

            puts "ABOUT TO DEPLOY"
            deploy_branch
            puts "GETTING TESTCASES"
            get_testcases
            puts @testcases
            
            iTime = Time.now().to_i
            @testout = "#{iTime}.testcases.out"
            FileUtils.ln_s(@testout,'testcases.out', :force => true)
            puts @testout 

            @testcases.each do |@testcase|

               def exec_rwt
                  @outfile.print  "running #{@testcase} at "
                  @outfile.puts Time.now.to_s
                  print  "running #{@testcase} at "
                  puts Time.now.to_s

                  @content = `export ST_SKIN_NAME=s3; ~/stbin/run-wiki-tests --no-maximize --timeout 60000 --test-username "#{@wikitest_user}" --test-email #{@wikitest_user}""  --plan-page "#{@testcase}" 2>>#{@testout} | tee -a #{@testout}`

                  step_count = @content.scan(/1\.\.\d+/)
                  puts step_count
                  step_count = step_count.to_s.gsub("1..","")
                  num_count = step_count.to_i

                  puts "ran #{step_count} test steps"
                  @outfile.puts("ran #{step_count} test steps")
                  @total_step_count = @total_step_count + num_count

               end



               def retry_test
                  puts "#{@testcase} failed, retrying"
                  exec_rwt
                  if (@content =~ /not ok/ or @content =~ /ERROR/)
                     @outfile.puts "#{@testcase} failed second time, writing results to wiki"
                     puts "#{@testcase} failed second time, writing results to wiki"
                     put_test_results_to_wiki
                     @number_failed = @number_failed + 1
                  else
                     delete_page_after_test_passes
                  end #if
               end


               def run_test
                  exec_rwt

                  if (@content =~ /not ok/ or @content =~ /ERROR/)
                     retry_test
                  else delete_page_after_test_passes
                     @number_passed = @number_passed + 1
                  end #if

               end #def

               testcase_page = @testcase.gsub(/\s+/, "_")
               @put_loc = "/data/workspaces/qat/pages/#{testcase_page} OUTPUT"

               run_test

            end #testcases do

               @end_time = Time.now
               puts "Finished at #{@end_time}"
               puts

               def put_count_to_wiki
                  passed = @number_passed.to_s
                  failed = @number_failed.to_s
                  count = @total_step_count.to_s
                  time = @end_time.to_s
                  devenv_port = 20000 + Process.euid
                  hostname = `hostname`

                  req = Net::HTTP::Put.new(@status_loc, initheader = {'Content-Type' =>'text/x.socialtext-wiki'})
                  req.basic_auth @test_user, @test_pass
                  req.body = "Tests passed: #{passed} \nTests_failed: #{failed}\nTotal number of test steps: #{count}\nTest run finished at #{time}\nBranch is #{@branch}\nDevenv port is #{devenv_port}\nHost is #{hostname}\nOutput in #{@testout}"
                  response =
                  Net::HTTP.new(@test_host, @test_port).start {|http|
                  http.request(req) }
                  puts "Response #{response.code}#{response.message}:#{response.body}"
               end

               put_count_to_wiki

               if (! File.exists?('old-testcases'))
                    FileUtils.mkdir 'old-testcases' 
               end
               FileUtils.move(@testout,'old-testcases')

            end #run_tests

            run_all_tests

         end #BIG LOOP
