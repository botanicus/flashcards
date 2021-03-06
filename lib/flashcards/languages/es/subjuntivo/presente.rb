# frozen_string_literal: true

require_relative '../indicativo/presente'

Flashcards::Language.define(:es) do
  conjugation_group(:subjuntivo) do |verb, infinitive|
    tense = Flashcards::Tense.new(self, :subjuntivo, infinitive) do
      stem = if verb.infinitive != infinitive # Irregular infinitive.
        self.infinitive[0..-3]
      else
        verb.presente.yo.sub(/^(.+)oy?$/, '\1')
             end

      case self.infinitive
      when /^(.+)ar(se)?$/
        [stem, {
           yo: 'e',   nosotros: 'emos',
           vos: 'és', tú: 'es', vosotros: 'éis',
           él: 'e',   ellos: 'en'
        }]
      when /^(.*)[ei]r(se)?$/ # ir, irse
        [stem, {
           yo: 'a',   nosotros: 'amos',
           vos: 'ás', tú: 'as', vosotros: 'áis',
           él: 'a',   ellos: 'an'
        }]
      end
    end

    tense.alias_person(:vos, :tú)
    tense.alias_person(:ella, :él)
    tense.alias_person(:usted, :él)
    tense.alias_person(:nosotras, :nosotros)
    tense.alias_person(:vosotras, :vosotros)
    tense.alias_person(:ellas, :ellos)
    tense.alias_person(:ustedes, :ellos)

    tense.define_singleton_method(:pretty_inspect) do
      super(
        [:yo, :tú, :él],
        [:nosotros, :vosotros, :ellos])
    end

    tense
  end
end
