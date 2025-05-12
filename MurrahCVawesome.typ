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
  title: [William (Hank) Murrah],
  author: (
    firstname: unescape_text("William (Hank)"),
    lastname: unescape_text("Murrah"),
    address: unescape_text("Rämistrasse 101, CH-8092 Zürich, Switzerland, Zürich"),
    position: unescape_text("Research Physicist・Professor"),
    contacts: ((
      text: unescape_text("wmm0017\@auburn.edu"),
      url: unescape_text("mailto:wmm0017\@auburn.edu"),
      icon: unescape_text("fa envelope"),
    )),
  ),
)
= Education
<education>
== Ph.D.~Educational Psychology, University of Virginia, 2010.
<ph.d.-educational-psychology-university-of-virginia-2010.>
== M.Ed. Community and Agency Counseling, University of Montevallo, 1998.
<m.ed.-community-and-agency-counseling-university-of-montevallo-1998.>
== B.S. Psychology, University of Montevallo, 1993.
<b.s.-psychology-university-of-montevallo-1993.>
= Current Position
<current-position>
#strong[Department Head];, #emph[Department of Educational Foundations, Leadership, and Technology];, College of Education, #strong[Auburn University];, 2023-present.

#strong[Associate Professor];, #emph[Educational Research, Measurement, and Assessment Program, Educational Foundations, Leadership, & Technology];, #strong[Auburn University] , 2021-present.

#strong[Assistant Professor];, #emph[Educational Research, Measurement, and Assessment Program, Educational Foundations, Leadership, & Technology];, #strong[Auburn University] , 2016-2021.

#strong[Research Scientist];, #emph[University of Virginia];, Charlottesville, VA, 2013-2016.

#strong[Postdoctoral Fellow];, #emph[University of Virgina];, Charlottesville, VA, 2010-2013.

= Research
<research>
== Publications
<publications>
\* indicates collaboration with students.

Agostinelli P.J., Bordonie, N.C., Robbins. A.M., Jones. P.L., Reagan. L.F., Mobley. C.B., Miller. M.W., #strong[Murrah, W.M.];, Sefton, J.M. (2025) Impact of acute exercise on performance and physiological stress during simulated firefighter occupational tasks. #emph[Scientific Reports] v14(1):29778. doi:10.1038/s41598-024-81015-8. PMID: 39616210; PMCID: PMC11608254.

Bacelar, M.F.B, Parma, J. O., #strong[Murrah, W.M.];, & Miller, M.W. (2024). Meta-analyzing enhanced expectancies on motor learning: Positive effects but methodological concerns. #emph[International Review of Sport and Exercise Psychology];, 17(1), 587-616. https:\/\/www.tandfonline.com/action/showCitFormats?doi=10.1080/1750984X.2022.2042839

\* Agostinelli, P., Bordonie, N., Linder, B., Robbins, A., Jones, P., Reagan, L., Mobley, C. B., MIller, M., #strong[Murrah, W. M.];, & Sefton, J. E. (2024). The impact of training status on firefighter task performance after acute exercise. Physiology, 39(S1). https:\/\/doi.org/10.1152/physiol.2024.39.s1.870

\* Bordonie, N., Agostinelli, P., Linder, B., Robbins, A., Jones, P., Reagan, L., Mobley, C. B., Miller, #strong[M., Murrah, W. M.];, & Sefton, J. (2024). Impact of anaerobic fitness on performance and physiology during simulated firefighting tasks. Physiology, 39(S1). https:\/\/doi.org/10.1152/physiol.2024.39.s1.2060

\* Monaghan, P. G., #strong[Murrah, W. M.];, Walker, H. C., Neely, K. A., & Roper, J. A. (2024). Evaluating postural transition movement performance in individuals with essential tremor via the instrumented timed up and go. #emph[Sensors];, 24(7), 2216. https:\/\/doi.org/10.3390/s24072216.

