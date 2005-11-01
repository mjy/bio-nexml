#!/usr/bin/env ruby
#
# color_scheme_na.rb - A Bio::ColorScheme demo script for Nucleic Acids 
#                      sequences.
#
#  Usage:
#
#   % ruby color_scheme_na.rb > cs-seq-fna.html
#
#   % cat seq.fna
#   >DNA_sequence
#   acgtgtgtcatgctagtcgatcgtactagtcgtagctagtca
#   % ruby color_scheme_na.rb seq.fna > colored-seq-fna.html
#
#
# Copyright (C) 2005 Mitsuteru C. Nakao <n@bioruby.org>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  $Id: color_scheme_na.rb,v 1.1 2005/10/31 07:39:13 nakao Exp $
#

require 'bio'


# returns folded sequence with <br>.
def br(i, width = 80)
  return "<br\n>"  if i % width == 0
  ""
end


# returns sequence html doc
def display(seq, cs)
  html = '<p style="font-family: monospace">'
  postfix = '</span>'
  i = 0
  seq.each_byte do |c|
    color = cs[c.chr]
    prefix = %Q(<span style="background:\##{color};">)
    html += prefix + c.chr + postfix
    html += br(i += 1)
  end
  html + '</p>'
end


# returns scheme wise html doc
def display_scheme(scheme, naseq, aaseq)
  html = ''
  cs = eval("Bio::ColorScheme::#{scheme}")
  [naseq, aaseq].each do |seq|
    html += display(seq, cs)
  end
  return  ['<div>', "<h3>#{cs}</h3>", html, '</div>']
end



if fna = ARGV.shift
  naseq = Bio::FastaFormat.new(File.open(fna, 'r').read).naseq
  aaseq = naseq.translate
else
  naseq = Bio::Sequence::NA.new('acgtu' * 20).randomize
  aaseq = naseq.translate
end

title =  'Bio::ColorScheme for DNA sequences'
doc = ['<html>',
       '<header>', '<title>', title, '</title>', '</header>',
       '<body>',  '<h1>', title, '</h1>']

doc << ['<div>', '<h2>', 'Simple colors', '</h2>']
['Nucleotide'].each do |scheme|
  doc << display_scheme(scheme, naseq, "")
end
doc << ['</div>']

['Zappo', 'Taylor' ].each do |scheme|
  doc << display_scheme(scheme, "", aaseq)
end
doc << ['</div>']


doc << ['<div>', '<h2>', 'Score colors', '</h2>']
['Buried', 'Helix', 'Hydropathy', 'Strand', 'Turn'].each do |score|
  doc << display_scheme(score, "", aaseq)
end
doc << ['</div>']

puts doc + ['</body>','</html>']