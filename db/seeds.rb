# frozen_string_literal: true

Rails.root.join('db', 'seeds').glob('*.txt').map! do |file|
  file.readlines.map!(&:strip).reject! { |x| x.starts_with?('#') }.select(&:present?)
end.flatten!.each do |word|
  Word.create!(text: word)
end

AddCardsJob.perform_later
