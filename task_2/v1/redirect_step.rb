Given(/^Qlean page for first order for subscription periodicity experiment$/) do
  visit("https://onetwotrip.com")
  puts current_url
end

Then(/^I redirect to www.onetwotrip.com$/) do
  page.assert_current_path(%r{www\.?onetwotrip.com/?(.*)}, url: true)
end
