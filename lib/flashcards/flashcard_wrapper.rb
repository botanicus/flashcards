module Flashcards
  class TestableUnitWrapper
    def initialize(app, flashcard)
      @app, @flashcard = app, flashcard
    end

    def should_run?(key = nil)
      self.new?(key) || self.time_to_review?(key)
    end

    def schedule
      @app.config.schedule
    end

    def time_to_review?(key = nil)
      key = self.variants.first if self.variants.length == 1

      if key
        return false if self.new?(key)

        number_of_days = self.schedule[@flashcard.correct_answers[key].length - 1] || (365 * 2)

        tolerance = (5 * 60 * 60) # 5 hours.
        @flashcard.correct_answers[key].last < (Time.now - ((number_of_days * 24 * 60 * 60) - tolerance))
      else
        self.enabled_variants.any? do |key|
          self.time_to_review?(key)
        end
      end
    end

    def variants
      [:default]
    end

    def enabled_variants
      @app.language.conjugation_groups.select do |tense| # TODO: This is just for verbs at the moment.
        @app.config.should_be_tested_on?(tense)
      end + [:default]
      # self.variants.select do |variant|
      #   variant == :default || Flashcards.app.language_config.test_me_on.include?(variant)
      # end
    end
  end

  class FlashcardWrapper < TestableUnitWrapper
    def variants
      if self.verb
        super + @app.language.conjugation_groups
      else
        super
      end
    end

    def should_run?(key = nil)
      if (key && @app.config.should_be_tested_on?(key)) || key.nil?
        super(key)
      end
    end

    def word_variants # TODO: nouns (plurals), cómodo/cómoda
      if @flashcard.tags.include?(:verb)
        @flashcard.expressions.map { |expression|
          @app.language.conjugation_groups.map do |conjugation_group|
            self.verb.send(conjugation_group).forms.values + [expression] # Don't forget the infinitive.
          end
        }.flatten.uniq
      else
        @flashcard.expressions
      end
    end

    def new?(key = nil)
      key = self.variants.first if self.variants.length == 1

      if key
        @flashcard.correct_answers[key].empty?
      else
        self.enabled_variants.any? do |key|
          self.new?(key)
        end
      end
    end

    def verb
      if @flashcard.tags.include?(:verb)
        @app.language._verb(@flashcard.expressions.first, @flashcard.conjugations || Hash.new)
      end
    end

    def verify
      if self.verb && (checksum = @flashcard.metadata[:checksum])
        return Digest::MD5.hexdigest(self.verb.forms.to_yaml) == checksum
      elsif self.verb && @flashcard.metadata[:checksum].nil?
        # nil
      else
        true
      end
    end
  end
end