-- ============================================================
-- Mackelements.lua
-- Custom element definitions, descriptions, reactions, feeding, and a real Squeezer tool
-- Animal movement uses basic horizontal wandering; animal graphics remain single-particle.
-- ============================================================

local GROUP = "MACKELEMENTS"

local sections = {
    powder = elem.SC_POWDERS,
    liquid = elem.SC_LIQUID,
    solid = elem.SC_SOLIDS,
    gas = elem.SC_GAS,
    special = elem.SC_SPECIAL,
    tool = elem.SC_TOOL
}

local templates = {
    powder = elements.DEFAULT_PT_DUST,
    liquid = elements.DEFAULT_PT_WATR,
    solid = elements.DEFAULT_PT_METL,
    gas = elements.DEFAULT_PT_GAS,
    special = elements.DEFAULT_PT_DUST,
    tool = elements.DEFAULT_PT_DUST
}

-- Each entry is: {ID, ID, colour, category, description}
-- The first and second fields intentionally match, as requested.
local data = {
    {"SULF", "SULF", 0xE6D64A, "powder", "Sulfur (S): a yellow nonmetal found in minerals and living organisms. It is used in industry and in making some materials; this custom element is a powder template for material experiments, not a chemical-reaction simulation."},
    {"CARB", "CARB", 0x333333, "solid", "Carbon (C): an element found in charcoal, graphite, diamonds, and all known living things. Carbon materials have many uses, including pencils and filters; this custom version is a dark solid for comparing materials."},
    {"SALT", "SALT", 0xFFFFFF, "powder", "Table salt (sodium chloride, NaCl): a crystalline compound used to season and preserve food. It dissolves in water in real life; this custom powder does not automatically dissolve unless that behaviour is programmed."},
    {"IROX", "IROX", 0xB84A25, "powder", "Iron oxide: a family of compounds made from iron and oxygen, often responsible for red or brown colours in rust and minerals. Iron oxides are used in pigments and materials; this entry is a reddish powder representation."},
    {"SUCR", "SUCR", 0xF5F0D8, "powder", "Sucrose: common table sugar, a carbohydrate found naturally in many plants. It sweetens foods and dissolves in water in real life; this custom powder has no automatic dissolving behaviour unless added separately."},
    {"BICA", "BICA", 0xE8E8E8, "powder", "Sodium bicarbonate (NaHCO₃), often called baking soda: a white compound used in baking and household products. It can react with acids in real life; the custom powder only performs such reactions if they are coded."},
    {"WATR", "WATR", 0x204DFF, "liquid", "Water (H₂O): a liquid essential to life and widely used for cleaning, transport, and cooling. Its real-world freezing and boiling depend on temperature and pressure; this custom element currently uses the game’s water template."},
    {"ETHL", "ETHL", 0xB8D9FF, "liquid", "Ethanol (C₂H₅OH): an alcohol used in some sanitising products, laboratory work, and fuels. It is volatile and flammable in real life; this custom element is a liquid representation and does not model all of those properties automatically."},
    {"MERC", "MERC", 0xB8BEC7, "liquid", "Mercury (Hg): a dense, silvery metal that is liquid at ordinary room temperature. Mercury is toxic and requires specialised handling; this custom element is only a visual simulation and should not be confused with real mercury."},
    {"GLYC", "GLYC", 0xD9E8F2, "liquid", "Glycerol (glycerin): a colourless, viscous liquid used in soaps, cosmetics, medicines, and food products. Its thickness makes it useful for comparing liquid flow; the custom element does not guarantee realistic viscosity."},
    {"H2O2", "H2O2", 0xD8F0FF, "liquid", "Hydrogen peroxide (H₂O₂): a chemical used in appropriately formulated cleaning and bleaching products. Concentrated solutions can be hazardous; this custom liquid is educational only and does not simulate the compound’s full chemistry."},
    {"VOIL", "VOIL", 0xB8A23A, "liquid", "Vegetable oil: oil obtained from plants and commonly used in cooking and food production. It does not mix uniformly with water and is generally less dense than water; this custom liquid is for flow and mixture experiments."},
    {"OXYG", "OXYG", 0x70B9FF, "gas", "Oxygen (O₂): a colourless gas that organisms need for aerobic respiration and that supports combustion. Oxygen itself is not a fuel, but it can make fires burn more vigorously; the custom gas does not automatically reproduce these reactions."},
    {"NITR", "NITR", 0x9AB8E8, "gas", "Nitrogen (N₂): a colourless gas that makes up about 78% of Earth’s atmosphere. It is relatively unreactive under ordinary conditions and is used to provide inert atmospheres; this custom gas is a simplified representation."},
    {"CO2G", "CO2G", 0xA9A9A9, "gas", "Carbon dioxide (CO₂): a colourless gas released by respiration and many combustion processes. Plants use it during photosynthesis, and it is used in carbonation and fire-suppression systems; this custom gas does not model these processes by itself."},
    {"HELI", "HELI", 0xFFF0B5, "gas", "Helium (He): a very light, nonflammable noble gas used in scientific equipment, leak detection, and some balloons. It is chemically unreactive under ordinary conditions; this custom gas is for gas-behaviour experiments."},
    {"ARGO", "ARGO", 0xC4C9E8, "gas", "Argon (Ar): a colourless noble gas that forms just under 1% of Earth’s atmosphere. It is used in some welding and manufacturing processes to reduce unwanted reactions; this custom element does not create an inert atmosphere automatically."},
    {"NEON", "NEON", 0xFF8B55, "gas", "Neon (Ne): a noble gas that can glow reddish-orange in a suitable electrical discharge tube. It is used in some illuminated signs and specialist lighting; this custom gas has a coloured appearance but does not create real neon lighting."},
    {"VAPR", "VAPR", 0xD8E8F5, "gas", "Water vapour: water in its gaseous state, present in air in varying amounts. Vapour can condense into liquid water when conditions change; this custom gas uses a gas template and does not automatically condense."},
    {"COPR", "COPR", 0xC96B3B, "solid", "Copper (Cu): a reddish metal that conducts electricity and heat very well. It is used in electrical wiring, plumbing, and alloys; this custom solid is for material comparisons and does not simulate electrical conductivity unless configured."},
    {"IRON", "IRON", 0x777777, "solid", "Iron (Fe): a strong, magnetic metal used in tools, structures, and steelmaking. In Mackelements, iron changes into RUML rusted metal when water and oxygen are both nearby."},
    {"ALUM", "ALUM", 0xD6D6D6, "solid", "Aluminium (Al): a lightweight metal that forms a thin protective oxide layer in air. It is used in transport, packaging, and construction; this custom solid represents the material but does not simulate all real-world properties."},
    {"ZINC", "ZINC", 0xB9C1C8, "solid", "Zinc (Zn): a bluish-silver metal commonly used to protect steel from corrosion by galvanising. It is also used in alloys and batteries; this custom solid is for material experiments and does not automatically galvanise other elements."},
    {"SILI", "SILI", 0x777C85, "solid", "Silicon (Si): a metalloid found in sand and many minerals as compounds such as silica. Purified silicon is important in computer chips and solar cells; this custom solid is a simple material representation, not a semiconductor model."},
    {"CALC", "CALC", 0xF0EEE5, "powder", "Calcium compound: this entry represents a calcium-containing mineral material, but its exact chemical formula is not specified by the ID. Calcium compounds occur in bones, shells, limestone, and cement; this powder is intended for mineral experiments."},
    {"SOCA", "SOCA", 0xE5E5E5, "powder", "Sodium compound: the exact substance is not specified by this custom ID. Sodium compounds have diverse uses in food, manufacturing, and household products; treat this entry as a generic powder until its intended formula is defined."},
    {"POCL", "POCL", 0xF5F0E5, "powder", "Potassium chloride (KCl): a salt-like compound used in fertilisers and some other industrial and laboratory applications. It forms crystals and can dissolve in water in real life; this custom powder does not automatically dissolve."},
    {"MGOX", "MGOX", 0xFFFFFF, "powder", "Magnesium oxide (MgO): a white solid used in refractory materials and some industrial applications because it tolerates high temperatures. This custom powder represents the compound but does not model its full thermal or chemical behaviour."},
    {"GLUC", "GLUC", 0xE8D8A0, "powder", "Glucose (C₆H₁₂O₆): a simple sugar used by cells as an important energy source. It occurs in fruits and is used in food and scientific applications; this custom powder is for mixture experiments, not metabolism simulation."},
    {"CITR", "CITR", 0xF0E6B0, "powder", "Citric acid: a weak organic acid found naturally in citrus fruits. It is used to add sourness and help control acidity in foods and products; this custom powder will not react with bases unless a reaction is coded."},
    {"ICE", "ICE", 0x9BE5FF, "solid", "Ice: solid water formed when water freezes under ordinary conditions. It is less dense than liquid water, which is why ice floats; this custom solid does not automatically melt or freeze unless those transitions are implemented."},
    {"PHOS", "PHOS", 0xE6C45A, "solid", "Phosphorus (P): a reactive nonmetal essential to living organisms and found in compounds such as phosphates. Different forms have different properties; this custom solid is a simplified representation and does not model phosphorus chemistry."},
    {"IODI", "IODI", 0x705080, "solid", "Iodine (I₂): a halogen that is a dark, lustrous solid at room temperature and can form violet vapour when heated. Iodine compounds are used in several scientific and medical contexts; this custom solid does not simulate sublimation."},
    {"CUSU", "CUSU", 0x2878D0, "powder", "Copper sulfate: a copper compound often encountered as blue crystals in its hydrated form. It is used in laboratory and industrial applications and can be harmful if mishandled; this custom blue powder does not model dissolution or toxicity."},
    {"ACET", "ACET", 0xD8E8F5, "liquid", "Acetic acid (CH₃COOH): the acid that gives vinegar its sour taste and smell. Dilute acetic acid is used in food and cleaning contexts; this custom liquid is a representation and does not reproduce acidity automatically."},
    {"ACID", "ACID", 0xE0E8F0, "liquid", "Generic acid: this entry does not identify a particular chemical formula or strength. Acids vary widely in their properties and uses; the custom liquid is a placeholder for simulated chemistry and has no automatic acid reactions."},
    {"AMMS", "AMMS", 0xBFE8D8, "liquid", "Ammonia solution: ammonia dissolved in water, commonly called aqueous ammonia. It is alkaline and used in some cleaning and industrial processes; stronger solutions can be hazardous, and this custom liquid does not simulate its chemistry."},
    {"SLTW", "SLTW", 0x65A9E8, "liquid", "Salt water: a mixture of water and dissolved salt. Salinity affects density, freezing point, and electrical conductivity in real life; this custom liquid is a simplified mixture and does not calculate concentration."},
    {"SOAP", "SOAP", 0xA8E8F0, "liquid", "Soap: a cleaning substance whose molecules help water remove oils and dirt. Soaps are used in washing and cleaning; this custom liquid does not automatically create bubbles or perform cleaning reactions."},
    {"MILK", "MILK", 0xFFF8E8, "liquid", "Milk: a nutrient-containing liquid mixture of water, fats, proteins, sugars, and minerals produced by mammals. It is used as food and as an ingredient in many products; this custom liquid is not a biological or food model."},
    {"BROM", "BROM", 0x9C432B, "liquid", "Bromine (Br₂): a dense, reddish-brown halogen that is liquid at ordinary room temperature and gives off hazardous vapour. It requires specialised controls in real life; this custom element is only a visual educational representation."},
    {"GALL", "GALL", 0xD0D0D8, "liquid", "Gallium (Ga): a silvery metal that melts at about 30 °C, close to warm room temperature. It is used in some semiconductor materials; this custom liquid uses a liquid template and does not automatically solidify when cooled."},
    {"LINI", "LINI", 0xBDEBFF, "liquid", "Liquid nitrogen: nitrogen cooled below its boiling point, about −196 °C at normal pressure. It is used for specialised cooling and scientific work and can cause severe cold injuries; this custom liquid does not create real cryogenic temperatures."},
    {"LIOX", "LIOX", 0x72B9FF, "liquid", "Liquid oxygen: oxygen cooled below its boiling point, about −183 °C at normal pressure. It is a powerful oxidiser and makes many materials burn more intensely; this custom liquid is a simplified representation, not real liquid oxygen."},
    {"HYDR", "HYDR", 0xE5F5FF, "gas", "Hydrogen (H₂): the lightest element and a colourless gas. It is used in chemical manufacturing and some energy technologies, and it is highly flammable; this custom gas does not automatically ignite or react."},
    {"CHLO", "CHLO", 0xB8D64B, "gas", "Chlorine (Cl₂): a yellow-green halogen gas used in controlled water treatment and chemical manufacturing. Chlorine gas is toxic and irritating, so this custom element is an educational representation only and should not be confused with safe handling advice."},
    {"AMMO", "AMMO", 0xD9F0D8, "gas", "Ammonia (NH₃): a colourless gas with a sharp odour, used in fertiliser production and refrigeration systems. It can irritate or harm the body at dangerous concentrations; this custom gas does not simulate its real hazards or reactions."},
    {"METH", "METH", 0xC4C4C4, "gas", "Methane (CH₄): the simplest hydrocarbon and a major component of natural gas. It is used as a fuel and is also a potent greenhouse gas; this custom gas does not automatically burn or model climate effects."},
    {"COMO", "COMO", 0xA5A5A5, "gas", "Carbon monoxide (CO): a colourless, odourless toxic gas that can form during incomplete combustion. It prevents blood from carrying oxygen effectively; this custom gas is a simplified representation and has no automatic poisoning effect."},
    {"N2OG", "N2OG", 0xC8D5E8, "gas", "Nitrous oxide (N₂O): a colourless gas used in some medical, food-production, and industrial contexts under appropriate controls. It also affects the climate; this custom gas does not model its real-world effects."},
    {"SUOX", "SUOX", 0xE5D9A0, "gas", "Sulfur oxide gas: a generic label for sulfur oxides, such as sulfur dioxide, rather than one precisely defined formula. Some sulfur oxides contribute to air pollution and acid deposition; this custom gas is a simplified placeholder."},
    {"OZON", "OZON", 0x8B85D8, "gas", "Ozone (O₃): a form of oxygen. High in the atmosphere it helps absorb ultraviolet radiation, while near the ground it is an air pollutant that can irritate lungs; this custom gas does not simulate either effect."},
    {"KRYO", "KRYO", 0xD0D0E8, "gas", "Krypton (Kr): a colourless noble gas present in trace amounts in air. It is used in some lighting and specialised applications; this custom gas is for gas-behaviour comparisons and does not model lighting."},
    {"XENO", "XENO", 0xA8A8D8, "gas", "Xenon (Xe): a heavy noble gas found in trace amounts in the atmosphere. It is used in specialised lighting and some scientific and medical equipment; this custom gas is a simplified representation."},
    {"H2SG", "H2SG", 0xB8C477, "gas", "Hydrogen sulfide (H₂S): a colourless, highly toxic gas known for a rotten-egg smell at low concentrations. Odour is not a reliable safety warning; this custom element is an educational representation and does not model toxicity."},
    {"ETHA", "ETHA", 0xC9D9E8, "gas", "Ethane (C₂H₆): a simple hydrocarbon found in natural gas and used as a chemical feedstock. It is flammable in real life; this custom gas does not automatically ignite or reproduce combustion."},
    {"PROP", "PROP", 0xB8C8D8, "gas", "Propane (C₃H₈): a hydrocarbon commonly used as a fuel for heating and cooking. It is stored as a liquid under pressure but becomes a gas when released at normal conditions; this custom gas does not simulate pressure storage."},
    {"BUTA", "BUTA", 0xA8B8C8, "gas", "Butane (C₄H₁₀): a flammable hydrocarbon used in some fuel applications and portable appliances. It can be liquid under pressure; this custom gas is a simplified material and does not model ignition or pressure."},
    {"NODI", "NODI", 0xB86A42, "gas", "Custom material NODI: the original project ID does not specify a reliable chemical name. It is currently configured as a gas-template element; its appearance and behaviour are determined by the mod code, not by a known real-world formula."},
    {"FORM", "FORM", 0xD8E8E8, "gas", "Custom material FORM: the original project ID does not establish a precise chemical identity. It currently uses the gas template; add a defined formula or fictional description if you intended a particular substance."},
    {"DSWR", "DSWR", 0x173DAD, "liquid", "Custom liquid DSWR: the intended full name is not clear from the ID alone. It uses the water template with a custom colour, so its flow is inherited from the template rather than a separately modelled real liquid."},
    {"DSEL", "DSEL", 0xE8D16B, "liquid", "Diesel fuel: a petroleum-derived fuel used in many compression-ignition engines. It is a mixture rather than one pure compound; this custom liquid does not model engine combustion or fuel chemistry."},
    {"UNOL", "UNOL", 0x171717, "liquid", "Custom liquid UNOL: the ID does not identify a definite real-world substance. It is currently based on the water template with a dark colour, so it behaves according to the inherited liquid settings."},
    {"KRSE", "KRSE", 0x4D88CC, "liquid", "Custom liquid KRSE: the intended name is uncertain from the ID. Its current in-game behaviour comes from the water template; use this description as a placeholder until its intended material is confirmed."},
    {"OIL", "OIL", 0xA77B45, "liquid", "Oil: a broad term for liquids that do not mix readily with water; oils can be plant-derived, petroleum-based, or mineral-based. This custom oil uses the water template, so realistic layering or viscosity is not guaranteed."},
    {"COIL", "COIL", 0xD9A800, "liquid", "Custom liquid COIL: its full name and real-world identity are not specified by the project ID. It uses a water-based liquid template with a gold colour; its current properties come from the template."},
    {"COW", "COW", 0x222222, "special", "Cow: a farm mammal raised for milk, meat, and other agricultural purposes. In Mackelements, the custom cow can eat adjacent configured food and wander horizontally; it is still a single particle, not a realistic multi-particle animal body."},
    {"SHEP", "SHEP", 0xF5F5F5, "special", "Sheep: a domesticated mammal raised for wool, meat, and milk in some breeds. In Mackelements, the sheep can eat adjacent configured plant foods and wander horizontally; it remains a single particle rather than a connected sprite."},
    {"CHKN", "CHKN", 0xF2D23B, "special", "Chicken: a domesticated bird raised for eggs and meat. In Mackelements, the chicken can eat adjacent configured grain or seed-like food and wander horizontally; egg-laying and a connected bird-shaped body are not implemented by this description."},
    {"WHEA", "WHEA", 0x9BD66B, "powder", "Wheat: a cereal grain used to make flour, bread, pasta, and other foods, and also used as livestock feed. In Mackelements, it is one of the configured foods for cows, sheep, and chickens when placed next to them."},
    {"CRSK", "CRSK", 0xB8D98B, "powder", "Grass-like plant material: the project ID suggests a grass material, but the exact plant species is unspecified. It is configured as food for cows and sheep in Mackelements; plant growth is not implied unless separately coded."},
    {"CROT", "CROT", 0xF08024, "solid", "Carrot: an edible root vegetable rich in beta-carotene, which the body can convert to vitamin A. In Mackelements, it is configured as food for cows and sheep; this does not mean the game simulates its nutritional value."},
    {"ALPR", "ALPR", 0xC8C8C8, "powder", "Custom plant-like material ALPR: the exact intended name is unclear from the ID. It is currently a powder-template element and is not included in the current animal-food lists; plant growth or other behaviour must be coded separately."},
    {"CRSD", "CRSD", 0xE8D66A, "powder", "Grass seed: a seed-like plant material intended for farming experiments. In Mackelements, it is configured as food for cows, sheep, and chickens. When adjacent to both soil and water, it grows into a CRSP sprout, which can later become CRSK grass."},
    {"CORN", "CORN", 0xD9B928, "solid", "Corn (maize): a cereal crop used as food for people and animals and as a raw material for many products. In Mackelements, it is configured as food for cows, sheep, and chickens when adjacent to them."},
    {"PETR", "PETR", 0xE8B52D, "liquid", "Petroleum: a naturally occurring mixture of hydrocarbons extracted from underground reservoirs. It is refined into fuels and other products; this custom liquid does not simulate refining, combustion, or the complex composition of crude oil."},
    {"STEL", "STEL", 0x888D93, "solid", "Steel: an alloy made mainly from iron and carbon, valued for strength and versatility. It is used in buildings, tools, vehicles, and machinery; this custom solid does not model different steel grades or mechanical strength."},
    {"TITN", "TITN", 0xAEB4BA, "solid", "Titanium (Ti): a strong, relatively lightweight metal with good corrosion resistance. It is used in aerospace, medical implants, and specialised equipment; this custom solid represents the material without modelling its engineering properties."},
    {"ROT", "ROT", 0xD97935, "special", "Rot: a fictional or custom material representing decay. Real decay can involve chemical changes and microorganisms; in Mackelements, this element has no special decay behaviour unless the code explicitly adds it."},
    {"RUML", "RUML", 0xB94B2C, "special", "Rusted metal: a custom material representing iron or steel affected by corrosion. In Mackelements, IRON changes into RUML when custom water and oxygen are both nearby; RUML does not spread rust to other metals."},
    {"FUGI", "FUGI", 0xB8D6A0, "special", "Fungus: a custom biological material inspired by fungi, a kingdom that includes mushrooms, yeasts, and moulds. Real fungi break down organic matter and have many ecological roles; growth and decomposition are not automatic in this element."},
    {"BITH", "BITH", 0xD6D6D6, "solid", "Bitumen: a dark, sticky petroleum-derived material used in asphalt and waterproofing. It softens with heat and has complex flow properties; this custom solid does not automatically soften or bind other particles."},
    {"BRSS", "BRSS", 0xE6C229, "solid", "Brass: an alloy made mainly from copper and zinc. It is used in fittings, instruments, decorative objects, and hardware; this custom solid is a material representation and does not model alloy composition."},
    {"TIN", "TIN", 0xDADDE0, "solid", "Tin (Sn): a soft, silvery metal that resists corrosion in many ordinary environments. It is used in coatings and alloys such as solder; this custom solid does not simulate coating or alloy-making processes."},
    {"BRZE", "BRZE", 0xC77A4A, "solid", "Bronze: a family of copper-based alloys, traditionally often containing tin. Bronze has been used for tools, sculptures, bells, and historical objects; this custom solid does not model different bronze formulations."},
    {"EGG", "EGG", 0xF4ECDD, "solid", "Egg: a reproductive structure laid by birds and some other animals; a chicken egg contains nutrients that support an embryo during development. In Mackelements, this is a solid-template item; hatching is not implemented unless added separately."},
    {"FRUT", "FRUT", 0xD95B43, "solid", "Fruit: a generic juicy fruit material used for Squeezer experiments. Select the Squeezer tool and apply it to FRUT to produce FRJU fruit juice; the fruit is consumed when squeezing succeeds."},
    {"PJUI", "PJUI", 0x4FAD54, "liquid", "Plant Juice: a green liquid extracted by the Mackelements Squeezer from suitable plant materials such as CRSK grass, ALPR plant material, and WHEA wheat. It is a simplified fictional simulation liquid."},
    {"FRJU", "FRJU", 0xF08A36, "liquid", "Fruit Juice: an orange-coloured liquid produced when the Squeezer tool processes the FRUT fruit element. The fruit is consumed when juice is successfully created."},
    {"CRSP", "CRSP", 0x77C95B, "powder", "Grass sprout: an early growth stage of a grass plant. In Mackelements, a CRSD seed can become a sprout when soil and water are nearby; with continued suitable conditions, the sprout grows into CRSK grass."},
    {"WOOL", "WOOL", 0xF0EEE8, "powder", "Wool: a soft fibre produced by sheep. In Mackelements, sheep can periodically produce a wool particle when there is room nearby."},
    {"DPLJ", "DPLJ", 0x83C77D, "liquid", "Diluted Plant Juice: a lighter green liquid made when Plant Juice touches custom Water. This is a simple game interaction, not a realistic chemical process."},
    {"DFJU", "DFJU", 0xF4B36C, "liquid", "Diluted Fruit Juice: a lighter orange liquid made when Fruit Juice touches custom Water. This is a simple game interaction, not a realistic chemical process."},
    {"SOIL", "SOIL", 0x8B5A2B, "powder", "Soil: a mixture of mineral particles, organic matter, water, air, and living organisms that supports plant growth. In Mackelements, soil can change into MUD when it touches custom water; it also helps CRSD seeds sprout when water is nearby."},
    {"FRSR", "FRSR", 0xC4A484, "powder", "Fertiliser: a material intended to supply nutrients that plants need, such as nitrogen, phosphorus, or potassium. The exact composition of this custom entry is unspecified; in Mackelements it is currently configured as food for chickens, but it does not fertilise plants automatically."},
    {"FRSL", "FRSL", 0x4B2E1F, "powder", "Fertilised soil: a custom material intended to represent soil mixed with fertiliser. Real fertilised soil may supply plant nutrients depending on its composition; this element does not automatically promote growth unless plant mechanics are programmed."},
    {"MUD", "MUD", 0xA16B45, "liquid", "Mud: wet soil mixed with water, common around rivers, wetlands, and after rain. In Mackelements, nearby custom water can turn SOIL into MUD; the mud uses a liquid template, so its flow follows the game’s configured liquid physics."}
}

