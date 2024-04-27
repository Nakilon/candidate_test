# frozen_string_literal: true

When(/^захожу на страницу "(.+?)"$/) do |url|
  visit url
  $logger.info("Страница #{url} открыта")
end

When(/^перехожу по ссылке "([^"]+)"$/) do |text|
  find_all(:xpath, "//a[text()='#{text}']").first.click
end

When(/^скачиваю последний стабильный релиз$/) do
  a = find(:xpath, "(//*[*[.='Стабильные релизы:']]//a)[1]")
  @link_text = a.text
  a.click
end

When(/^должен скачаться файл с соответствующим названием$/) do
  filenames = nil
  begin
    Timeout.timeout(5) do
      filenames = Dir.glob("features/tmp/*").grep_v(/\.crdownload\z/)
      unless 1 == filenames.size
        sleep 0.1
        redo
      end
    end
  rescue Timeout::Error
    raise "должен был скачаться ровно один файл, не #{filenames.size}"
  end
  expect(@link_text.downcase.tr " ", "-").to eq(File.basename(filenames[0], ".tar.gz"))
end