Giordano, K. A., Barrack, A. J., #strong[Murrah, W. M.];, Karduna, A. R., Michener, L. A., & Wasserberger, K. W. (2024). Usage and acceptability of data normalization in baseball pitching. #emph[Sports Biomechanics];, 1--12. https:\/\/doi.org/10.1080/14763141.2024.2302830

Grissmer, D., Buddin, R., Berends, M., White, T.G., Willingham, D.T., Decoster, J., Duran, Chelsea, A.K., Hulleman, C.S., #strong[Murrah, W. M.];, Evans, T. (2024). How Building Knowledge Boosts Literacy and Learning First causal study finds outsized impacts at "Core Knowledge" schools. #emph[Education Next];, 24(2), 52-56.

\* Rightmire, Z. B., Agostinelli, P. J., #strong[Murrah, W. M.];, Roper, J. A., Roberts, M. D., & Sefton, J. M. (2024). Acute high-intensity interval training improves esport performance in super smash brothers ultimate competitors. #emph[Journal of Electronic Gaming and Esports];, 2(1). https:\/\/doi.org/10.1123/jege.2023-0031.

\* Agostinelli, P. J., Bordonie, N. C., Robbins, A. M., Jones, P. L., Reagan, L. F., Mobley, C. B., Miller, M. W., #strong[Murrah, W. M.];, & Sefton, J. M. (2024). The effect of two acute exercise modalities on physiology and condition during firefighter occupational tasks. #emph[International Journal of Exercise Science: Conference Proceedings];, 16. https:\/\/digitalcommons.wku.edu/ijesab/vol16/iss3/1

\* Zou, C., Zhao, Y., Garza, K. B., Hollingsworth, J. C., #strong[Murrah, W. M.];, Westrick, S., & Fox, B. I. (2023). Text message interventions for physical activity among university students: a systematic review and meta-analysis. #emph[American Journal of Pharmaceutical Education];, 87(8), 100538. https:\/\/doi.org/10.1016/j.ajpe.2023.100538

\* Brinkerhoff, S. A., #strong[Murrah, W. M.];, & Roper, J. A. (2023). The relationship between gait speed and mediolateral stability depends on a person's preferred speed. #emph[Scientific Reports];, 13(1). https:\/\/doi.org/10.1038/s41598-023-32948-z

\*Lyons, K.D., Parks, A.G., Dadematthews, O.D., Zandieh, N.L., McHenry P.A., Games K.E., Goodlett M.D., #strong[Murrah W.M.];, Roper J.A., Sefton, J.M. (2023). Core and Whole-Body Vibration Exercise Improve Military Foot March Performance in Novice Trainees: A Randomized Controlled Trial. #emph[Military Medicine] 188 (1-2), e254-e259.

\*Brinkerhoff, S.A., Mathew, G.M., #strong[Murrah, W.M.];, Chang, A.M., Roper, J.A., Neely, K.A. (2022). Sleep restriction impairs visually and memory-guided force control. #emph[PlOS One];, 17 (9), e0274121. https:\/\/doi.org/10.1371/journal.pone.0274121

\*Larsen, J., Roper, J., #strong[Murrah, W.M.];, & Zabala, M. (2022). Cognitive dual-task alters Local Dynamic Stability of lower extremity during common movements. #emph[Journal of Bioimechanics];, 137, 111077.

\*Parks, A.G., #strong[Murrah, W.M.];, Weimer, W.H., McHenry, P.A., Biogham, D., Giordano, K., & Sefton, J.M. (2022). Impact of two types of fitness programs on soldier physical fitness. #emph[International Journal of Exercise Science];, 15(4) 1326-1346.

\*Lyons, K.D., Parks, A.G., Dadematthews, O., Zandieh, N., McHenry, P., Games, K.e., Goodlett, M.D., #strong[Murrah, W.M.];, Roper, J., & Sefton, J.M. (2021). Core and whole body vibration exercise influences muscle sensitivity and posture during a military foot march. #emph[International Journal of Environmental Research and Public Health];, 18, 4966.