-- Register all custom elements.
local customIDs = {}
local registeredCount = 0

for _, entry in ipairs(data) do
    local name = entry[1]
    local identifier = entry[2]
    local colour = entry[3]
    local category = entry[4]
    local description = entry[5]

    local id = elements.allocate(GROUP, identifier)

    if id and id >= 0 then
        local template = elements.element(templates[category])
        elements.element(id, template)
        elements.property(id, "Name", name)
        elements.property(id, "Description", description)
        elements.property(id, "Color", colour)
        elements.property(id, "MenuSection", sections[category])
        customIDs[identifier] = id
        registeredCount = registeredCount + 1
    else
        print("Mackelements: failed to register " .. identifier)
    end
end

-- BASIC MATERIAL REACTIONS
-- Each reaction checks the eight neighbouring pixels.
local function hasNeighbourType(x, y, wantedType)
    if wantedType == nil then return false end

    -- Use the simulation neighbour iterator so each returned value is a
    -- particle index. Do not pass x/y coordinates to partChangeType.
    for p in sim.neighbors(x, y, 1, 1) do
        if p ~= nil and p >= 0 then
            if sim.partProperty(p, sim.FIELD_TYPE) == wantedType then
                return true
            end
        end
    end

    return false
end


-- EXPANDED REACTION SYSTEM
-- These are simplified game reactions, not a complete chemistry simulator.
-- Each rule changes the current particle when its listed neighbour is found.
local extraReactions = {
    -- Dissolving / mixtures and acid-base demonstrations
    SALT = {{"WATR", "SLTW"}},
    BICA = {{"ACID", "CO2G"}, {"CITR", "CO2G"}, {"ACET", "CO2G"}},
    ACID = {{"BICA", "CO2G"}},
    CITR = {{"BICA", "CO2G"}},
    ACET = {{"BICA", "CO2G"}},

    -- Simplified oxidation / combustion demonstrations
    CARB = {{"OXYG", "CO2G"}},
    SULF = {{"OXYG", "SUOX"}},
    METH = {{"OXYG", "CO2G"}},
    ETHA = {{"OXYG", "CO2G"}},
    PROP = {{"OXYG", "CO2G"}},
    BUTA = {{"OXYG", "CO2G"}},
    ETHL = {{"OXYG", "CO2G"}},
    PETR = {{"OXYG", "CO2G"}},
    OIL = {{"OXYG", "CO2G"}},
    VOIL = {{"OXYG", "CO2G"}},
    COIL = {{"OXYG", "CO2G"}},

    -- Simplified biological decay / food interactions
    FUGI = {{"WHEA", "ROT"}, {"CRSK", "ROT"}, {"CORN", "ROT"}, {"CROT", "ROT"}, {"MILK", "ROT"}},
    ROT = {{"WHEA", "ROT"}, {"CRSK", "ROT"}, {"CORN", "ROT"}, {"CROT", "ROT"}, {"MILK", "ROT"}, {"ALPR", "ROT"}},
    MILK = {{"ROT", "ROT"}},

    -- Simple water/material changes
    ICE = {{"WATR", "WATR"}},
    VAPR = {{"ICE", "WATR"}},
    FRSL = {{"WATR", "MUD"}},
    PJUI = {{"WATR", "DPLJ"}},
    FRJU = {{"WATR", "DFJU"}},
}

