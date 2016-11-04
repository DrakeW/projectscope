Then /debug/ do
  1 if debugger
  1
end

When /^I enter new "(.*)" config values/ do |metric, table|
  fieldset_id = metric.downcase.gsub(' ', '_') # "Code Climate" => "code_climate"
  (table.hashes.length - 1).times do
    within "##{fieldset_id}" do
      click_link 'Add new'
    end
  end
  idx = 0
  all_inputs = page.all("fieldset##{fieldset_id} .newf")
  table.hashes.each do |h|
    all_inputs[idx].set h['key']
    all_inputs[idx+1].set h['value']
    idx += 2
  end
end

Then /^there should be a project "(.*)" with config values/ do |name, table|
  proj = Project.includes(:configs).find_by_name!(name)
  table.hashes.each do |h|
    expect(proj.config_for(h['metric_name']).options[h['key']]).to eq(h['value'])
  end
end

Given(/^the following projects exist:$/) do |table|
  table.hashes.each do |hash|
    Project.create hash
  end
  @projects = Project.all
end

Given(/^they have the following metric configs:$/) do |table|
  table.hashes.each do |hash|
    project = Project.find_by(name: hash.delete('project'))
    existing_config = project.config_for(hash['metric_name'])
    new_options = existing_config.options
    new_options[hash['key'].to_sym] = hash['value']
    existing_config.options = new_options
    existing_config.save!
  end
end

Given(/^they have the following metric samples:$/) do |table|
  table.hashes.each do |hash|
    project = Project.find_by(name: hash.delete('project'))
    project.metric_samples << MetricSample.create(hash)
  end
end

Given(/^A project update job has been run$/) do
  $rake['project:resample_all'].execute
end

And(/^I am logged in$/) do
  steps %Q{
    Given I am on the login page
    And I have a valid github account with email "test-coach@test.com" username "test-coach"
    And I follow "Sign in with GitHub"
  }
  sleep(1)
end

Then(/^the config value "([^"]*)" should not appear in the page$/) do |value|
  expect(page.body).not_to match value
end

Given(/^the date is "([^"]*)"$/) do |date|
  date =~ /(\d{2})\/(\d{2})\/(\d{4})/
  month = Integer($1,10)
  day = Integer($2,10)
  year = Integer($3,10)
  new_time = Time.utc(year, month,day, 12, 0, 0)
  Timecop.travel(new_time)
end

When /^I drag (.*) (\d) row (up|down)$/ do |project, number, order|
  id = page.find('tr', text: project)[:id]
  sign = if order == 'down' then '' else '-' end
  code = %Q{
    $("#{id}").simulateDragSortable({move: #{sign}#{number}});
  }
  page.execute_script(code)
end

Then(/^I should see (.*) (above|below) (.*)$/) do |thing0, order, thing1|
  pj_names = page.all('table#projects_table')
  puts pj_names
  # t = page.find('table', id: 'projects_table')
  # puts t.text
  # t.table.each do |elm|
  #   puts elm
  # end
  # if order == "above"
  #   page.text.should match("#{thing0}.*#{thing1}")
  # else
  #   page.text.should match("#{thing1}.*#{thing0}")
  # end
end
