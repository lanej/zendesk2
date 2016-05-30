# frozen_string_literal: true
module Zendesk2::HelpCenter::TranslationSource
  # allow models to define their source type
  module Model
    def source=(source)
      if source.is_a?(Zendesk2::HelpCenter::Article)
        self.source_type = 'Article'
      elsif source.is_a?(Zendesk2::HelpCenter::Section)
        self.source_type = 'Section'
      elsif source.is_a?(Zendesk2::HelpCenter::Category)
        self.source_type = 'Category'
      end
      self.source_id = source.id
    end
  end

  # allow requests to read common pieces of information about the translation source
  module Request
    def source_id
      Integer((params['translation'] || params).fetch('source_id'))
    end

    def source_type
      (params['translation'] || params).fetch('source_type')
    end

    def source_type_url
      case source_type
      when 'Article'
        'articles'
      when 'Section'
        'sections'
      when 'Category'
        'categories'
      end
    end

    def locale
      (params['translation'] || params).fetch('locale') || 'en-us'
    end

    # Since Zendesk2::Request#find! calls .to_i on hash keys, we need an integer
    # key for this.
    def mock_translation_key
      [source_type, source_id, locale].join('-').each_byte.reduce(0) { |a, e| a + e }
    end
  end
end