Frugé, A.D., Smith, K.S., Riviere, A.J., Tenpenny-Chigas, R., Demark-Wahnefried, W., Arthur, A.E., #strong[Murrah, W.M.];, Pol, W.J., Jasper, S.L., Morrow, C.D., Arnold, R.D. Braxton-Lloyd, K. (2021). A Dietary Intervention High in Green Leafy Vegetables Reduces Oxidative DNA Damage in Adults at Increased Risk of Colorectal Cancer: Biological Outcomes of the Randomized Controlled Meat and Three Greens (M3G) Feasibility Trial. #emph[Nutrients];, 13(3), 1220.

#strong[Murrah, W. M.] (2020). Compound Bias Due to Measurement Error When Comparing Regression Coefficients, #emph[Educational and Psychological Measurement];, 80(3).

\*Wright, T. K., #strong[Murrah, W. M.];, Zabala M. E. (2020). Knee Valgus vs.~Knee Abduction Angle: Comparative Analysis of Medial Knee Collapse Definitions in Female Athletes, #emph[Journal of Biomechanical Engineering];.

Chesser, S., #strong[Murrah, W. M.];, Forbes, S. A. (2020). Impact of Personality on Choice of Instructional Delivery and Students' Performance, #emph[American Journal of Distance Education];.

Frugé, A.D., Smith, K.S., Riviere, A.J., Demark-Wahnefried, W., Arthur, A.E. #strong[Murrah, W.M.];, Morrow, C.D. Arnold, R.D. Braxton-Lloyd, K. (2019) Primary outcomes of a randomized controlled crossover trial to explore the effects of a high chlorophyll dietary intervention to reduce colon cancer risk in adults: The Meat and Three Greens (M3G) Feasibility Trial, #emph[Nutrients];.

\*Friesen, K. B. Barfield, J.W. #strong[Murrah, W.M.];, Dugas, J.R. Andrews, J.R. and Oliver, G.D. (2019).The Association of Upper-Body Kinematics and Earned Run Average of National Collegiate Athletic Association Division I Softball Pitchers, #emph[Journal of Strength and Conditioning];.

\*Brinkerhoff, S. A., #strong[Murrah, W. M.] Hutchison, Z. Miller, M. Roper, J. A. (2019). Words matter: Instructions dictate "self-selected" walking speed in young adults. #emph[Gait & Posture];.

Brock, L. L., #strong[Murrah, W. M.];, Cottone, E. A., Mashburn, A. J., & Grissmer, D. W. (2018). An after-school intervention targeting executive function and visuospatial skills also improves classroom behavior. #emph[International Journal of Behavioral Development];.

#strong[Murrah, W. M.];, Kosovich, J. J., & Hulleman, C. S. (2016). Measuring Fidelity in Educational Settings. In Roberts, G., Vaughn, S., Beretvas, T., & Wong, V. (Eds.), #emph[Implementation Fidelity in Randomized Educational Trials: An Applied Perspective.] Routledge.

Cameron, C. E., Cottone, E. A., #strong[Murrah, W. M.] & Grissmer, D. W. (2016). How are motor skills linked to children's school performance and academic achievement? #emph[Child Development Perspectives, 10(2)];, 93-98.

\*Kim, H., Schmidt, K. M., #strong[Murrah, W. M.];, Cameron, C. E., & Grissmer, D. (2015). A Rasch Analysis of the KeyMath-3 Diagnostic Assessment. #emph[Journal of Applied Measurement];, 16(4), 365-378.

\*Kim, H., #strong[Murrah, W. M.];, Cameron, C. E., Brock, L. L., Cottone, E. A., & Grissmer, D. (2014). Psychomotor properties of the Teacher-Reported Motor Skills Rating Scale. #emph[Journal of Psychoeducational Assessment];, first published on October 6, 2014 as doi:10.1177/0734282914551536.