local function tryExtraReaction(i, x, y, currentID)
    local rules = extraReactions[currentID]
    if not rules then return false end

    for _, rule in ipairs(rules) do
        local neighbourID = customIDs[rule[1]]
        local productID = customIDs[rule[2]]
        if neighbourID and productID and hasNeighbourType(x, y, neighbourID) then
            sim.partChangeType(i, productID)
            return true
        end
    end
    return false
end

-- MULTI-STAGE SEED GROWTH
-- CRSD + soil + water -> CRSP sprout; after enough suitable update ticks, CRSP -> CRSK grass.
if customIDs["CRSD"] then
    elements.property(customIDs["CRSD"], "Update", function(i, x, y, surround_space, nt)
        if tryExtraReaction(i, x, y, "CRSD") then return true end
        if hasNeighbourType(x, y, customIDs["SOIL"]) and
           hasNeighbourType(x, y, customIDs["WATR"]) then
            sim.partChangeType(i, customIDs["CRSP"])
            sim.partProperty(i, "tmp", 0)
            return true
        end
        return false
    end)
end

if customIDs["CRSP"] then
    elements.property(customIDs["CRSP"], "Update", function(i, x, y, surround_space, nt)
        if hasNeighbourType(x, y, customIDs["SOIL"]) and
           hasNeighbourType(x, y, customIDs["WATR"]) then
            local ticks = (sim.partProperty(i, "tmp") or 0) + 1
            if ticks >= 45 then
                sim.partChangeType(i, customIDs["CRSK"])
                sim.partProperty(i, "tmp", 0)
                return true
            end
            sim.partProperty(i, "tmp", ticks)
        else
            sim.partProperty(i, "tmp", 0)
        end
        return false
    end)
