# frozen_string_literal: true

# ===========================================================================
# VERITAS Demo Articles — Production-Grade Seed Intelligence
# ===========================================================================
# 50 unique articles across 8 storylines, designed for an 8-minute demo.
# Each article has a curated headline, source, substantive content,
# pre-assigned topic/sentiment/threat, and intentional contradiction pairs.
#
# Storylines:
#   1. Black Sea Naval Standoff (Eastern Europe / Military)
#   2. Taiwan AI Chip Embargo (East Asia / Trade)
#   3. Iran Nuclear Talks Collapse (Middle East / Diplomacy)
#   4. Global Cyber Attribution Crisis (Multi-region / Cyber)
#   5. Sahel Wagner Expansion (Africa / Military)
#   6. Red Sea Shipping Disruption (Middle East / Trade)
#   7. US Election Narrative War (North America / Cyber)
#   8. BRICS Currency Challenge (Multi-region / Diplomacy)
# ===========================================================================

DEMO_ARTICLES = [
  # ============================================================
  # STORYLINE 1: Black Sea Naval Standoff
  # ============================================================
  {
    headline: "NATO warships enter Black Sea amid rising tensions with Russian naval forces",
    source_name: "Reuters",
    region_name: "Eastern Europe",
    country_iso: "UKR",
    topic: "Military",
    sentiment: "Bearish",
    threat: 3,
    trust: 88,
    summary: "NATO has deployed a carrier strike group to the western Black Sea in what alliance officials call a routine freedom-of-navigation exercise. Russia's Black Sea Fleet has shadowed the formation since it passed through the Bosphorus. Analysts warn this is the closest proximity between NATO and Russian warships since 2022. Turkey approved the transit under Montreux Convention provisions after extended diplomatic consultations.",
    content: <<~HTML
      <p>LONDON — NATO has deployed a carrier strike group to the western Black Sea in what alliance officials describe as a routine freedom-of-navigation exercise, but which regional analysts say represents the most significant naval buildup in the region since Russia's full-scale invasion of Ukraine.</p>
      <p>The task force, led by the French amphibious assault ship Mistral and accompanied by a US Arleigh Burke-class destroyer, passed through the Bosphorus Strait early Wednesday after Turkey approved the transit under Montreux Convention provisions.</p>
      <p>Russia's Black Sea Fleet, operating from its remaining bases in Crimea and Novorossiysk, has deployed at least four corvettes to shadow the NATO formation, according to satellite imagery analyzed by the open-source intelligence group Naval Lookout.</p>
      <p>"This is a deliberate escalation posture by NATO, disguised as routine activity," said Colonel Dmitry Volkov, a Russian military commentator. Moscow has warned that any approach within 50 nautical miles of Crimea would be treated as a hostile act.</p>
    HTML
  },
  {
    headline: "Russia claims NATO provocation as warships approach Crimean waters",
    source_name: "RT",
    region_name: "Eastern Europe",
    country_iso: "RUS",
    topic: "Military",
    sentiment: "Bearish",
    threat: 3,
    trust: 42,
    summary: "Russian Defense Ministry accuses NATO of deliberately provoking a confrontation in the Black Sea. State media reports Russian forces have been placed on high alert and anti-ship missile batteries activated along the Crimean coast. Moscow characterizes the NATO transit as an illegal violation of established security agreements and warns of immediate military response if territorial waters are breached.",
    content: <<~HTML
      <p>MOSCOW — The Russian Defense Ministry has accused NATO of deliberately provoking a confrontation in the Black Sea by deploying warships within striking distance of Crimea.</p>
      <p>"These are not routine exercises. This is a calculated provocation aimed at testing Russia's defensive perimeter," Defense Ministry spokesman Igor Konashenkov told reporters at a press briefing Wednesday.</p>
      <p>Russia has placed its Black Sea coastal defense forces on high alert, with Bastion-P anti-ship missile systems reportedly activated along the Crimean coastline. Sources within the Russian General Staff indicate that submarine assets have also been mobilized.</p>
      <p>The Kremlin has demanded an emergency session of the UN Security Council, characterizing the NATO transit as a violation of established de-escalation protocols.</p>
    HTML
  },
  {
    headline: "Ukraine calls Black Sea NATO presence 'long overdue' as frontline pressure mounts",
    source_name: "BBC",
    region_name: "Eastern Europe",
    country_iso: "UKR",
    topic: "Military",
    sentiment: "Bullish",
    threat: 2,
    trust: 85,
    summary: "Kyiv has welcomed the NATO naval deployment as essential for securing grain export corridors and deterring further Russian aggression. President Zelensky stated the presence demonstrates alliance solidarity. Ukrainian military officials report that Russian naval attacks on civilian shipping have increased 40% in the past month, making the NATO presence a humanitarian necessity as much as a military one.",
    content: <<~HTML
      <p>KYIV — Ukraine has welcomed the NATO naval deployment in the Black Sea as "long overdue," with President Volodymyr Zelensky calling it a necessary step to protect grain export corridors that feed millions across Africa and the Middle East.</p>
      <p>"For too long, Russia has held the Black Sea hostage. This changes the equation," Zelensky said in his nightly address. Ukrainian military officials report that Russian naval attacks on civilian shipping have increased 40% over the past month.</p>
      <p>The deployment comes as Ukraine's southern front faces renewed pressure, with Russian forces attempting amphibious operations near the Dnipro River delta. NATO officials stress the deployment is purely defensive and focused on ensuring safe passage for commercial shipping.</p>
    HTML
  },
  {
    headline: "Black Sea standoff: Satellite imagery contradicts Russian claims of NATO aggression",
    source_name: "Associated Press",
    region_name: "Eastern Europe",
    country_iso: "UKR",
    topic: "Military",
    sentiment: "Neutral",
    threat: 3,
    trust: 91,
    summary: "Commercial satellite analysis from Planet Labs shows NATO vessels maintaining a 90-nautical-mile buffer from Crimean waters, directly contradicting Russian claims of territorial encroachment. The same imagery reveals Russia has repositioned three Kilo-class submarines from Novorossiysk to forward positions. Independent analysts assess Moscow's rhetoric as significantly exceeding the actual threat level posed by NATO movements.",
    content: <<~HTML
      <p>WASHINGTON — Commercial satellite imagery obtained by The Associated Press from Planet Labs contradicts Russian claims that NATO warships have approached Crimean territorial waters.</p>
      <p>Analysis of imagery captured over the past 48 hours shows the NATO task force maintaining a consistent buffer zone of approximately 90 nautical miles from the nearest Crimean coastline — well within international waters and far from the 12-nautical-mile territorial limit.</p>
      <p>The same imagery reveals that Russia has repositioned at least three Kilo-class submarines from Novorossiysk to forward positions in the central Black Sea, a move that military analysts say represents a more significant escalation than the NATO surface deployment.</p>
      <p>"The Russian narrative is running ahead of the facts on the water," said Dr. Sidharth Kaushal, a naval analyst at RUSI. "Moscow is creating a justification framework for actions it intends to take regardless of NATO behavior."</p>
    HTML
  },
  {
    headline: "China urges 'all parties' to show restraint in Black Sea as tensions spike",
    source_name: "Xinhua",
    region_name: "East Asia",
    country_iso: "CHN",
    topic: "Military",
    sentiment: "Neutral",
    threat: 2,
    trust: 55,
    summary: "Beijing has called for de-escalation in the Black Sea while carefully avoiding direct criticism of Russia. China's Foreign Ministry spokesperson framed NATO expansion as the root cause of instability, implicitly supporting Moscow's position. The statement notably omits any reference to Russia's occupation of Crimea or attacks on civilian shipping, focusing instead on 'Cold War mentality' driving alliance behavior.",
    content: <<~HTML
      <p>BEIJING — China's Ministry of Foreign Affairs has called on "all parties" to exercise restraint in the Black Sea, warning that military buildups risk catastrophic miscalculation.</p>
      <p>"The root cause of tensions in the Black Sea region is the continued expansion of military alliances and the Cold War mentality that drives them," spokesperson Lin Jian said at a regular press briefing.</p>
      <p>The statement carefully avoids naming Russia while implicitly criticizing NATO. Beijing has maintained its position that the security concerns of all countries should be respected, a formulation that Moscow has interpreted as supportive of its stance on Crimea and Ukraine.</p>
      <p>Chinese state media coverage has emphasized NATO's "provocative" transit while downplaying Russia's submarine deployments, reflecting Beijing's broader alignment with Moscow on European security architecture.</p>
    HTML
  },
  {
    headline: "Fox News: Biden administration 'sleepwalking into WWIII' with Black Sea gamble",
    source_name: "Fox News",
    region_name: "North America",
    country_iso: "USA",
    topic: "Military",
    sentiment: "Bearish",
    threat: 3,
    trust: 58,
    summary: "Fox News coverage frames the Black Sea deployment as reckless brinkmanship by the Biden administration, arguing that the operation risks nuclear escalation without clear strategic objectives. Conservative commentators question whether grain corridor protection justifies the risk of direct NATO-Russia confrontation. The coverage emphasizes domestic economic concerns over international security commitments.",
    content: <<~HTML
      <p>NEW YORK — The Biden administration is "sleepwalking into World War III" by deploying NATO warships into the Black Sea without a clear exit strategy, according to senior military analysts appearing on Fox News.</p>
      <p>"What happens when a Russian submarine gets too close? What are the rules of engagement? Nobody in the White House has answered these questions," said retired General Jack Keane. "We're playing chicken with a nuclear power over grain shipments."</p>
      <p>The deployment has reignited domestic debate over US involvement in the Ukraine conflict, with Republican lawmakers demanding congressional authorization for any military action in the Black Sea theater.</p>
    HTML
  },

  # ============================================================
  # STORYLINE 2: Taiwan AI Chip Embargo
  # ============================================================
  {
    headline: "US expands AI chip export ban to 14 Chinese entities in sweeping sanctions package",
    source_name: "Bloomberg",
    region_name: "North America",
    country_iso: "USA",
    topic: "Trade",
    sentiment: "Bullish",
    threat: 2,
    trust: 90,
    summary: "The US Commerce Department has added 14 Chinese technology firms to its entity list, effectively cutting them off from advanced AI accelerators manufactured by NVIDIA, AMD, and Intel. The move targets companies linked to China's military-civil fusion program and represents the most aggressive semiconductor restriction since October 2022. Industry analysts estimate the ban will cost US chipmakers $12B in annual revenue.",
    content: <<~HTML
      <p>WASHINGTON — The US Commerce Department has imposed sweeping new export controls on advanced AI semiconductors, adding 14 Chinese technology firms to its entity list in the most aggressive expansion of chip restrictions since the initial October 2022 package.</p>
      <p>The targeted entities include subsidiaries of major Chinese cloud computing providers that the Commerce Department says have been circumventing existing restrictions through shell companies in Singapore and Malaysia.</p>
      <p>NVIDIA shares fell 4.2% on the announcement, with analysts estimating the expanded ban will cost US chipmakers approximately $12 billion in annual revenue. "The administration has decided that national security outweighs commercial interests," said Chris Miller, author of Chip War.</p>
    HTML
  },
  {
    headline: "China retaliates with rare earth export controls targeting US defense supply chain",
    source_name: "Global Times",
    region_name: "East Asia",
    country_iso: "CHN",
    topic: "Trade",
    sentiment: "Bearish",
    threat: 3,
    trust: 45,
    summary: "Beijing has announced immediate export restrictions on 7 critical rare earth elements essential for US defense manufacturing, including gallium, germanium, and antimony. China's Ministry of Commerce framed the move as a 'legitimate response to unilateral economic coercion.' The restrictions threaten production of F-35 fighter jets, precision-guided munitions, and satellite communications equipment. Global rare earth prices surged 23% within hours.",
    content: <<~HTML
      <p>BEIJING — China has announced immediate export restrictions on seven critical rare earth elements in direct retaliation for the expanded US semiconductor ban, targeting materials essential to American defense manufacturing.</p>
      <p>The restricted elements — gallium, germanium, antimony, superhard materials, and three classified rare earth compounds — are critical inputs for F-35 fighter jet components, precision-guided munitions, and military satellite systems.</p>
      <p>"China will not stand idle while the United States weaponizes technology trade," Commerce Ministry spokesperson He Yadong said. "These measures are a legitimate and proportionate response to unilateral economic coercion."</p>
      <p>Global rare earth futures surged 23% within hours of the announcement. The Pentagon declined to comment on the impact to defense procurement timelines.</p>
    HTML
  },
  {
    headline: "Taiwan's TSMC caught in crossfire as chip war escalates between superpowers",
    source_name: "Financial Times",
    region_name: "East Asia",
    country_iso: "TWN",
    topic: "Trade",
    sentiment: "Bearish",
    threat: 2,
    trust: 92,
    summary: "TSMC faces impossible compliance demands from both Washington and Beijing as the semiconductor trade war intensifies. The company's Arizona fab is behind schedule while Chinese orders still account for 12% of revenue. Taiwan's economy ministry warns that the island risks becoming 'collateral damage' in a conflict it cannot control. Semiconductor industry leaders are calling for diplomatic intervention before supply chains fragment irreversibly.",
    content: <<~HTML
      <p>TAIPEI — Taiwan Semiconductor Manufacturing Company, the world's most advanced chipmaker, finds itself caught between escalating demands from Washington and Beijing as the AI chip trade war enters a dangerous new phase.</p>
      <p>TSMC's Arizona fabrication plant, intended to reduce US dependence on Taiwanese manufacturing, is running 18 months behind schedule and $5 billion over budget. Meanwhile, Chinese orders still account for 12% of the company's revenue — business it cannot afford to lose.</p>
      <p>"Taiwan is being forced to choose between its security guarantor and its largest trading partner," said Joanne Chiao, semiconductor analyst at TrendForce. "There is no scenario where TSMC wins."</p>
      <p>Taiwan's Economy Ministry issued a rare public statement warning that the island risks becoming "collateral damage in a great-power technology conflict it did not start."</p>
    HTML
  },
  {
    headline: "Japan and South Korea accelerate joint chip alliance to reduce China dependency",
    source_name: "Associated Press",
    region_name: "East Asia",
    country_iso: "JPN",
    topic: "Trade",
    sentiment: "Bullish",
    threat: 1,
    trust: 89,
    summary: "Tokyo and Seoul have announced an unprecedented semiconductor cooperation pact, setting aside historical rivalries to build resilient chip supply chains independent of both China and Taiwan. The agreement includes joint R&D on next-generation 2nm processes, shared rare earth stockpiling, and coordinated export control alignment with Washington. The deal signals a fundamental restructuring of Asian technology alliances.",
    content: <<~HTML
      <p>TOKYO — Japan and South Korea have announced a landmark semiconductor cooperation agreement, setting aside decades of historical rivalry to build chip supply chains resilient to both Chinese coercion and Taiwan contingency scenarios.</p>
      <p>The pact, signed by Japanese PM Ishiba and South Korean President Yoon, includes joint research on sub-2nm manufacturing processes, coordinated rare earth stockpiling, and aligned export control frameworks compatible with US restrictions.</p>
      <p>"The semiconductor landscape has changed so fundamentally that old rivalries are now a luxury we cannot afford," said Japanese Economy Minister Nishimura. Samsung and Rapidus will lead the joint venture, with initial investment of $8 billion over five years.</p>
    HTML
  },

  # ============================================================
  # STORYLINE 3: Iran Nuclear Talks Collapse
  # ============================================================
  {
    headline: "Iran nuclear talks collapse as IAEA detects uranium enrichment at 83% purity",
    source_name: "Reuters",
    region_name: "Middle East",
    country_iso: "IRN",
    topic: "Diplomacy",
    sentiment: "Bearish",
    threat: 3,
    trust: 90,
    summary: "The IAEA has confirmed detection of uranium particles enriched to 83.7% at Iran's Fordow facility — just below weapons-grade 90%. Diplomatic talks in Vienna have collapsed after Iran refused to allow inspectors access to a newly identified underground site near Isfahan. Western diplomats describe the situation as the most dangerous nuclear proliferation crisis since North Korea's 2017 tests. Israel has placed its military on heightened alert.",
    content: <<~HTML
      <p>VIENNA — International nuclear negotiations with Iran have collapsed after the International Atomic Energy Agency confirmed the detection of uranium particles enriched to 83.7% purity at the underground Fordow facility — a level experts say is functionally indistinguishable from weapons-grade material.</p>
      <p>The discovery, disclosed in a confidential IAEA report obtained by Reuters, prompted Western delegations to walk out of Vienna talks that had been billed as a "last chance" for diplomacy.</p>
      <p>"Enrichment at 83% has no civilian justification. None," said a senior European diplomat who requested anonymity. "We are now in uncharted territory."</p>
      <p>Iran simultaneously refused IAEA access to a newly identified underground facility near Isfahan, which satellite imagery suggests has been under construction since 2024. Israel's Defense Minister has placed the IDF on heightened alert status.</p>
    HTML
  },
  {
    headline: "Iran insists nuclear program is 'entirely peaceful' despite IAEA findings",
    source_name: "Al Jazeera",
    region_name: "Middle East",
    country_iso: "IRN",
    topic: "Diplomacy",
    sentiment: "Neutral",
    threat: 2,
    trust: 70,
    summary: "Iran's Foreign Minister has dismissed IAEA findings as 'politically motivated fabrications' orchestrated by the United States and Israel. Tehran maintains its enrichment program serves medical isotope production and civilian energy needs. Iran's Atomic Energy Organization claims the 83% reading was a 'technical anomaly' from equipment contamination, not deliberate enrichment. Regional analysts note that Iran's diplomatic posture has hardened significantly since the collapse of the 2015 JCPOA.",
    content: <<~HTML
      <p>TEHRAN — Iran has dismissed the latest IAEA findings as "politically motivated fabrications" designed to build a case for military action, insisting that its nuclear program remains entirely peaceful.</p>
      <p>"The Islamic Republic's nuclear activities are transparent, lawful, and under continuous IAEA monitoring," Foreign Minister Hossein Amir-Abdollahian said. "These allegations are manufactured by the same intelligence agencies that fabricated evidence of Iraqi weapons of mass destruction."</p>
      <p>Iran's Atomic Energy Organization issued a technical rebuttal claiming the 83.7% enrichment reading was a "contamination anomaly" from equipment previously used in medical isotope production, not evidence of deliberate weapons-grade enrichment.</p>
      <p>The explanation was met with skepticism by Western nuclear scientists, who note that such contamination patterns are inconsistent with the particle distribution found at Fordow.</p>
    HTML
  },
  {
    headline: "Israeli military conducts largest-ever aerial exercise simulating Iran strike",
    source_name: "CNN",
    region_name: "Middle East",
    country_iso: "ISR",
    topic: "Military",
    sentiment: "Bearish",
    threat: 3,
    trust: 82,
    summary: "The Israeli Air Force has conducted its largest-ever long-range aerial exercise over the Mediterranean, involving over 100 aircraft including F-35I stealth fighters and aerial refueling tankers. Military analysts assess the exercise as a clear rehearsal for a potential strike on Iran's nuclear facilities. The operation, codenamed 'Blue Horizon,' simulated penetrating advanced air defense systems at distances matching the route to Iran's Fordow and Natanz sites.",
    content: <<~HTML
      <p>JERUSALEM — The Israeli Air Force has conducted its most extensive long-range aerial exercise in history, deploying over 100 aircraft in a Mediterranean drill that military analysts say was an unmistakable rehearsal for a potential strike on Iranian nuclear facilities.</p>
      <p>The exercise, codenamed "Blue Horizon," involved F-35I Adir stealth fighters, F-15I Ra'am strike aircraft, and multiple aerial refueling tankers operating at distances that precisely match the flight path to Iran's Fordow and Natanz enrichment sites.</p>
      <p>"This is not saber-rattling. This is mission rehearsal," said Amos Yadlin, former head of Israeli military intelligence. "The timing, immediately after the IAEA report, is not coincidental."</p>
    HTML
  },
  {
    headline: "Saudi Arabia quietly accelerates own nuclear program as Iran tensions surge",
    source_name: "Financial Times",
    region_name: "Middle East",
    country_iso: "SAU",
    topic: "Diplomacy",
    sentiment: "Bearish",
    threat: 2,
    trust: 88,
    summary: "Satellite imagery reveals significant new construction at Saudi Arabia's Al-Ula nuclear research complex, including what appears to be a uranium conversion facility. Riyadh has long maintained it will pursue nuclear weapons if Iran does. The construction surge coincides with the collapse of Vienna talks and represents a potential second proliferation front in the Middle East. US officials have reportedly raised concerns directly with Crown Prince Mohammed bin Salman.",
    content: <<~HTML
      <p>LONDON — Satellite imagery analyzed by the James Martin Center for Nonproliferation Studies reveals significant new construction at Saudi Arabia's Al-Ula nuclear research complex, including structures consistent with a uranium conversion facility.</p>
      <p>The construction, which has accelerated markedly since the collapse of Iran nuclear talks, aligns with Saudi Arabia's long-standing position that it will match any Iranian nuclear capability. "If Iran gets the bomb, we will too," Crown Prince Mohammed bin Salman told the BBC in 2018.</p>
      <p>US officials have reportedly raised concerns directly with Riyadh, but Saudi Arabia maintains the program is for civilian energy purposes under IAEA safeguards. Non-proliferation experts warn that the Middle East is entering its most dangerous nuclear competition since the Cold War.</p>
    HTML
  },

  # ============================================================
  # STORYLINE 4: Global Cyber Attribution Crisis
  # ============================================================
  {
    headline: "Massive cyberattack cripples European port infrastructure across 6 countries",
    source_name: "BBC",
    region_name: "Western Europe",
    country_iso: "NLD",
    topic: "Cyber",
    sentiment: "Bearish",
    threat: 3,
    trust: 87,
    summary: "A coordinated cyberattack has disrupted port operations in Rotterdam, Hamburg, Antwerp, Marseille, Genoa, and Barcelona, affecting an estimated $2.1 billion in daily trade. The attack targeted industrial control systems managing container logistics and vessel traffic. EU officials describe it as the most sophisticated infrastructure attack in European history. Attribution remains contested, with preliminary indicators pointing to a state-sponsored actor.",
    content: <<~HTML
      <p>ROTTERDAM — A coordinated cyberattack has crippled port operations across six European countries, disrupting container handling systems, vessel traffic management, and customs processing at some of the continent's busiest maritime hubs.</p>
      <p>The attack, which began at approximately 03:00 CET on Tuesday, simultaneously targeted Rotterdam, Hamburg, Antwerp, Marseille, Genoa, and Barcelona — ports that collectively handle over €2.1 billion in daily trade volume.</p>
      <p>The malware, which cybersecurity firm Mandiant has designated "TIDEWRECK," exploited vulnerabilities in Navis N4 terminal operating systems that manage container logistics. Port authorities have reverted to manual operations, creating backlogs expected to last weeks.</p>
      <p>"This is the most sophisticated infrastructure cyberattack we've ever seen in Europe," said EU Cyber Commissioner Thierry Breton. "The coordination across six countries simultaneously indicates a state-level actor."</p>
    HTML
  },
  {
    headline: "Russia denies involvement in European port hack, blames 'Western false flag'",
    source_name: "TASS",
    region_name: "Eastern Europe",
    country_iso: "RUS",
    topic: "Cyber",
    sentiment: "Neutral",
    threat: 2,
    trust: 35,
    summary: "Russia's Foreign Ministry has categorically denied involvement in the European port cyberattack, calling the accusations 'Russophobic hysteria without evidence.' Moscow suggests the attack may be a Western false flag operation designed to justify expanded NATO cyber operations. Russian cybersecurity firm Kaspersky Lab claims initial technical indicators are inconsistent with known Russian APT groups and suggest a Southeast Asian origin.",
    content: <<~HTML
      <p>MOSCOW — Russia has categorically denied any involvement in the cyberattack that crippled European port operations, with Foreign Ministry spokesperson Maria Zakharova calling the emerging accusations "Russophobic hysteria based on zero evidence."</p>
      <p>"Every time something goes wrong in the West, the first instinct is to blame Russia," Zakharova said. "Perhaps they should examine whether this was a false flag operation designed to justify the expansion of NATO's cyber warfare capabilities."</p>
      <p>Russian cybersecurity firm Kaspersky Lab published a preliminary analysis claiming the TIDEWRECK malware contains code signatures inconsistent with known Russian advanced persistent threat groups, suggesting instead a Southeast Asian origin.</p>
      <p>Western cybersecurity analysts have disputed Kaspersky's analysis, noting the firm's historical ties to Russian intelligence services.</p>
    HTML
  },
  {
    headline: "NSA traces port cyberattack to GRU Unit 74455 with 'high confidence'",
    source_name: "Washington Post",
    region_name: "North America",
    country_iso: "USA",
    topic: "Cyber",
    sentiment: "Bearish",
    threat: 3,
    trust: 84,
    summary: "The NSA has attributed the European port cyberattack to Russia's GRU Unit 74455 (Sandworm) with 'high confidence,' based on command-and-control infrastructure overlaps with previous Sandworm operations. The assessment was shared with Five Eyes partners and NATO allies. The attack is believed to be retaliation for NATO's Black Sea naval deployment. US Cyber Command has reportedly elevated its defensive posture to DEFCON-level readiness.",
    content: <<~HTML
      <p>WASHINGTON — The National Security Agency has attributed the coordinated cyberattack on European ports to Russia's GRU Unit 74455, known as Sandworm, with "high confidence," according to three officials familiar with the classified assessment.</p>
      <p>The attribution is based on overlaps between the command-and-control infrastructure used in the TIDEWRECK operation and servers previously linked to Sandworm campaigns, including the 2017 NotPetya attack and the 2022 Industroyer2 operation against Ukrainian power infrastructure.</p>
      <p>Intelligence officials believe the port attack was direct retaliation for NATO's Black Sea naval deployment. "This is hybrid warfare in action — you send ships, they send code," said a senior CISA official.</p>
      <p>US Cyber Command has elevated its defensive posture, and the White House is considering a range of retaliatory options including offensive cyber operations and additional sanctions.</p>
    HTML
  },
  {
    headline: "Insurance industry faces $4B exposure as cyber war exclusions tested by port attack",
    source_name: "Bloomberg",
    region_name: "Western Europe",
    country_iso: "GBR",
    topic: "Cyber",
    sentiment: "Bearish",
    threat: 2,
    trust: 91,
    summary: "Lloyd's of London and major reinsurers face up to $4 billion in potential claims from the European port cyberattack, but war exclusion clauses introduced in 2023 may allow insurers to deny coverage if the attack is formally attributed to a state actor. The insurance industry's response will set precedent for how cyber warfare losses are absorbed by the global economy. Companies affected are already filing emergency claims.",
    content: <<~HTML
      <p>LONDON — The Lloyd's of London insurance market and major global reinsurers face up to $4 billion in potential claims from the European port cyberattack, but recently introduced cyber war exclusion clauses could leave affected businesses without coverage.</p>
      <p>In 2023, Lloyd's mandated that all cyber insurance policies include exclusions for state-backed attacks. If the NSA's attribution to Russia's GRU is formally adopted, insurers may invoke these clauses to deny claims — leaving port operators, shipping companies, and manufacturers to absorb billions in losses.</p>
      <p>"This is the test case the insurance industry has been dreading," said Tom Bolt, former Lloyd's performance director. "If war exclusions hold, the cyber insurance market works. If they don't, it's a systemic crisis."</p>
    HTML
  },

  # ============================================================
  # STORYLINE 5: Sahel Wagner Expansion
  # ============================================================
  {
    headline: "Wagner Group doubles presence in Mali and Burkina Faso with new mining contracts",
    source_name: "Le Monde",
    region_name: "Africa",
    country_iso: "NGA",
    topic: "Military",
    sentiment: "Bearish",
    threat: 2,
    trust: 83,
    summary: "French intelligence reports indicate Wagner Group has doubled its personnel in the Sahel region to approximately 3,400 operatives, securing new gold and lithium mining concessions in exchange for military support to ruling juntas. The expansion follows France's forced withdrawal from Mali and Niger. Human rights organizations report a surge in civilian casualties in areas where Wagner operates. The Kremlin continues to deny any official connection to the group.",
    content: <<~HTML
      <p>PARIS — Russia's Wagner Group has doubled its military presence in West Africa's Sahel region, deploying approximately 3,400 operatives across Mali, Burkina Faso, and Niger in exchange for lucrative mining concessions, according to French military intelligence assessments shared with Le Monde.</p>
      <p>The expansion has been funded through new gold and lithium mining contracts that analysts estimate generate $250 million annually for Wagner's successor organization, now operating under the Africa Corps banner.</p>
      <p>Human rights organizations have documented a 300% increase in civilian casualties in Wagner-controlled areas, including summary executions of suspected militants and forced displacement of mining communities.</p>
      <p>"France was expelled, and what replaced us is infinitely worse for the civilian population," said a senior French defense official.</p>
    HTML
  },
  {
    headline: "African Union welcomes Russian security partnership as 'sovereign choice'",
    source_name: "Nation Africa",
    region_name: "Africa",
    country_iso: "KEN",
    topic: "Diplomacy",
    sentiment: "Neutral",
    threat: 1,
    trust: 68,
    summary: "The African Union has pushed back against Western criticism of Russian military partnerships in the Sahel, framing the arrangements as sovereign security decisions by independent nations. AU spokesperson emphasizes that African countries have the right to choose their security partners, noting that Western forces also operated in the region for decades without resolving the jihadist insurgency. The statement reflects growing anti-Western sentiment across the continent.",
    content: <<~HTML
      <p>ADDIS ABABA — The African Union has pushed back sharply against Western criticism of Russian security partnerships in the Sahel, with AU Commission Chair Moussa Faki Mahamat calling the arrangements "sovereign decisions by independent nations."</p>
      <p>"African countries have the right to choose their security partners. France operated in the Sahel for a decade without defeating the insurgency. These governments have chosen a different path, and that choice must be respected," Faki said.</p>
      <p>The statement reflects a broader shift in African diplomatic sentiment, where frustration with former colonial powers has created an opening for Russian and Chinese influence. Western diplomats privately acknowledge that their messaging on Wagner has failed to resonate with African audiences.</p>
    HTML
  },

  # ============================================================
  # STORYLINE 6: Red Sea Shipping Disruption
  # ============================================================
  {
    headline: "Houthi missile strike damages oil tanker in Red Sea, shipping rates spike 40%",
    source_name: "Reuters",
    region_name: "Middle East",
    country_iso: "SAU",
    topic: "Trade",
    sentiment: "Bearish",
    threat: 3,
    trust: 92,
    summary: "A Houthi anti-ship missile has struck the Greek-flagged tanker Sounion in the southern Red Sea, causing a major oil spill and forcing the vessel's evacuation. Global shipping insurance rates for Red Sea transit have spiked 40% within hours. Major carriers Maersk and MSC have suspended all Red Sea transits indefinitely, rerouting vessels around the Cape of Good Hope at an estimated additional cost of $1 million per voyage. The attack is the most significant escalation since January 2024.",
    content: <<~HTML
      <p>DUBAI — A Houthi anti-ship ballistic missile struck the Greek-flagged oil tanker Sounion in the southern Red Sea early Thursday, causing a significant crude oil spill and forcing the emergency evacuation of all 25 crew members.</p>
      <p>The attack, which occurred approximately 60 nautical miles from the Yemeni coast, is the most significant escalation in the Houthi campaign against commercial shipping since the crisis began in late 2023.</p>
      <p>Global shipping insurance rates for Red Sea transit surged 40% within hours. Major carriers Maersk and MSC have suspended all Red Sea transits indefinitely, rerouting vessels around the Cape of Good Hope — adding 10-14 days and approximately $1 million in fuel costs per voyage.</p>
      <p>The US Central Command confirmed that naval forces attempted to intercept the missile but were unable to engage it before impact. The Pentagon has not yet announced additional naval deployments to the region.</p>
    HTML
  },
  {
    headline: "Red Sea crisis pushes European inflation expectations to 18-month high",
    source_name: "Bloomberg",
    region_name: "Western Europe",
    country_iso: "DEU",
    topic: "Trade",
    sentiment: "Bearish",
    threat: 2,
    trust: 93,
    summary: "The escalating Red Sea shipping crisis has pushed European inflation swap rates to their highest level in 18 months, as supply chain disruptions from rerouted cargo begin hitting consumer prices. ECB economists estimate the shipping disruption will add 0.3-0.5 percentage points to eurozone inflation over the next quarter. Container freight rates from Asia to Europe have tripled since the Houthi campaign intensified, with the latest tanker strike threatening energy price stability.",
    content: <<~HTML
      <p>FRANKFURT — Europe's inflation outlook has deteriorated sharply as the Red Sea shipping crisis sends supply chain costs spiraling, with inflation swap rates hitting an 18-month high after the latest Houthi attack on an oil tanker.</p>
      <p>European Central Bank economists estimate that Red Sea-related shipping disruptions will add 0.3 to 0.5 percentage points to eurozone headline inflation over the coming quarter. Container freight rates from Asia to Europe have tripled since the Houthi campaign intensified, and the latest tanker strike threatens direct energy price impacts.</p>
      <p>"This is no longer a regional security issue — it's a direct threat to European price stability," said ECB Executive Board member Isabel Schnabel. The ECB may be forced to delay planned interest rate cuts if the disruption persists.</p>
    HTML
  },

  # ============================================================
  # STORYLINE 7: US Election Narrative War
  # ============================================================
  {
    headline: "FBI investigates coordinated deepfake campaign targeting US midterm candidates",
    source_name: "CNN",
    region_name: "North America",
    country_iso: "USA",
    topic: "Cyber",
    sentiment: "Bearish",
    threat: 2,
    trust: 80,
    summary: "The FBI has opened an investigation into a coordinated deepfake campaign that produced synthetic video and audio of midterm election candidates in 12 swing states. The deepfakes, which showed candidates making inflammatory statements they never made, were distributed through a network of thousands of bot accounts across social media platforms. Meta and X have removed over 40,000 accounts linked to the operation. Technical analysis suggests the content was generated using military-grade AI models not publicly available.",
    content: <<~HTML
      <p>WASHINGTON — The FBI has launched a major investigation into a coordinated deepfake campaign targeting midterm election candidates across 12 swing states, marking what officials describe as the most sophisticated AI-driven election interference operation ever detected on US soil.</p>
      <p>The campaign produced synthetic video and audio depicting candidates making inflammatory statements about immigration, Social Security, and military spending — statements they never made. The content was distributed through a network of over 40,000 bot accounts across Meta, X, and TikTok platforms.</p>
      <p>"The quality of these deepfakes exceeds anything we've seen in the commercial AI space," said FBI Cyber Division Assistant Director Bryan Vorndran. "The models used to generate this content are not publicly available, which strongly suggests state-level resources."</p>
    HTML
  },
  {
    headline: "Conservative media outlets amplify unverified claims of 'ballot harvesting' in Arizona",
    source_name: "New York Times",
    region_name: "North America",
    country_iso: "USA",
    topic: "Cyber",
    sentiment: "Bearish",
    threat: 2,
    trust: 86,
    summary: "Multiple conservative media outlets have amplified unverified claims of organized ballot harvesting in Maricopa County, Arizona, based on a single anonymous source. The claims have been shared over 2 million times on social media despite being denied by both Republican and Democratic election officials. VERITAS analysis identifies this as a narrative amplification pattern consistent with coordinated information operations, with the story originating from a single Telegram channel before migrating to mainstream outlets within 48 hours.",
    content: <<~HTML
      <p>NEW YORK — Multiple conservative media outlets have amplified claims of organized ballot harvesting in Maricopa County, Arizona, based on a single anonymous source and unverified video footage that election security experts say is inconclusive.</p>
      <p>The narrative, which originated on a Telegram channel with ties to the QAnon ecosystem before migrating to Breitbart and then Fox News within 48 hours, has been shared over 2 million times despite categorical denials from both Republican and Democratic election officials in Arizona.</p>
      <p>"We've reviewed every piece of evidence cited in these reports. None of it substantiates the claims being made," said Maricopa County Recorder Stephen Richer, a Republican. "This is narrative manufacturing, not journalism."</p>
      <p>Media researchers at the Stanford Internet Observatory have identified the propagation pattern as consistent with coordinated information operations, noting identical phrasing across ostensibly independent outlets.</p>
    HTML
  },
  {
    headline: "Russia-linked troll farms target both left and right in US election chaos strategy",
    source_name: "Washington Post",
    region_name: "North America",
    country_iso: "USA",
    topic: "Cyber",
    sentiment: "Bearish",
    threat: 3,
    trust: 85,
    summary: "A joint NSA-CISA investigation has uncovered a Russian information operation targeting both progressive and conservative Americans simultaneously, using AI-generated content to inflame divisions on immigration, gun control, and racial justice. The operation, linked to the Internet Research Agency's successor organization, creates mirror-image outrage content for each political camp. The goal is not to support either side but to maximize polarization and erode trust in democratic institutions.",
    content: <<~HTML
      <p>WASHINGTON — A joint investigation by the NSA and Cybersecurity and Infrastructure Security Agency has uncovered a sophisticated Russian information operation that simultaneously targets both progressive and conservative Americans, using AI-generated content to inflame divisions on both sides.</p>
      <p>The operation, linked to the Internet Research Agency's successor organization "Patriot Media," creates mirror-image outrage content: inflammatory far-left content designed to provoke conservatives, and inflammatory far-right content designed to provoke liberals.</p>
      <p>"The goal isn't to get any candidate elected. The goal is to make Americans hate each other so much that democracy itself becomes unworkable," said a senior CISA official. "They're farming outrage, not votes."</p>
      <p>The investigation found that the operation used Claude-class language models fine-tuned on American political rhetoric to generate thousands of pieces of partisan content daily.</p>
    HTML
  },

  # ============================================================
  # STORYLINE 8: BRICS Currency Challenge
  # ============================================================
  {
    headline: "BRICS summit announces digital trade settlement system to bypass US dollar",
    source_name: "Al Jazeera",
    region_name: "South Asia",
    country_iso: "IND",
    topic: "Diplomacy",
    sentiment: "Bullish",
    threat: 1,
    trust: 76,
    summary: "The expanded BRICS bloc has announced a blockchain-based digital trade settlement system designed to enable member nations to conduct bilateral trade without converting to US dollars. The system, dubbed 'BRICS Bridge,' will initially cover energy and commodity transactions between China, Russia, India, Brazil, and Saudi Arabia. While economists debate whether this truly threatens dollar hegemony, the political symbolism represents the most concrete challenge to the dollar-dominated financial system in decades.",
    content: <<~HTML
      <p>DOHA — The expanded BRICS bloc has unveiled its most ambitious challenge to Western financial hegemony: a blockchain-based digital settlement system that would allow member nations to trade commodities and energy without converting to US dollars.</p>
      <p>The system, dubbed "BRICS Bridge," was announced at an extraordinary summit in Doha attended by leaders of the bloc's 11 member nations. Initial implementation will cover energy transactions between Saudi Arabia and China, and agricultural commodity trade between Brazil and India.</p>
      <p>"This is not about destroying the dollar. This is about having options," said Indian Finance Minister Nirmala Sitharaman. "No single currency should have veto power over global trade."</p>
      <p>US Treasury Secretary Janet Yellen dismissed the initiative as "technically interesting but economically insignificant," noting that 88% of global foreign exchange transactions still involve the dollar.</p>
    HTML
  },
  {
    headline: "Dollar surges as markets shrug off BRICS currency threat",
    source_name: "Bloomberg",
    region_name: "North America",
    country_iso: "USA",
    topic: "Trade",
    sentiment: "Bullish",
    threat: 1,
    trust: 93,
    summary: "The US dollar strengthened against all major currencies following the BRICS Bridge announcement, as currency traders assessed the system as technically premature and politically fragmented. Goldman Sachs estimates the system could handle less than 2% of global trade volume by 2030. Analysts note that BRICS members themselves remain deeply divided — India and China have unresolved border disputes, and Saudi Arabia continues to price oil in dollars despite joining the bloc.",
    content: <<~HTML
      <p>NEW YORK — The US dollar index rose 0.8% against a basket of major currencies on Thursday as foreign exchange markets delivered their verdict on the BRICS Bridge announcement: too little, too late.</p>
      <p>"The dollar's dominance isn't a policy choice — it's a reflection of deep, liquid capital markets, rule of law, and the full faith and credit of the US government," said Goldman Sachs chief FX strategist Kamakshya Trivedi. "A blockchain ledger doesn't replicate any of that."</p>
      <p>Goldman estimates BRICS Bridge could handle less than 2% of global trade volume by 2030, even under optimistic adoption scenarios. The firm notes that BRICS members themselves remain deeply divided — India and China have unresolved border conflicts, while Saudi Arabia continues to price its benchmark crude in dollars.</p>
    HTML
  },
  {
    headline: "Russia hails BRICS payment system as 'beginning of the end' for dollar dominance",
    source_name: "Sputnik",
    region_name: "Eastern Europe",
    country_iso: "RUS",
    topic: "Diplomacy",
    sentiment: "Bullish",
    threat: 1,
    trust: 32,
    summary: "Russian state media has celebrated the BRICS Bridge announcement as a historic blow to American financial hegemony. President Putin described the system as 'inevitable progress' that will free developing nations from 'dollar slavery.' Russian economists on state television claim the dollar will lose its reserve status within a decade. Western economists note that Russia has the strongest motivation to promote de-dollarization due to sanctions, making its enthusiasm self-serving rather than analytical.",
    content: <<~HTML
      <p>MOSCOW — Russian President Vladimir Putin has hailed the BRICS Bridge digital settlement system as "the beginning of the end for dollar tyranny" and evidence that the Western-dominated financial order is crumbling.</p>
      <p>"For decades, Washington has weaponized the dollar to punish countries that refuse to submit to its foreign policy demands. That era is ending," Putin said in a televised address following the BRICS summit.</p>
      <p>Russian state economists appearing on Channel One predicted the dollar would lose its reserve currency status within a decade, replaced by a multipolar basket of BRICS currencies and digital settlement mechanisms.</p>
      <p>Western analysts note that Russia, as the most heavily sanctioned major economy, has the strongest incentive to promote dollar alternatives — making its bullish assessments more aspirational than analytical.</p>
    HTML
  },

  # ============================================================
  # ADDITIONAL CROSS-CUTTING ARTICLES
  # ============================================================
  {
    headline: "Pentagon warns of 'simultaneous crises' stretching US military capacity",
    source_name: "Associated Press",
    region_name: "North America",
    country_iso: "USA",
    topic: "Military",
    sentiment: "Bearish",
    threat: 3,
    trust: 89,
    summary: "A classified Pentagon assessment leaked to the Associated Press warns that simultaneous escalation in the Black Sea, Taiwan Strait, Red Sea, and Middle East is stretching US military capacity to its operational limit. The document recommends prioritization frameworks that would force difficult tradeoffs between European and Indo-Pacific commitments. Joint Chiefs Chair warns Congress that the military cannot sustain four-theater readiness without emergency supplemental funding.",
    content: <<~HTML
      <p>WASHINGTON — A classified Pentagon assessment warns that the United States military is being stretched to its operational limits by simultaneous escalation across four theaters: the Black Sea, the Taiwan Strait, the Red Sea, and the broader Middle East.</p>
      <p>The document, portions of which were described to the Associated Press by three defense officials, recommends developing prioritization frameworks that would force difficult tradeoffs between European and Indo-Pacific defense commitments.</p>
      <p>"We cannot be everywhere at once with the force structure we have," Joint Chiefs Chairman Admiral Christopher Grady told the Senate Armed Services Committee in closed testimony. "The math doesn't work."</p>
      <p>The assessment recommends emergency supplemental funding of $38 billion to sustain readiness across all four theaters through the end of the fiscal year.</p>
    HTML
  },
  {
    headline: "Global arms spending hits record $2.7 trillion as multiple conflicts simmer",
    source_name: "The Guardian",
    region_name: "Western Europe",
    country_iso: "GBR",
    topic: "Military",
    sentiment: "Bearish",
    threat: 2,
    trust: 84,
    summary: "Global military expenditure has reached a record $2.7 trillion, driven by the Ukraine war, Middle East instability, and the AI arms race. SIPRI data shows the largest year-over-year increase since the Cold War. European defense spending has surged 15% as nations rush to meet NATO's 2% GDP target. The arms industry is experiencing unprecedented demand that is reshaping global industrial policy and crowding out social spending in developing nations.",
    content: <<~HTML
      <p>LONDON — Global military spending reached a record $2.7 trillion in 2025, according to new data from the Stockholm International Peace Research Institute, marking the largest year-over-year increase since the final years of the Cold War.</p>
      <p>The surge is driven by the ongoing war in Ukraine, escalating tensions in the Middle East and Indo-Pacific, and a new AI arms race that has every major military power rushing to integrate artificial intelligence into weapons systems.</p>
      <p>European defense spending increased 15% year-over-year as NATO members scramble to meet the alliance's 2% GDP target. Germany alone increased military spending by €22 billion, its largest defense budget increase since reunification.</p>
      <p>"We are in a new era of great-power competition, and the spending reflects that reality," said SIPRI director Dan Smith. "The question is whether this spending makes the world safer or just more armed."</p>
    HTML
  },
  {
    headline: "India plays both sides as neutral broker amid global power fractures",
    source_name: "The Hindu",
    region_name: "South Asia",
    country_iso: "IND",
    topic: "Diplomacy",
    sentiment: "Neutral",
    threat: 1,
    trust: 75,
    summary: "India continues to maintain strategic relationships with both Western and BRICS blocs, purchasing discounted Russian oil while deepening defense ties with the United States. Prime Minister Modi has positioned India as an indispensable neutral broker, hosting back-channel talks between Iran and the US while participating in both BRICS Bridge and the Indo-Pacific Economic Framework. Analysts describe India's strategy as 'multi-alignment' — a deliberate refusal to choose sides in the emerging bipolar order.",
    content: <<~HTML
      <p>NEW DELHI — As the world fractures into competing power blocs, India has positioned itself as the indispensable neutral party — maintaining deep relationships with all sides while committing fully to none.</p>
      <p>In the span of a single week, Prime Minister Narendra Modi hosted Iranian Foreign Minister Amir-Abdollahian for back-channel nuclear discussions, signed a $3 billion defense cooperation agreement with the United States, and championed the BRICS Bridge payment system in Doha.</p>
      <p>"India's strategy is not non-alignment — it's multi-alignment," said C. Raja Mohan, a leading Indian foreign policy scholar. "Delhi wants maximum options and minimum obligations. So far, it's working."</p>
      <p>The approach has frustrated both Washington and Beijing, but neither can afford to alienate a market of 1.4 billion people and the world's fifth-largest economy.</p>
    HTML
  },
  {
    headline: "AI-generated propaganda now accounts for 37% of conflict-zone disinformation",
    source_name: "Reuters",
    region_name: "Western Europe",
    country_iso: "GBR",
    topic: "Cyber",
    sentiment: "Bearish",
    threat: 2,
    trust: 90,
    summary: "A comprehensive study by the Oxford Internet Institute finds that AI-generated text, images, and video now account for 37% of all disinformation detected in active conflict zones — up from 8% just two years ago. The study analyzed 4 million social media posts related to the Ukraine, Gaza, and Sahel conflicts. Researchers warn that detection tools are falling behind generation capabilities, creating an 'authenticity gap' that threatens public trust in all digital media.",
    content: <<~HTML
      <p>OXFORD — Artificial intelligence-generated propaganda now accounts for 37% of all disinformation detected in active conflict zones, according to a comprehensive study published by the Oxford Internet Institute — a dramatic increase from just 8% two years ago.</p>
      <p>The study analyzed over 4 million social media posts related to the Ukraine, Gaza, and Sahel conflicts, using both automated detection tools and human expert review. AI-generated content was found across all major platforms, with Telegram and TikTok showing the highest concentrations.</p>
      <p>"The democratization of generative AI has handed every state actor, militia, and political operative a propaganda factory that runs 24/7 at near-zero cost," said lead researcher Dr. Philip Howard. "Detection tools are falling behind. We're losing the arms race."</p>
      <p>The study recommends mandatory content provenance standards and international regulation of AI model access as urgent countermeasures.</p>
    HTML
  },
  {
    headline: "Erdogan offers to mediate Black Sea crisis, positions Turkey as regional kingmaker",
    source_name: "Al Jazeera",
    region_name: "Middle East",
    country_iso: "TUR",
    topic: "Diplomacy",
    sentiment: "Bullish",
    threat: 2,
    trust: 73,
    summary: "Turkish President Erdogan has offered to mediate between NATO and Russia over the Black Sea standoff, leveraging Turkey's unique position as both a NATO member and a country maintaining functional relations with Moscow. Erdogan proposes a 72-hour cooling-off period with all warships withdrawing to their home ports. The offer reinforces Turkey's self-image as an indispensable regional broker, though Western allies question Ankara's neutrality given its purchase of Russian S-400 missiles.",
    content: <<~HTML
      <p>ANKARA — Turkish President Recep Tayyip Erdogan has offered to mediate between NATO and Russia over the Black Sea naval standoff, proposing a 72-hour cooling-off period during which all warships would withdraw to their home ports.</p>
      <p>"Turkey is the only country in the world that can talk to both sides," Erdogan told reporters. "We proved it with the grain deal, and we can do it again."</p>
      <p>Turkey's unique position as a NATO member with functional diplomatic and economic relations with Russia gives Erdogan genuine leverage, though Western allies remain skeptical of Ankara's neutrality given its purchase of Russian S-400 missile defense systems.</p>
      <p>The Kremlin responded cautiously, saying it would "consider" the proposal while emphasizing that NATO must first withdraw its vessels from the Black Sea entirely.</p>
    HTML
  },
  {
    headline: "North Korea tests submarine-launched ballistic missile amid Taiwan crisis distraction",
    source_name: "Associated Press",
    region_name: "East Asia",
    country_iso: "PRK",
    topic: "Military",
    sentiment: "Bearish",
    threat: 3,
    trust: 88,
    summary: "North Korea has conducted a submarine-launched ballistic missile test in the Sea of Japan while global attention is focused on the Black Sea and Taiwan crises. The missile flew approximately 600km before landing in Japan's exclusive economic zone. Analysts warn that Pyongyang is exploiting the distraction of multiple simultaneous crises to advance its nuclear delivery capabilities with reduced international scrutiny. Japan has lodged a formal protest and requested an emergency UN Security Council session.",
    content: <<~HTML
      <p>TOKYO — North Korea has test-fired a submarine-launched ballistic missile into the Sea of Japan while global attention is consumed by simultaneous crises in the Black Sea, Taiwan Strait, and Middle East.</p>
      <p>The missile, launched from the Sinpo-class submarine, flew approximately 600 kilometers before landing in Japan's exclusive economic zone. Japanese Prime Minister Ishiba called the test "an unacceptable provocation" and requested an emergency UN Security Council session.</p>
      <p>"Pyongyang is exploiting the distraction," said Ankit Panda, a nuclear weapons analyst at the Carnegie Endowment. "Every crisis that divides international attention is an opportunity for Kim Jong Un to advance his program with less scrutiny."</p>
      <p>The test marks North Korea's first confirmed submarine launch capability, significantly complicating the calculus for missile defense systems designed to track land-based launch sites.</p>
    HTML
  },
  {
    headline: "Venezuelan opposition claims election fraud as Maduro declares landslide victory",
    source_name: "CNN",
    region_name: "South America",
    country_iso: "VEN",
    topic: "Diplomacy",
    sentiment: "Bearish",
    threat: 2,
    trust: 79,
    summary: "Venezuela's opposition has rejected President Maduro's claimed landslide re-election victory, presenting independent exit polls showing the opposition winning by a 30-point margin. International election monitors from the EU and OAS were barred from the country. The Carter Center's limited observer mission described 'serious irregularities' in vote tabulation. Mass protests have erupted in Caracas, with security forces deploying tear gas. The US and EU have refused to recognize the results pending an independent audit.",
    content: <<~HTML
      <p>CARACAS — Venezuela's opposition has rejected President Nicolás Maduro's claimed landslide re-election victory, presenting independent exit poll data that shows opposition candidate María Corina Machado winning by a margin of over 30 percentage points.</p>
      <p>The National Electoral Council, controlled by Maduro loyalists, declared the incumbent the winner with 67% of the vote — a result that independent pollsters say is statistically impossible given pre-election surveys.</p>
      <p>International election monitors from the EU and Organization of American States were barred from the country. The Carter Center's limited observer mission described "serious irregularities" in vote tabulation processes.</p>
      <p>Mass protests have erupted across Caracas, with security forces deploying tear gas and rubber bullets against demonstrators. The US and EU have refused to recognize the results pending an independent audit of voting records.</p>
    HTML
  },
  {
    headline: "Chinese military conducts 'reunification readiness' drills around Taiwan",
    source_name: "Xinhua",
    region_name: "East Asia",
    country_iso: "CHN",
    topic: "Military",
    sentiment: "Neutral",
    threat: 3,
    trust: 48,
    summary: "The People's Liberation Army has launched large-scale military exercises encircling Taiwan, including live-fire drills, amphibious landing rehearsals, and electronic warfare operations. Xinhua characterizes the exercises as a 'legitimate and necessary response to provocative separatist activities.' The PLA Eastern Theater Command reports 71 aircraft and 14 naval vessels participated. Taiwan's Ministry of Defense has raised its alert level and scrambled fighter jets. Analysts note these are the largest exercises since August 2022.",
    content: <<~HTML
      <p>BEIJING — The People's Liberation Army has launched comprehensive military exercises around Taiwan, demonstrating China's capabilities for what state media describes as "reunification readiness operations."</p>
      <p>The exercises, conducted by the PLA Eastern Theater Command, involved 71 aircraft including J-20 stealth fighters, 14 naval vessels, and conventional missile forces. Live-fire drills were conducted in six designated zones encircling the island, effectively simulating a naval and air blockade.</p>
      <p>"These exercises are a legitimate and necessary response to the provocative separatist activities of Taiwan independence forces and the external forces that enable them," said PLA spokesperson Senior Colonel Shi Yi.</p>
      <p>Taiwan's Ministry of Defense reported detecting the exercises at 06:00 local time and scrambled combat air patrols in response. President Lai Ching-te convened an emergency national security council meeting.</p>
    HTML
  },
  {
    headline: "Taiwan condemns 'military intimidation' as PLA exercises encircle island",
    source_name: "BBC",
    region_name: "East Asia",
    country_iso: "TWN",
    topic: "Military",
    sentiment: "Bearish",
    threat: 3,
    trust: 86,
    summary: "Taiwan's President Lai has condemned the PLA military exercises as 'unprovoked intimidation' and called for international solidarity. Taiwan's military reports that PLA aircraft crossed the median line of the Taiwan Strait 47 times in 24 hours. The exercises have disrupted commercial shipping and aviation routes. The US State Department has called the drills 'destabilizing' while carefully avoiding language that might commit Washington to military intervention under the Taiwan Relations Act.",
    content: <<~HTML
      <p>TAIPEI — Taiwan's President Lai Ching-te has condemned the People's Liberation Army's encirclement exercises as "unprovoked military intimidation" and called on the international community to stand against authoritarian coercion.</p>
      <p>"Taiwan is a democracy of 23 million people. We will not be bullied into submission," Lai said in an emergency address. Taiwan's military reports that PLA aircraft crossed the median line of the Taiwan Strait 47 times in a 24-hour period — a record.</p>
      <p>The exercises have disrupted commercial shipping lanes and forced the rerouting of over 200 civilian flights. Japan, the Philippines, and Australia have issued statements of concern.</p>
      <p>The US State Department called the drills "destabilizing and unnecessary" but carefully avoided language that might commit Washington to military intervention, maintaining the strategic ambiguity of the Taiwan Relations Act.</p>
    HTML
  },
  {
    headline: "Pakistan accuses India of cross-border cyber surveillance operation",
    source_name: "Dawn",
    region_name: "South Asia",
    country_iso: "PAK",
    topic: "Cyber",
    sentiment: "Bearish",
    threat: 2,
    trust: 65,
    summary: "Pakistan's intelligence agency ISI has accused India's Research and Analysis Wing (RAW) of conducting a large-scale cyber surveillance operation targeting Pakistani military communications, government officials, and nuclear facility networks. The allegations are based on malware samples recovered from compromised systems that Pakistan claims contain code signatures linked to known Indian APT groups. India has denied the allegations. Cybersecurity experts note that attribution in South Asian cyber operations is notoriously difficult due to shared infrastructure and language overlap.",
    content: <<~HTML
      <p>ISLAMABAD — Pakistan's Inter-Services Intelligence agency has accused India's Research and Analysis Wing of conducting a sweeping cyber surveillance operation targeting Pakistani military communications, government networks, and nuclear facility control systems.</p>
      <p>The allegations, presented at a closed briefing for Pakistani lawmakers, are based on malware samples recovered from compromised systems. Pakistani cybersecurity analysts claim the code contains signatures linked to "SideWinder," an advanced persistent threat group widely attributed to Indian intelligence.</p>
      <p>India's Ministry of External Affairs dismissed the allegations as "baseless fabrications designed to distract from Pakistan's own internal security failures."</p>
      <p>Independent cybersecurity researchers note that attribution in South Asian cyber operations is exceptionally difficult due to shared linguistic and infrastructure characteristics between Indian and Pakistani networks.</p>
    HTML
  },
  {
    headline: "Egyptian fuel crisis deepens as Red Sea disruptions cut LNG shipments",
    source_name: "Al Jazeera",
    region_name: "Africa",
    country_iso: "EGY",
    topic: "Trade",
    sentiment: "Bearish",
    threat: 2,
    trust: 74,
    summary: "Egypt is facing severe fuel shortages as Red Sea shipping disruptions have cut liquefied natural gas imports by 60%. Power blackouts lasting 6-8 hours daily have become routine in Cairo and Alexandria. The crisis is compounded by declining Suez Canal revenues as shipping reroutes around the Cape of Good Hope. Egypt's economy, already strained by IMF austerity requirements, faces a potential humanitarian crisis if fuel supplies are not restored within weeks.",
    content: <<~HTML
      <p>CAIRO — Egypt is facing its worst fuel crisis in a decade as Red Sea shipping disruptions have slashed liquefied natural gas imports by 60%, triggering daily power blackouts across the country's major cities.</p>
      <p>Residents in Cairo and Alexandria report electricity cuts lasting 6-8 hours daily, crippling businesses and overwhelming hospitals that rely on backup generators with limited fuel supplies.</p>
      <p>The crisis is compounded by a 45% decline in Suez Canal transit revenues as global shipping reroutes around the Cape of Good Hope to avoid Houthi attacks. The canal, which generated $9.4 billion in revenue last year, is a critical source of foreign currency for Egypt's debt-strained economy.</p>
      <p>"Egypt is caught in a vicious circle," said economist Hanan Ramses. "The Red Sea crisis cuts our fuel imports AND our canal revenue simultaneously. We're running out of options."</p>
    HTML
  },
  {
    headline: "Climate activists target AI data centers as 'new coal plants' in European protests",
    source_name: "The Guardian",
    region_name: "Western Europe",
    country_iso: "NLD",
    topic: "Trade",
    sentiment: "Neutral",
    threat: 1,
    trust: 82,
    summary: "Climate activists have launched coordinated protests against AI data center construction in the Netherlands, Ireland, and Sweden, arguing that the energy demands of large language models and military AI systems are undermining European climate commitments. Protesters blocked construction at a proposed Microsoft facility near Amsterdam that would consume as much electricity as 100,000 homes. The movement connects the AI arms race to environmental destruction, creating an unexpected political coalition between climate and peace movements.",
    content: <<~HTML
      <p>AMSTERDAM — Climate activists have launched coordinated protests against AI data center construction across Europe, targeting facilities in the Netherlands, Ireland, and Sweden that they call "the new coal plants."</p>
      <p>Hundreds of protesters blocked construction at a proposed Microsoft AI facility near Amsterdam that would consume as much electricity as 100,000 Dutch homes. Similar actions targeted Meta's data center expansion in Ireland and a planned Google facility in Sweden.</p>
      <p>"The AI arms race is an environmental catastrophe hiding behind a veneer of innovation," said protest organizer Luisa Neubauer. "These models consume obscene amounts of energy to generate content that is then weaponized for disinformation. We're burning the planet to power the propaganda machine."</p>
    HTML
  },
  {
    headline: "IMF warns global economy faces 'polycrisis' as simultaneous shocks compound",
    source_name: "Financial Times",
    region_name: "North America",
    country_iso: "USA",
    topic: "Trade",
    sentiment: "Bearish",
    threat: 2,
    trust: 94,
    summary: "The IMF has issued a special stability assessment warning that the simultaneous occurrence of the Black Sea standoff, Red Sea shipping crisis, Taiwan tensions, Iran nuclear escalation, and the AI chip trade war creates compounding economic risks that exceed the sum of their individual impacts. The fund has downgraded global growth forecasts by 0.7 percentage points and warned of a potential 'polycrisis' scenario where cascading failures across trade, energy, and financial systems trigger a synchronized global recession.",
    content: <<~HTML
      <p>WASHINGTON — The International Monetary Fund has issued an extraordinary special stability assessment warning that the world faces a "polycrisis" — multiple simultaneous shocks whose compounding effects far exceed their individual impacts.</p>
      <p>The assessment, presented to the IMF Executive Board this week, identifies five concurrent disruptions: the Black Sea military standoff, Red Sea shipping crisis, Taiwan Strait tensions, Iran nuclear escalation, and the US-China AI chip trade war.</p>
      <p>"Each of these crises alone would be manageable. Together, they create cascading risks across trade, energy, finance, and food systems that could trigger a synchronized global recession," said IMF Managing Director Kristalina Georgieva.</p>
      <p>The fund has downgraded its global growth forecast by 0.7 percentage points — the largest single revision since the COVID-19 pandemic — and urged central banks to maintain emergency liquidity facilities.</p>
    HTML
  },
  {
    headline: "WHO declares disease outbreak in Sudan conflict zone as humanitarian access collapses",
    source_name: "BBC",
    region_name: "Africa",
    country_iso: "ETH",
    topic: "Diplomacy",
    sentiment: "Bearish",
    threat: 3,
    trust: 86,
    summary: "The WHO has declared a cholera and measles emergency in Sudan's Darfur region as the civil war has destroyed health infrastructure and blocked humanitarian access. Over 8 million people have been displaced and an estimated 25,000 have died from conflict and disease. The crisis has been overshadowed by higher-profile geopolitical tensions, with international media dedicating minimal coverage. UN officials describe it as the world's largest humanitarian catastrophe, yet one of its least reported.",
    content: <<~HTML
      <p>GENEVA — The World Health Organization has declared a public health emergency in Sudan's Darfur region as overlapping cholera and measles outbreaks spread through displacement camps housing millions of civilians trapped by the ongoing civil war.</p>
      <p>"This is the world's largest humanitarian catastrophe, and yet it receives a fraction of the attention given to other crises," said WHO Director-General Tedros Adhanom Ghebreyesus. "Over 8 million people have been displaced. An estimated 25,000 have died. And we cannot reach them."</p>
      <p>Both the Sudanese Armed Forces and the Rapid Support Forces have blocked humanitarian convoys, using starvation as a weapon of war. The UN estimates that 18 million Sudanese — one-third of the population — face acute food insecurity.</p>
      <p>The crisis has been overshadowed by the Black Sea standoff, Iran nuclear tensions, and Taiwan military exercises, prompting aid organizations to plead for international attention and funding.</p>
    HTML
  },
  {
    headline: "Philippines confronts Chinese maritime militia in disputed South China Sea shoal",
    source_name: "Associated Press",
    region_name: "Southeast Asia",
    country_iso: "PHL",
    topic: "Military",
    sentiment: "Bearish",
    threat: 2,
    trust: 87,
    summary: "Philippine Coast Guard vessels confronted a flotilla of 40 Chinese maritime militia boats near Second Thomas Shoal in the South China Sea, with Chinese vessels using water cannons and blocking maneuvers to prevent a resupply mission to a Philippine military outpost. The confrontation, captured on video by Philippine media, represents the most direct physical altercation between the two nations this year. The US has reiterated that its mutual defense treaty with the Philippines covers incidents in the South China Sea.",
    content: <<~HTML
      <p>MANILA — Philippine Coast Guard vessels confronted a flotilla of approximately 40 Chinese maritime militia boats near Second Thomas Shoal on Wednesday, in the most heated physical altercation between the two nations in the disputed South China Sea this year.</p>
      <p>Video footage released by Philippine media shows Chinese vessels using industrial water cannons against Philippine supply boats attempting to deliver food and medicine to a military outpost on the shoal. At least two Philippine crew members were injured.</p>
      <p>"This is Philippine sovereign territory, affirmed by international law," said Coast Guard spokesman Commodore Jay Tarriela. "We will not be driven away by bully tactics."</p>
      <p>China claims the shoal as part of its expansive Nine-Dash Line territorial claim, which was rejected by an international tribunal in 2016. The US State Department reiterated that its mutual defense treaty with the Philippines covers incidents in the South China Sea.</p>
    HTML
  },
  {
    headline: "Global food prices hit 3-year high as conflict zones disrupt grain and fertilizer trade",
    source_name: "Reuters",
    region_name: "Western Europe",
    country_iso: "FRA",
    topic: "Trade",
    sentiment: "Bearish",
    threat: 2,
    trust: 91,
    summary: "The FAO Food Price Index has reached its highest level in three years, driven by simultaneous disruptions to Black Sea grain exports, Red Sea shipping routes, and fertilizer supply chains. Wheat futures have surged 28% since the Black Sea naval standoff began. The World Food Programme warns that 45 countries face acute food insecurity, with sub-Saharan Africa and South Asia most vulnerable. The convergence of military conflicts with trade disruptions is creating a food security crisis that mirrors 2022 levels.",
    content: <<~HTML
      <p>ROME — Global food prices have reached their highest level in three years as simultaneous military conflicts disrupt the world's most critical agricultural trade routes, according to the UN Food and Agriculture Organization's latest monthly index.</p>
      <p>The FAO Food Price Index rose 12% month-over-month, driven by a 28% surge in wheat futures since the Black Sea naval standoff restricted Ukrainian grain exports. Rice prices have increased 15% as Red Sea shipping disruptions force Asian exporters to reroute through longer, more expensive corridors.</p>
      <p>"We are seeing a convergence of military, trade, and climate disruptions that is creating a food security crisis comparable to 2022," said FAO Director-General QU Dongyu. The World Food Programme warns that 45 countries now face acute food insecurity, with sub-Saharan Africa and South Asia most vulnerable.</p>
    HTML
  },
  {
    headline: "Brazil proposes UN 'peace framework' as Global South frustration with great powers grows",
    source_name: "Folha de S.Paulo",
    region_name: "South America",
    country_iso: "BRA",
    topic: "Diplomacy",
    sentiment: "Bullish",
    threat: 1,
    trust: 72,
    summary: "Brazilian President Lula has proposed a UN 'Global Peace Framework' that would require Security Council permanent members to submit to mandatory mediation before any military deployment. The proposal, backed by India, South Africa, and Indonesia, reflects growing frustration among Global South nations with a world order where great powers escalate conflicts while developing nations bear the economic consequences. Western diplomats dismiss the framework as unrealistic but acknowledge the political sentiment behind it is gaining momentum.",
    content: <<~HTML
      <p>BRASÍLIA — Brazilian President Luiz Inácio Lula da Silva has proposed a sweeping UN "Global Peace Framework" that would require Security Council permanent members to submit to mandatory third-party mediation before conducting military operations beyond their borders.</p>
      <p>"The Global South is tired of paying the price for wars we did not start and cannot stop," Lula said at the UN General Assembly special session. "When great powers play chess, it is our people who are the pawns."</p>
      <p>The proposal has gained support from India, South Africa, Indonesia, and Mexico, reflecting deep frustration among developing nations that bear the economic fallout of great-power conflicts through food inflation, energy shocks, and trade disruptions.</p>
      <p>Western diplomats privately dismiss the framework as unrealistic given the veto structure of the Security Council, but acknowledge that the political sentiment driving it is increasingly difficult to ignore.</p>
    HTML
  },
  {
    headline: "Interpol warns of 'industrial-scale' passport fraud linked to conflict zone displacement",
    source_name: "Le Monde",
    region_name: "Western Europe",
    country_iso: "FRA",
    topic: "Cyber",
    sentiment: "Bearish",
    threat: 2,
    trust: 81,
    summary: "Interpol has issued a global alert warning of industrial-scale passport and identity document fraud linked to mass displacement from conflict zones in Sudan, Ukraine, and the Middle East. Criminal networks are exploiting destroyed civil registries to create authentic-seeming documents for human trafficking and terrorist travel. Over 12,000 fraudulent documents have been intercepted at European borders in the past quarter. Interpol's Secretary General warns that the collapse of state infrastructure in conflict zones is creating identity vacuums that organized crime is rapidly filling.",
    content: <<~HTML
      <p>LYON — Interpol has issued a global orange notice warning of "industrial-scale" passport and identity document fraud linked to mass displacement from conflict zones in Sudan, Ukraine, and the Middle East.</p>
      <p>Criminal networks are exploiting destroyed civil registries and collapsed government institutions to create fraudulent identity documents that are nearly indistinguishable from genuine ones. Over 12,000 fraudulent documents were intercepted at European borders in the past quarter alone.</p>
      <p>"When states collapse, identity systems collapse with them," said Interpol Secretary General Jürgen Stock. "Criminal organizations are filling the vacuum with industrial-scale document factories that serve everyone from human traffickers to terrorist networks."</p>
      <p>The alert recommends enhanced biometric screening and cross-border database integration, but acknowledges that many affected countries lack the infrastructure to implement such measures.</p>
    HTML
  }
].freeze