Ponitz, C. C., Brock, L. L., #strong[Murrah, W. M.];, Bell, L., Worzalla, S., Grissmer, D. W., & Morrison, F. J. (2012). Fine motor skills and executive function both contribute to kindergarten achievement. #emph[Child Development];, 83(4), 1229-1244.

Grissmer, D., Grimm, K.J., Aiyer, S.M., #strong[Murrah, W. M.];, & Steele, J.S. (2010). Fine motor skills and early comprehension of the world: Two new school readiness indicators. #emph[Developmental Psychology];, 46(5), 1008-1017.

== Articles Under Review
<articles-under-review>
Sarah A. Brinkerhoff, Natalia Sanchez, Meral N. Culver, #strong[William M. Murrah];, Austin T. Robinson, J. Danielle McCullough, Matthew W. Miller, Jaimie A. Roper (under review). The dual timescales of gait adaptation: initial stability adjustments followed by subsequent energetic cost adjustments. #emph[Journal of Experimental Biology];.

Philip Joshua Agostinell, Nicholas C. Bordonie, Braxton A. Linder, Ann M. Robbins, Parker L. Jones, Lee F. Reagan, C. Brooks Mobley, Matthew W. Miller, #strong[William M. Murrah];, JoEllen M. Sefton (under review). Acute exercise impacts heart rate variability but not cognitive flexibility during subsequent simulated firefighter occupational tasks. #emph[European Journal of Applied Physiology];.

== Presentations
<presentations>
#strong[Murrah, W.M.];, Chesser, S., Neugebauer, N.M. (2022). #emph[Nonlinear Gompertz Curves of Mathematics, Reading, and Science Achievement];, Presented at the American Educational Research Association Annual Meeting.

\* Moore, T.F., Chesser, S., #strong[Murrah, W.M.] (2022), #emph[Improving Connectedness in At-Risk Adolescents in the Alternative School Setting];, Poster presented at the American Educational Research Association Annual Meeting.

\*Neely, K., Zhang, Z., Blanton, R., Gladson, M., Schmid, D. Heavlin, H., Brown, S., Brown, S., Pangelinan, M., #strong[Murrah, W. M.] (2022). #emph[Balance Control in Midlife Adults With and Without ADHD.] Presented at North American Society for the Psychology of Sport and Physical Activity.

\*Neely, K., Zhang, Z., & #strong[Murrah, W. M.] (2021) #emph[Variability in Motor Control: Multilevel Modeling Reveals Meaningful Differences in Force Output.] Presented at North American Society for the Psychology of Sport and Physical Activity Virtual Conference.

Schmid, D., Blanton, R., White, T., #strong[Murrah, W. M.];, & Kneely, K. (2021). #emph[Withdrawn Behavior Influences Engagement in Vigorous and Moderate Physical Activity];. Presented at the North American Society for the Psychology of Sport and Physical Activity Virtual Conference.

Francis, M., Tibbetts, Y., #strong[Murrah, W. M.];, Phelps, J., Silverman, D., Moran, M., Kosovich, J., & Hulleman, C. (2018) #emph[Using a utility-value intervention to remove barriers in gateway math courses.] Poster presented at the 2018 Understanding Interventions Conference, Baltimore, MD.

#strong[Murrah, W. M.];, Ruzek, E. A., & Grissmer, D. W. (2017) #emph[Children's fine motor skills are important for school readiness and science achievement.] Symposium presented at the Society for Research in Child Development 2017 Biennial Meeting, Austin, TX.

#strong[Murrah, W. M.];(2015) #emph[The Relative Importance of School Readiness Skills as Predictors of First, Third, and Eighth Grade Achievement];. Poster presented at the Society for Research in Child Development Biennial Meeting, Philadelphia, PA.

#strong[Murrah, W. M.];, Grissmer, D., Ko, Michelle, Player, D., Cabell, S., O'Brien, R. H.(2015). #emph[Early achievement impacts of Core Knowledge charter schools on early comprehension and general knowledge through 1st grade.] Presented at Association for Education Finance and Policy Annual Conference. Washington, DC.

