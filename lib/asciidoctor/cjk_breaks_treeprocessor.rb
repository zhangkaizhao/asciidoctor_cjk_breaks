require 'asciidoctor/extensions'
require 'east_asian_width'

class CjkBreaksTreeprocessor < Asciidoctor::Extensions::Treeprocessor
  def process(document)
    process_interal document
    nil
  end

  def process_interal(block)
    case block.context
    when :paragraph
      remove_cjk_breaks block
    when :dlist
      block
    when :table
      block
    else
      block.blocks.map! do |b|
        process_interal b
      end
      block
    end
  end

  def remove_cjk_breaks(block)
    content_changed = false
    # Processing after raw_source -> block.lines -> block.content in asciidoctor.
    # It may be better to make this process while the process from raw_source -> block.lines
    # whose code flow is:
    # -> `Asciidoctor::Block.initialize`
    # -> `Asciidoctor::Helpers.normalize_lines_from_string`.
    lines = block.content.lines
    lines.each_with_index do |line, line_index|
      last_char_idx = line.rindex(/[^\r|\n]/)
      last_char = line[last_char_idx]
      next_line = lines[line_index + 1]
      next_char = next_line[0] if next_line

      next unless last_char && next_char

      remove_break = false

      if last_char == "\u200b" || next_char == "\u200b"
        # remove newline if it's adjacent to ZWSP
        remove_break = true
      elsif EastAsianWidth.east_asian_width(last_char).match?(/^[FWH]$/) &&
            EastAsianWidth.east_asian_width(next_char).match?(/^[FWH]$/)
        # remove newline if both characters are fullwidth (F), wide (W) or
        # halfwidth (H), but not Hangul
        remove_break = true if !hangul?(last_char) && !hangul?(next_char)
      end

      if remove_break
        lines[line_index] = line.chomp
        content_changed = true
      end
    end

    if content_changed
      create_paragraph block.document, lines.join(''), block.attributes
    else
      block
    end
  end


  REGEXP_HANGUL_CHARS = /
    [
    \u1100-\u11FF
    \u302E
    \u302F
    \u3131-\u318E
    \u3200-\u321E
    \u3260-\u327E
    \uA960-\uA97C
    \uAC00-\uD7A3
    \uD7B0-\uD7C6
    \uD7CB-\uD7FB
    \uFFA0-\uFFBE
    \uFFC2-\uFFC7
    \uFFCA-\uFFCF
    \uFFD2-\uFFD7
    \uFFDA-\uFFDC
    ]
  /x

  def hangul?(char)
    # require('unicode-10.0.0/Script/Hangul/regex')
    char.match?(REGEXP_HANGUL_CHARS)
  end
end

Asciidoctor::Extensions.register do
  treeprocessor CjkBreaksTreeprocessor
end