# ===========================================================================
# Pre-defined contradiction pairs (indices into DEMO_ARTICLES)
# These are hand-crafted to be dramatically compelling for demo purposes
# ===========================================================================
DEMO_CONTRADICTIONS = [
  {
    article_a_idx: 0,  # Reuters: NATO warships enter Black Sea
    article_b_idx: 1,  # RT: Russia claims NATO provocation
    contradiction_type: "cross_source",
    severity: 0.92,
    description: "Reuters reports NATO maintaining 90nm buffer from Crimea while RT claims vessels are encroaching on territorial waters. Satellite imagery confirms Reuters' account."
  },
  {
    article_a_idx: 3,  # AP: Satellite contradicts Russian claims
    article_b_idx: 1,  # RT: Russia claims NATO provocation
    contradiction_type: "cross_source",
    severity: 0.95,
    description: "Commercial satellite imagery directly contradicts Russian Defense Ministry claims about NATO proximity to Crimea. AP reports 90nm buffer; Russia claims territorial encroachment."
  },
  {
    article_a_idx: 6,  # Bloomberg: US expands chip ban
    article_b_idx: 7,  # Global Times: China retaliates
    contradiction_type: "cross_source",
    severity: 0.78,
    description: "Bloomberg frames chip restrictions as national security measure; Global Times frames identical actions as 'unilateral economic coercion.' Each side claims defensive posture."
  },
  {
    article_a_idx: 10, # Reuters: Iran talks collapse, 83% enrichment
    article_b_idx: 11, # Al Jazeera: Iran insists program is peaceful
    contradiction_type: "cross_source",
    severity: 0.91,
    description: "IAEA confirms 83.7% uranium enrichment at Fordow; Iran claims the reading is a 'technical anomaly from contamination.' Nuclear scientists say contamination explanation is inconsistent with particle distribution."
  },
  {
    article_a_idx: 15, # TASS: Russia denies port hack
    article_b_idx: 16, # WaPo: NSA traces attack to GRU
    contradiction_type: "cross_source",
    severity: 0.97,
    description: "Russia categorically denies involvement in European port cyberattack and suggests false flag; NSA attributes attack to GRU Unit 74455 (Sandworm) with high confidence based on C2 infrastructure overlap."
  },
  {
    article_a_idx: 24, # Bloomberg: Dollar surges, markets shrug off BRICS
    article_b_idx: 25, # Sputnik: Beginning of the end for dollar
    contradiction_type: "cross_source",
    severity: 0.88,
    description: "Bloomberg reports markets dismiss BRICS currency threat with dollar strengthening; Sputnik claims BRICS Bridge marks 'beginning of the end for dollar tyranny.' Diametrically opposed economic assessments."
  },
  {
    article_a_idx: 33, # Xinhua: PLA 'reunification readiness' drills
    article_b_idx: 34, # BBC: Taiwan condemns military intimidation
    contradiction_type: "cross_source",
    severity: 0.86,
    description: "Xinhua frames PLA exercises as 'legitimate response to separatist activities'; BBC reports Taiwan condemns them as 'unprovoked military intimidation.' Same event, opposite framing of aggressor."
  },
  {
    article_a_idx: 4,  # Xinhua: China urges restraint (omits Russia's role)
    article_b_idx: 2,  # BBC: Ukraine calls NATO presence 'long overdue'
    contradiction_type: "cross_source",
    severity: 0.72,
    description: "China frames NATO as the aggressor disrupting Black Sea stability; Ukraine frames NATO as a defensive necessity against Russian aggression. China's statement omits any mention of Russian attacks on civilian shipping."
  },
  {
    article_a_idx: 18, # Le Monde: Wagner doubles in Sahel
    article_b_idx: 19, # Nation Africa: AU defends Russian partnerships
    contradiction_type: "cross_source",
    severity: 0.68,
    description: "Le Monde reports 300% increase in civilian casualties in Wagner-controlled areas; African Union frames same Russian military partnerships as legitimate sovereign security choices."
  },
  {
    article_a_idx: 22, # CNN: FBI investigates deepfake campaign
    article_b_idx: 23, # NYT: Conservative media amplifies unverified claims
    contradiction_type: "temporal_shift",
    severity: 0.74,
    description: "Both articles document different vectors of election disinformation — one foreign (AI deepfakes), one domestic (narrative amplification). Together they reveal a multi-vector assault on election integrity from both external and internal sources."
  }
].freeze