end

-- SOIL touching custom WATR -> MUD.
if customIDs["SOIL"] then
    elements.property(customIDs["SOIL"], "Update", function(i, x, y, surround_space, nt)
        if tryExtraReaction(i, x, y, "SOIL") then return true end
        if hasNeighbourType(x, y, customIDs["WATR"]) and
           not hasNeighbourType(x, y, customIDs["CRSD"]) then
            sim.partChangeType(i, customIDs["MUD"])
            return true
        end
        return false
    end)
end

-- IRON + nearby custom WATR + OXYG -> RUML.
if customIDs["IRON"] then
    elements.property(customIDs["IRON"], "Update", function(i, x, y, surround_space, nt)
        if tryExtraReaction(i, x, y, "IRON") then return true end
        if hasNeighbourType(x, y, customIDs["WATR"]) and
           hasNeighbourType(x, y, customIDs["OXYG"]) then
            sim.partChangeType(i, customIDs["RUML"])
            return true
        end
        return false
    end)
end

-- ANIMAL FEEDING AND GENTLE WANDERING
-- Food must be in one of the eight neighbouring pixels.
-- Movement is horizontal and uses normal particle velocity; it does not create a multi-particle animal body.

local cowSheepFood = {
    [customIDs["WHEA"]] = true,
    [customIDs["CRSK"]] = true,
    [customIDs["CRSD"]] = true,
    [customIDs["CROT"]] = true,
    [customIDs["CORN"]] = true
}