#strong[Murrah. W. M.] (2013) #emph[The evolution and evaluation of a play-based, after-school curriculum that improves executive function, visuospatial and math skills for disadvantaged children.] Organizer of seminar and presenter at the Society for Research on Educational Effectiveness Fall Conference. Washington, DC.

#strong[Murrah. W. M.] (2011). #emph[Explaining the association between fine motor skills and math achievement.] Seminar presented to the faculty and students of the developmental psychology department at the University of Virginia. Charlottesville, VA

#strong[Murrah. W. M.] (2011). #emph[Fine motor skills predict later math, science, and reading achievement];. Symposium presented at the Society for Research in Child Development 2011 Biennial Meeting, Montreal, Quebec.

#strong[Murrah. W. M.] (2010). #emph[Fine motor skills as a predictor of later math, reading, and science elementary achievement.] Paper presented to the Conference on Human Development, 2010 Annual Meeting, New York City, NY.

#strong[Murrah. W. M.] (2009). #emph[Which developmental skills predict later math, reading, and science elementary school achievement?] Paper presented to National Science Foundation Advisory Board, 2009. Charlottesville, VA.

= Grant Funding
<grant-funding>
== Previous Funding
<previous-funding>
Inhibitory Motor Control in Adults with ADHD, PI: Kristina Neely, #emph[Auburn University Intramural Grants Program];. \$25,000; Role: Co-investigator.

How the Motor System Reflects Impulsivity and Inhibitory Control in Healthy Young Adults. PI: Kristina Neely. #emph[Auburn University Intramural Grants Program];. \$20,600. Role: Co-PI.

Removing Barriers to Success in Mathematics: An Integrative Expectancy-Value Intervention. PI: Chris Hulleman. #emph[National Science Foundation];. Approximately \$1,500,000. Project Period: 9/01/2015 - 8/31/2019. Role: Senior Personnel/Methodologist.

Developmental Skills Linked to Math and Science Achievement: An Interdisciplinary Data-Intensive Approach to Identification and Improvement through Experimental Intervention. #emph[National Science Foundation];. Approximately \$2,500,000. Project Period: 9/1/2013 - 8/31/2018. Role: Research Scientist/Methodologist.

Evaluation of Core Knowledge charter schools in Colorado. #emph[Institute of Education Sciences];. Approximately \$4,900,000. Project Period: 07/01/2009 - 12/31/2015. Role: Research Scientist/Methodologist.

Efficacy of the WINGS after-school social and emotional learning (SEL) program. #emph[Institute of Education Sciences];. Approximately \$2,700,000. Project Period: 09/01/2011 - 8/31/2015. Role: Research Scientist/Methodologist.

Math and science achievement gaps for minority and disadvantaged students: Developmental and environmental influences from nine months to 8th grade, #emph[National Science Foundation];, 2008 - 2012 (\$952,710) Role: Co-Investigator/ Methodologist.

Improving fine motor skill development to promote mathematical ability, #emph[Institute of Education Sciences];, 2009 - 2012 (\$462,765) Role: Primary Data Analyst

New kindergarten readiness indicators for math and science: Next steps in validation, communication and projecting policy impacts, #emph[National Science Foundation];, 2010-2012 (\$297,653) Role: Co-investigator/Methodologist.

== Other Research Experience
<other-research-experience>
Research Associate, #emph[University of Virginia];, Summer 2010--Spring 2014.

Graduate Research Assistant, #emph[University of Virginia];, Summer 2009--Spring 2010.

Curry Participant Pool Coordinator, #emph[University of Virginia];, Summer 2008- Spring 2009.

Graduate Research Assistant, #emph[University of Virginia];, 2005-2006.

= Teaching
<teaching>
Special Topics: Multilevel Modeling, ERMA 7970, #emph[Auburn University ];Summer 2020.

