#import "@preview/fontawesome:0.1.0": *

// const color
#let color-darknight = rgb("#131A28")
#let color-darkgray = rgb("#333333")
#let color-middledarkgray = rgb("#414141")
#let color-gray = rgb("#5d5d5d")
#let color-lightgray = rgb("#999999")

// Default style
#let color-accent-default = rgb("#dc3522")
#let font-header-default = ("Roboto", "Arial", "Helvetica", "Dejavu Sans")
#let font-text-default = ("Source Sans Pro", "Arial", "Helvetica", "Dejavu Sans")

// User defined style
#let color-accent = color-accent-default
#let font-header = font-header-default
#let font-text = font-text-default

/// Helpers

// icon string parser

#let parse_icon_string(icon_string) = {
  if icon_string.starts-with("fa ") [
    #let parts = icon_string.split(" ")
    #if parts.len() == 2 {
      fa-icon(parts.at(1), fill: color-darknight)
    } else if parts.len() == 3 and parts.at(1) == "brands" {
      fa-icon(parts.at(2), fa-set: "Brands", fill: color-darknight)
    } else {
      assert(false, "Invalid fontawesome icon string")
    }
  ] else if icon_string.ends-with(".svg") [
    #box(image(icon_string))
  ] else {
    assert(false, "Invalid icon string")
  }
}

// contaxt text parser
#let unescape_text(text) = {
  // This is not a perfect solution
  text.replace("\\", "").replace(".~", ". ")
}

// layout utility
#let __justify_align(left_body, right_body) = {
  block[
    #box(width: 4fr)[#left_body]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let __justify_align_3(left_body, mid_body, right_body) = {
  block[
    #box(width: 1fr)[
      #align(left)[
        #left_body
      ]
    ]
    #box(width: 1fr)[
      #align(center)[
        #mid_body
      ]
    ]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

/// Right section for the justified headers
/// - body (content): The body of the right header
#let secondary-right-header(body) = {
  set text(
    size: 10pt,
    weight: "thin",
    style: "italic",
    fill: color-accent,
  )
  body
}

/// Right section of a tertiaty headers. 
/// - body (content): The body of the right header
#let tertiary-right-header(body) = {
  set text(
    weight: "light",
    size: 9pt,
    style: "italic",
    fill: color-gray,
  )
  body
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let justified-header(primary, secondary) = {
  set block(
    above: 0.7em,
    below: 0.7em,
  )
  pad[
    #__justify_align[
      #set text(
        size: 12pt,
        weight: "bold",
        fill: color-darkgray,
      )
      #primary
    ][
      #secondary-right-header[#secondary]
    ]
  ]
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right. This is a smaller header compared to the `justified-header`.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let secondary-justified-header(primary, secondary) = {
  __justify_align[
     #set text(
      size: 10pt,
      weight: "regular",
      fill: color-gray,
    )
    #primary
  ][
    #tertiary-right-header[#secondary]
  ]
}
/// --- End of Helpers


#let resume(
  title: "CV",
  author: (:),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  body,
) = {
  
  set document(
    author: author.firstname + " " + author.lastname,
    title: title,
  )
  
  set text(
    font: (font-text),
    size: 11pt,
    fill: color-darkgray,
    fallback: true,
  )
  
  set page(
    paper: "a4",
    margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
    footer: [
      #set text(
        fill: gray,
        size: 8pt,
      )
      #__justify_align_3[
        #smallcaps[#date]
      ][
        #smallcaps[
          #author.firstname
          #author.lastname
          #sym.dot.c
          CV
        ]
      ][
        #counter(page).display()
      ]
    ],
  )
  
  // set paragraph spacing

  
  set heading(
    numbering: none,
    outlined: false,
  )
  
  show heading.where(level: 1): it => [
    #set block(
      above: 1.5em,
      below: 1em,
    )
    #set text(
      size: 16pt,
      weight: "regular",
    )
    
    #align(left)[
      #text[#strong[#text(color-accent)[#it.body.text.slice(0, 3)]#text(color-darkgray)[#it.body.text.slice(3)]]]
      #box(width: 1fr, line(length: 100%))
    ]
  ]
  
  show heading.where(level: 2): it => {
    set text(
      color-middledarkgray,
      size: 12pt,
      weight: "thin"
    )
    it.body
  }
  
  show heading.where(level: 3): it => {
    set text(
      size: 10pt,
      weight: "regular",
      fill: color-gray,
    )
    smallcaps[#it.body]
  }
  
  let name = {
    align(center)[
      #pad(bottom: 5pt)[
        #block[
          #set text(
            size: 32pt,
            style: "normal",
            font: (font-header),
          )
          #text(fill: color-gray, weight: "thin")[#author.firstname]
          #text(weight: "bold")[#author.lastname]
        ]
      ]
    ]
  }
  
  let position = {
    set block(
      above: 0.75em,
      below: 0.75em,
    )
  
    set text(
      color-accent,
      size: 9pt,
      weight: "regular",
    )
    align(center)[
      #smallcaps[
        #author.position
      ]
    ]
  }
  
  let address = {
    set block(
      above: 0.75em,
      below: 0.75em,
    )
    set text(
      color-lightgray,
      size: 9pt,
      style: "italic",
    )
    align(center)[
      #author.address
    ]
  }
  
  let contacts = {
    set box(height: 9pt)
    
    let separator = box(width: 5pt, line(start: (0%, 0%), end: (0%, 100%), stroke: color-darkgray))
    let contact_last = author.contacts.pop()
    
    align(center)[
      #set text(
        size: 9pt,
        weight: "regular",
        style: "normal",
      )
      #block[
        #align(horizon)[
          #for contact in author.contacts [
            #box[#parse_icon_string(contact.icon)]
            #box[#link(contact.url)[#contact.text]]
            #separator
          ]
          #box[#parse_icon_string(contact_last.icon)]
          #box[#link(contact_last.url)[#contact_last.text]]
        ]
      ]
    ]
  }
  
  name
  position
  address
  contacts
  body
}