local chickenFood = {
    [customIDs["WHEA"]] = true,
    [customIDs["CRSD"]] = true,
    [customIDs["CORN"]] = true,
    [customIDs["FRSR"]] = true
}

local function feedAnimal(i, x, y, isChicken)
    for dx = -1, 1 do
        for dy = -1, 1 do
            if dx ~= 0 or dy ~= 0 then
                local px = x + dx
                local py = y + dy
                local p = sim.partID(px, py)

                if p ~= nil and p >= 0 then
                    local particleType = sim.partProperty(p, sim.FIELD_TYPE)
                    local shouldEat

                    if isChicken then
                        shouldEat = chickenFood[particleType] == true
                    else
                        shouldEat = cowSheepFood[particleType] == true
                    end

                    if shouldEat then
                        sim.partKill(px, py)
                        return true
                    end
                end
            end
        end
    end

    return false
end

-- Change direction every so often, rather than on every simulation frame.
-- The Dust template still uses normal Powder Toy physics and gravity.
local function wanderAnimal(i, x, y)
    local ticks = sim.partProperty(i, "tmp") or 0
    ticks = ticks + 1

    if ticks >= 18 then
        ticks = 0
        local direction
        if math.random(0, 1) == 0 then
            direction = -1
        else
            direction = 1
        end

        -- Avoid deliberately walking into a particle immediately beside the animal.
        local front = sim.partID(x + direction, y)
        if front ~= nil and front >= 0 then
            direction = -direction
            front = sim.partID(x + direction, y)
        end

        if front == nil or front < 0 then
            sim.partProperty(i, "vx", direction * 0.65)
        else
            sim.partProperty(i, "vx", 0)
        end
    end

    sim.partProperty(i, "tmp", ticks)
