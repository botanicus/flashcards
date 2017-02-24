Flashcards.app.define_language(:es) do
  conjugation_group(:present) do |infinitive|
    tense = Flashcards::Tense.new(:present, infinitive) do
      case infinitive
      when /^(.+)ar$/
        [$1, {
          yo: 'o',   nosotros: 'amos',
          tú: 'as',  vosotros: 'áis',
          él: 'a',   ellos: 'an'
        }]
      when /^(.+)er$/
        [$1, {
          yo: 'o',   nosotros: 'emos',
          tú: 'es',  vosotros: 'éis',
          él: 'e',   ellos: 'en'
        }]
      when /^(.+)ir$/
        [$1, {
          yo: 'o',   nosotros: 'imos',
          tú: 'es',  vosotros: 'ís',
          él: 'e',   ellos: 'en'
        }]
      end
    end

    # TODO: Rename to #exception to #irregular or somethin'.
    tense.exception('dar', yo: 'doy', vosotros: 'dais')

    tense.instance_eval do
      alias_method :usted, :él
      alias_method :ustedes, :ellos
    end

    tense
  end

  conjugation_group(:past) do |infinitive|
    @past ||= begin
      tense = Flashcards::Tense.new(:past, infinitive) do
        case infinitive
        when /^(.+)ar$/
          [$1, {
            yo: 'é',    nosotros: 'amos',
            tú: 'aste', vosotros: 'asteis',
            él: 'ó',    ellos: 'aron'
          }]
        when /^(.+)[ei]r$/
          [$1, {
            yo: 'í',    nosotros: 'imos',
            tú: 'iste', vosotros: 'isteis',
            él: 'ió',   ellos:    'ieron'
          }]
        end
      end

      tense.exception(/car$/, yo: Proc.new { |root| "#{root[0..-2]}qué" })
      tense.exception(/gar$/, yo: Proc.new { |root| "#{root[0..-2]}gué" })
      tense.exception(/zar$/, yo: Proc.new { |root| "#{root[0..-2]}cé"  })

      # Ver loses accent in the first and third person of singular .
      tense.exception('ver', yo: 'vi', él: 'vio')

      # Dar loses accent in the first and third person of singular and is conjugated such as -er/-ir verbs.
      tense.exception('dar', {
        yo: 'di',    nosotros: 'dimos',
        tú: 'diste', vosotros: 'disteis',
        él: 'dio',   ellos:    'dieron'
      })

      tense
    end
  end
end