/// The base item for resume entries. 
/// This formats the item for the resume entries. Typically your body would be a bullet list of items. Could be your responsibilities at a company or your academic achievements in an educational background section.
/// - body (content): The body of the resume entry
#let resume-item(body) = {
  set text(
    size: 10pt,
    style: "normal",
    weight: "light",
    fill: color-darknight,
  )
  set par(leading: 0.65em)
  set list(indent: 1em)
  body
}

/// The base item for resume entries. This formats the item for the resume entries. Typically your body would be a bullet list of items. Could be your responsibilities at a company or your academic achievements in an educational background section.
/// - title (string): The title of the resume entry
/// - location (string): The location of the resume entry
/// - date (string): The date of the resume entry, this can be a range (e.g. "Jan 2020 - Dec 2020")
/// - description (content): The body of the resume entry
#let resume-entry(
  title: none,
  location: "",
  date: "",
  description: ""
) = {
  pad[
    #justified-header(title, location)
    #secondary-justified-header(description, date)
  ]
}

/// ---- End of Resume Template ----
// Typst custom formats typically consist of a 'typst-template.typ' (which is
// the source code for a typst template) and a 'typst-show.typ' which calls the
// template's function (forwarding Pandoc metadata values as required)
//
// This is an example 'typst-show.typ' file (based on the default template  
// that ships with Quarto). It calls the typst function named 'article' which 
// is defined in the 'typst-template.typ' file. 
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-template.typ' entirely. You can find
// documentation on creating typst templates here and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#show: resume.with(
  title: [Albert Einstein’s CV],
  author: (
    firstname: unescape_text("Albert"),
    lastname: unescape_text("Einstein"),
    address: unescape_text("Rämistrasse 101, CH-8092 Zürich, Switzerland, Zürich"),
    position: unescape_text("Research Physicist・Professor"),
    contacts: ((
      text: unescape_text("ae\@example.com"),
      url: unescape_text("mailto:ae\@example.com"),
      icon: unescape_text("fa envelope"),
    ), (
      text: unescape_text("example.com"),
      url: unescape_text("https:\/\/example.com"),
      icon: unescape_text("assets/icon/bi-house-fill.svg"),
    ), (
      text: unescape_text("0000-0000-0000-0000"),
      url: unescape_text("https:\/\/orcid.org/0000-0000-0000-0000"),
      icon: unescape_text("fa brands orcid"),
    ), (
      text: unescape_text("GitHub"),
      url: unescape_text("https:\/\/github.com/example"),
      icon: unescape_text("fa brands github"),
    ), (
      text: unescape_text("LinkedIn"),
      url: unescape_text("https:\/\/linkedin.com/in/example"),
      icon: unescape_text("fa brands linkedin"),
    ), (
      text: unescape_text("twitter"),
      url: unescape_text("https:\/\/twitter.com/example"),
      icon: unescape_text("fa brands x-twitter"),
    )),
  ),
)
= Education
<education>
#resume-entry(title: "Ph.D. in Physics",location: "Zürich, Switzerland",date: "1905",description: "University of Zürich",)
#resume-entry(title: "Master of Science",location: "Zürich, Switzerland",date: "1896 - 1900",description: "ETH",)
= Publications
<publications>
#resume-entry(title: "On the Electrodynamics of Moving Bodies",location: "Annalen der Physik",date: "September 1905",)
#resume-entry(title: "On the motion of small particles suspended in liquids at rest required by the molecular-kinetic theory of heat",location: "Annalen der Physik",date: "July 1905",)
= Work Experience
<work-experience>
#resume-entry(title: "Associate Professor",location: "Zürich, Switzerland",date: "1909 - 1911",description: "University of Zürich",)
#resume-entry(title: "Junior Professor",location: "Bern, Switzerland",date: "1908 - 1909",description: "University of Bern",)
#resume-entry(title: "Technical Assistant",location: "Bern, Switzerland",date: "1902 - 1908",description: "Federal Patent Office",)
= Awards
<awards>
#resume-entry(title: "Nobel Prize in Physics",location: "Stockholm, Sweden",date: "1921",description: "For his services to",)
#resume-item[
- Theoretical Physics
- Discovery of the law of the photoelectric effect
]
= Skills
<skills>
#resume-entry(title: "Programming",description: "Python, C++, Fortran",)
#resume-entry(title: "Languages",description: "German (Native), English (Fluent), French (Intermediate)",)
#resume-entry(title: "Tools",description: "Typst, Quarto, LaTeX",)