end

-- ANIMAL PRODUCTS: each animal has a separate tmp2 timer so it does not conflict with wandering.
-- Products appear in nearby empty space; if there is no room, the animal keeps waiting.
local function animalProduce(i, x, y, productID, minTicks, maxTicks)
    if not productID then return false end
    local ticks = (sim.partProperty(i, "tmp2") or 0) + 1
    local target = sim.partProperty(i, "tmp3") or 0
    if target <= 0 then
        target = math.random(minTicks, maxTicks)
    end
    if ticks >= target then
        for radius = 1, 3 do
            local made = false
            for dx = -radius, radius do
                for dy = -radius, radius do
                    if math.abs(dx) == radius or math.abs(dy) == radius then
                        local px, py = x + dx, y + dy
                        local at = sim.partID(px, py)
                        if at == nil or at < 0 then
                            local created = sim.partCreate(-1, px, py, productID)
                            if created ~= nil and created >= 0 then
                                made = true
                                break
                            end
                        end
                    end
                end
                if made then break end
            end
            if made then
                sim.partProperty(i, "tmp2", 0)
                sim.partProperty(i, "tmp3", 0)
                return true
            end
        end
        -- No empty pixel was available: retry soon rather than losing the product.
        sim.partProperty(i, "tmp2", target - 1)
        sim.partProperty(i, "tmp3", target)
        return false
    end
    sim.partProperty(i, "tmp2", ticks)
    sim.partProperty(i, "tmp3", target)
    return false
