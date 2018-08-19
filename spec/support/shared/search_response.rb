shared_examples_for 'Search response' do
  it 'generates a link to #completion_link' do
    markup = Capybara.string(decorator.completion_link)
    expect(markup).to have_css("a[href='#{path}']", text: text)
  end

  it 'generates a link to #model' do
    markup = Capybara.string(decorator.model)
    expect(markup).to have_css("span", text: span)
  end
end