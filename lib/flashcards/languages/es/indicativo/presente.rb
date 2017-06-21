Flashcards.app.define_language(:es) do
  conjugation_group(:presente) do |infinitive|
    tense = Flashcards::Tense.new(:presente, infinitive) do
      case infinitive
      when /^(.+)ar$/
        [$1, {
           yo: 'o',   nosotros: 'amos',
vos: 'ás', tú: 'as',  vosotros: 'áis',
           él: 'a',   ellos: 'an'
        }]
      when /^(.+)er$/
        [$1, {
           yo: 'o',   nosotros: 'emos',
vos: 'és', tú: 'es',  vosotros: 'éis',
           él: 'e',   ellos: 'en'
        }]
      when /^(.+)ir$/
        [$1, {
           yo: 'o',   nosotros: 'imos',
vos: 'ís', tú: 'es',  vosotros: 'ís',
           él: 'e',   ellos: 'en'
        }]
      end
    end

    tense.exception(/guir$/, yo: Proc.new { |root| root.sub(/u$/, 'o') })
    tense.exception(/(gir|ger)$/, yo: Proc.new { |root| root.sub(/g$/, 'jo') })

    tense.alias_person(:usted, :él)
    tense.alias_person(:ustedes, :ellos)

    tense
  end
end