Advanced Measurement Theory, ERMA 8350, #emph[Auburn University];, 2022 - 2023.

Introduction to Structural Equation Modeling, ERMA 8340, #emph[Auburn University];, 2019 - 2022.

Design and Analysis III, ERMA 8320, #emph[Auburn University];, 2018 - 2022.

Design and Analysis II, ERMA 7310, #emph[Auburn University];, 2018 - 2023.

Design and Analysis I, ERMA 7300, #emph[Auburn University];, 2017 - 2023.

Basic Methods in Education Research, ERMA 7200, #emph[Auburn University];, 2016 - 2021.

Confirmatory Factor Analysis and Scale Reliability, Statistical Programming Workshop, University of Virginia, January, 2016.

Introduction to Multiple Imputation with the `mice` package, Statistical Programming Workshop, University of Virginia, October, 2015.

Introduction to Multilevel Modeling, Statistical Programming Workshop, FOCAL Lab, University of Virginia, July, 2015.

Introduction to Statistical Programming with R, Statistical Programming Workshop, University of Virginia, Spring, 2015.

Introduction to Linear Models, University of Virginia, Curry Summer Undergraduate Research Program, Summer 2012.

Introduction to Inferential Statistics, University of Virginia, Curry Summer Undergraduate Research Program, Summer 2011.

Child Development, co-instructor, University of Virginia, Spring 2008.

Child Development, teaching assistant, University of Virginia, 2006-2007.

Child Development, co-instructor, Hampton Roads Center, University of Virginia, Spring 2005.

== Professional Activities
<professional-activities>
Editorial Board for #emph[Interdisciplinary Education and Psychology];.

Reviewer for #emph[Child Development]

Reviewer for #emph[Journal of Abnormal Child Psychology]

Reviewer for #emph[Early Childhood Research Quarterly]

Member, #emph[American Statistical Association ]

Member, #emph[Society for Research in Child Development]

Member, #emph[American Educational Research Association]

== Invited Workshops
<invited-workshops>
SREE Workshop: Intervention Fidelity -Models, Methods, and Applications, Fall 2014

== Trainings and Conferences Attended
<trainings-and-conferences-attended>
Intensive Longitudinal Methods, Statistical Horizons, October 23-24, 2015

Mediation, Moderation, and Conditional Process Analysis, Andrew F. Hayes, University of Virginia, June 4-5, 2015

Institute of Education Sciences Summer Research Training Institute: Cluster-Randomized Trials, Northwestern University, July 15-26, 2012

UseR! 2012, Vanderbilt University, June 11-15, 2012

Functional MRI in Clinical Research and Practice: Measurement, Design and Analysis, Carnegie Mellon University/University of Pittsburgh, June 13-17, 2011

Missing Data Workshop, University of Virginia, June 1-7, 2011

Society for Research in Child Development Conference, Montreal, March 31-April 3, 2011

Multi-Modal Neuroimaging Training, Martinos Medical Center, Boston, December 13-17, 2010

Conference on Human Development, New York, April 9-12, 2010

== Software Proficiency
<software-proficiency>
R, Mplus, , SPSS, Python, Stan, JAGS

= Other Professional Experience
<other-professional-experience>
Team Building Coordinator, #emph[Charlottesville's Challenge Course];, Charlottesville, VA, 2002 - 2004.

Counselor/Intervention Specialist, #emph[Hoover City School System];, Hoover, AL, 1999 - 2002.

Bridges Drug Education Program Instructor, #emph[Hoover City School System];, Hoover, AL, 1999 - 2002.

Independent Contract Work, #emph[Central Alabama];, 1997 - 2002.

Adventure Based Counselor/Case Manager, #emph[Bradford Health Services];, Pelham, AL, 1995 - 1997.

Conflict Resolution Counselor, #emph[Jemison Boy's Ranch];, Jemison, AL, 1993 - 1995.