end

if customIDs["COW"] then
    elements.property(customIDs["COW"], "Update", function(i, x, y, surround_space, nt)
        local ate = feedAnimal(i, x, y, false)
        animalProduce(i, x, y, customIDs["MILK"], 180, 300)
        wanderAnimal(i, x, y)
        return ate
    end)
end

if customIDs["SHEP"] then
    elements.property(customIDs["SHEP"], "Update", function(i, x, y, surround_space, nt)
        local ate = feedAnimal(i, x, y, false)
        animalProduce(i, x, y, customIDs["WOOL"], 220, 360)
        wanderAnimal(i, x, y)
        return ate
    end)
end

if customIDs["CHKN"] then
    elements.property(customIDs["CHKN"], "Update", function(i, x, y, surround_space, nt)
        local ate = feedAnimal(i, x, y, true)
        animalProduce(i, x, y, customIDs["EGG"], 160, 280)
        wanderAnimal(i, x, y)
        return ate
    end)
end

-- Give every remaining custom element access to the shared reaction engine.
-- Elements without a listed rule remain stable by design.
local specialUpdateIDs = {CRSD=true, CRSP=true, SOIL=true, IRON=true, COW=true, SHEP=true, CHKN=true}
for _, entry in ipairs(data) do
    local identifier = entry[2]
    if customIDs[identifier] and not specialUpdateIDs[identifier] then
        local idForUpdate = identifier
        elements.property(customIDs[idForUpdate], "Update", function(i, x, y, surround_space, nt)
            return tryExtraReaction(i, x, y, idForUpdate)
        end)
    end
