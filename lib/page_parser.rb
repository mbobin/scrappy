module Scrappy
  class PageParser
    def initialize page
      @page = page
    end

    def title
      summary.first
    end

    def authors
      extract_with_options author_selectors, group_size: 2, mappings: author_mappings
    end

    def subjects
      extract_with_options subject_selectors, group_size: 3, mappings: subject_mappings
    end

    def classify_url
      summary.last
    end

    protected

    def extract selectors
      @page.css(selectors).map(&:text)
    end

    def extract_with_options selectors, group_size:, mappings:
      extract(selectors)
        .each_slice(group_size)
        .inject([]) { |acc, s| acc << OpenStruct.new(mappings.zip(s).to_h) }
    end

    def summary
      @summary ||= extract('#itemsummary #display-Summary dl dd')
    end

    def author_selectors
      '#display-V #display-V-tbl #subheadtbl tbody tr td'
    end

    def subject_selectors
      '#display-SH #display-SH-tbl #subheadtbl tbody tr td'
    end

    def subject_mappings
      @subject_mappings ||= %i| name usage_count fast |
    end

    def author_mappings
      @author_mappings  ||= %i| name viaf |
    end
  end
end