end

-- REAL SQUEEZER TOOL (not a physical particle)
-- Requires a Powder Toy build with the Lua tools API (tools.allocate / tools.property).
-- FRUT -> FRJU; suitable plant materials -> PJUI; COW/SHEP -> MILK; MUD -> WATR.
local function findEmptyNear(x, y)
    for radius = 1, 3 do
        for dx = -radius, radius do
            for dy = -radius, radius do
                if math.abs(dx) == radius or math.abs(dy) == radius then
                    local px, py = x + dx, y + dy
                    local p = sim.partID(px, py)
                    if p == nil or p < 0 then
                        return px, py
                    end
                end
            end
        end
    end
    return nil, nil
end

local function createSqueezedLiquid(x, y, productID)
    if not productID then return false end
    local px, py = findEmptyNear(x, y)
    if px == nil then return false end
    local created = sim.partCreate(-1, px, py, productID)
    return created ~= nil and created >= 0
end

local function squeezerPerform(i, x, y, strength, brushX, brushY)
    if i == nil or i < 0 then return false end
    local sourceType = sim.partProperty(i, sim.FIELD_TYPE)
    local productID = nil
    local consumeSource = false

    if customIDs["FRUT"] and sourceType == customIDs["FRUT"] then
        productID = customIDs["FRJU"]
        consumeSource = true
    elseif (customIDs["CRSK"] and sourceType == customIDs["CRSK"]) or
           (customIDs["ALPR"] and sourceType == customIDs["ALPR"]) or
           (customIDs["WHEA"] and sourceType == customIDs["WHEA"]) then
        productID = customIDs["PJUI"]
        consumeSource = true
    elseif (customIDs["COW"] and sourceType == customIDs["COW"]) or
           (customIDs["SHEP"] and sourceType == customIDs["SHEP"]) then
        productID = customIDs["MILK"]
    elseif customIDs["MUD"] and sourceType == customIDs["MUD"] then
        productID = customIDs["WATR"]
        consumeSource = true
    end

    if not productID then return false end
    if createSqueezedLiquid(x, y, productID) then
        if consumeSource then
            -- Kill by the target coordinates only after the output was created.
            sim.partKill(x, y)
        end
        return true
    end
    return false
end

if tools and tools.allocate and tools.property then
    local toolIdentifier = GROUP .. "_TOOL_SQUEEZER"
    local squeezerIndex = tools.index and tools.index[toolIdentifier]
    if squeezerIndex == nil then
        squeezerIndex = tools.allocate(GROUP, "SQUEEZER")
    end
    if squeezerIndex and squeezerIndex >= 0 then
        tools.property(squeezerIndex, "Name", "Squeezer")
        tools.property(squeezerIndex, "Description", "Extract fruit juice, plant juice, water from mud, or milk from a cow/sheep. Select the tool and click the source material.")
        tools.property(squeezerIndex, "Colour", 0x3976D2)
        tools.property(squeezerIndex, "MenuSection", elem.SC_TOOL)
        tools.property(squeezerIndex, "Perform", squeezerPerform)
        print("Mackelements: Squeezer tool registered.")
    else
        print("Mackelements: failed to register Squeezer tool.")
    end
else
    print("Mackelements: this Powder Toy build does not expose the Lua tools API; Squeezer tool was not registered.")
end

print("Mackelements loaded: " .. registeredCount .. " of " .. #data .. " element definitions.")
print("Mackelements: descriptions, multi-stage seed growth, animal feeding/products, liquid interactions, wandering, and Squeezer tool setup attempted.")
