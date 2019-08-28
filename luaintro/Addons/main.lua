
if addon.InGetInfo then
	return {
		name    = "Main",
		desc    = "displays a simplae loadbar",
		author  = "jK",
		date    = "2012,2013",
		license = "GPL2",
		layer   = 0,
		depend  = {"LoadProgress"},
		enabled = true,
	}
end

------------------------------------------

local showTips = true
if (Spring.GetConfigInt("LoadscreenTips",1) or 1) == 0 then
	showTips = false
end

local lastLoadMessage = ""

function addon.LoadProgress(message, replaceLastLine)
	lastLoadMessage = message
end

------------------------------------------

-- Random tips we can show
local tips = {
    "armsolar.dds ".."You may order your builder or outpost to build structures in an array-like pattern by holding SHIFT+ALT and dragging with the left mouse button. Spread them up by hitting 'T' on keyboard while the Shift key is held. Ctrl+Shift+T brings them closer.",
    "armwin.dds ".."Wind Generators built on high ground have a bonus compared to units built closer to the sea level. Isn't nature beautiful?",
    "cordt.dds ".."Arm and Core's Dragon Teeth (DTs) are great to surround perimeters, preventing lower-tech units movement. They also block incoming direct-fire and missiles from going through, so improve your defenses resistance by surrounding them with DTs.",
    "armcom.dds ".."The D-Gun is the Commander's directed-fire ability and the most powerful weapon in the game. Upgrade it in the commander menu after your Tech Center is on level 1, then use it with the 'D' keyboard shortcut.",
    "armyork.dds ".."Flak-weaponry units, like the Phalanx, fire scattered projectiles. Flak is excellent at taking out fighters and heavy infantry, but will barely scratch tanks, commanders and plasma kbots.",
    "armaak.dds ".."The Arm Archangel (Tier 2) and the Core Manticore (T3) fire long range missiles. Like all AA (anti-air) missiles, it's great vs bombers but not so much against fighters.",
	"outpost.dds ".."To build unit factories you need an Outpost. Outposts can morph up to Tier4, with increasingly better build range and LOS.",
    "armsilo.dds ".."It's not just about upgrading the Tech Center! Keep upgrading your outpost. Building structures from it is much cheaper than morphing, and it'll build exclusive structures like Annihilators, Nukes and EMP Launchers.",
    "armshltx ".."To build experimental units like the Krogoth and Bantha, you need an Experimental Gantry, built exclusively by a Level 4 outpost",
    "corafus ".."The 'AFUS' or Advanced Fusion Reactor has the best energy output in your army. You can get AFUSes by morphing a regular Fusion, once you're Tech Level 4",
    "armawin ".."When the wind is blowing in your favor, Advanced Wind Generators are available on Tier 2 as morphs from the regular Wind Generator.",
    "cormuskrat.dds ".."FARKs and Muskrats are units built directly by the Outpost. They're great for early scout, can build dragon eyes (stealth remote cameras) and may assist factories (faster unit production speed).",
    "outpost.dds ".."Outposts can speed up any construction, but they're less cost effective for that than FARKs (built by the outpost) and they spend energy continuously.",
	"armtech.dds ".."To tech up, build a Tech Center, then upgrade it progressively until Tech Tier4. This unlocks high-tier upgrades in factories and outposts as well.",
	"armtech.dds ".."When under attack, Tech Centers can become 70% more resistant if disabled (ON/OFF button or Ctrl+X shortcut)",
    "corraid.dds ".."Vehicles become sensibly slower when they drop below 30% health. Use that for your advantage, to prevent them from using hit-and-run tactics effectively.",
	"corgat.dds ".."Gatlings and Flashes are terrific anti-kbot vehicles, very EMP-resistant and moderately effective against lighter gunships. When facing tanks or combos of plasma and missile kbots, don't expect them to last long.",
    "corlevlr.dds ".."Core Levelers and Arm Pokers are early game assault units. One of their unique abilities is the capacity to dodge kbot missiles when properly microed and kept moving at their top speed. Levelers can also transport kbots, including builders",
	"armrl.dds ".."Missile towers can shoot at both ground and air units, but their anti-air range and damage is much higher than when firing on land units. Nevertheless, they're the best early static response to assault vehicles and tanks.",
    "armsam.dds ".."The Arm Samson has a special ability, the Fire Rain. It's researched per-unit (requires Tier1 Tech) and lobs multiple fire shells, damaging kbots and vehicles in a wide area. Hit 'D' and left-click on target to use it.",
    "armpw.dds ".."Peewees may acquire a special ability once you get to Tier 1, the laser grenade. It's researched per-unit and lobs a mid-range bouncing projectile, quite effective vs kbots and defenses. To use it, Hit 'D' and left-click on target.",
	"armmex.dds ".."Metal Extractors can be morphed into Adv. Metal Extractors at Tier 1, Moho Mexes at Tier 2 and Uber Mexes at Tier 3, with increasingly higher metal output",
	--"Have trouble finding metal spots?\nPress F4 to switch to the metal map.",
	--"Queue-up multiple consecutive unit actions by holding SHIFT.",
	--"Tweak graphic preferences in options (top right corner of the screen).\nWhen your FPS drops, switch to a lower graphic preset.",
    "corgol.dds ".."Tanks can crush lighter enemy kbots, like rifle and missile kbots. Tier 2 tanks can crush dragon teeth, and the Tier 3 Goliath can even crush Tier 2 Tanks.",
    "armmine3.dds ".."Pokers, Arm's basic assault vehicle, can build land mines, great vs kbots, and bar mines, excellent vs vehicles.",
	"armrad.dds ".."Radars are cheap and their detection range is much larger than their vision range. In the beginning, Commanders and Outposts are your best options for true vision range.",
    "armgeo.dds ".."Abandoned/Neutral Geothermals might be scattered around the map and provide plenty of energy. You can capture them with commanders or with builders, after you research the 'capture' upgrade in the Tech Center.",
    "cormort.dds ".."Powerful artillery units are available after you upgrade your Tech Center to Level 1. Core's Morty is built from the kbot lab, Arm Luger from the Vehicle Plant.",
    "armpship.dds ".."Position your naval units properly during engagements. Missile ships are stronger at their rear area, while other ships are stronger at the front. Submarines are up to twice stronger at the front.",
    "corbw.dds ".."Bladewings and Banshees are Core and Arm's drones respectively. They're available on Tier 0 air plants and in spite of their mobility, don't have a great line of sight and fly low, meaning they can be hit by any ground unit.",
    "cormist.dds ".."Missile Trucks (Arm Samson & Core Slasher) are very expensive but a) never miss, b) outrange some defenses and d) are the best early-game mobile counters to air units.",
    "cormist.dds ".."Missile Trucks (Arm Samson & Core Slasher) are very expensive but a) never miss, b) outrange some defenses and d) are the best early-game mobile counters to air units.",
    "corrad.dds ".."To know what enemy units are vulnerable to a certain unit you have, point to that unit and hold SHIFT. Colored circles will show up below units on screen. Green means vulnerable to the pointed unit, Red means resistant to it, and so on.",
    "armmark.dds ".."The highest relatively to the ground a unit is, the further it can see (LOS). The T1 Marky is one of the best scouts in the game, able to climb steep hills and easily acquire a nice vantage point.",
	--"To see detailed info about each unit in-game switch on \"Extensive unit info\" via Options menu",
	--"In general, vehicles are a good choice for flat and open battlefields. Kbots are better on hills.",
	--"For wind generators to be worth building, the average wind speed should be over 7. Current, minimum, and maximum wind speeds are shown to the right of the energy bar.",
	--"If your economy is based on wind generators, always build an E storage to have a reserve for when the wind speed drops.",
	--"Commanders have a manual Dgun weapon, which can decimate every unit with one blow.\nPress D to quickly initiate aiming.",
	--"Spread buildings to prevent chain explosions.\nPress ALT+Z and ALT+X to adjust auto-spacing.",
	--"It is effective to move your units in spread formations.\nDrag your mouse while initiating a move order to draw multiple waypoints.",
    "armmart.dds ".."Some tanks and long-ranged vehicles can move in reverse if you press 'Ctrl' while giving a command behind it. Use this to keep firing while retreating.",
	--"T2 factories are expensive. Reclaim your T1 lab for metal to fund it",
	--"Air strikes and airdrops may come at any time, always have at least one anti-air unit in your base.",
	--"With ~(tilde)+doubleclick you can place a label with text on the map.\n~(tilde)+middle mouse button for an empty label.\n~(tilde)+mouse drag to draw lines",
	--"Always check your Com-counter (next to resource bars). If you have the last Commander you better hide it quick!",
	--"Expanding territory is essential for gaining economic advantage.\nTry to secure as many metal spots and geothermal vents as you can.",
	--"Think in advance about reclaiming metal from wrecks piling up at the front.",
	--"Nano towers can be picked up by transporters. This way you can move them where you need more buildpower.",
	--"When your excessing energy... build metal makers to convert the excess to metal.",
	--"Select all units of the same type by pressing CTRL+Z.",
	--"Press CTRL+C to quickly select and center the camera on your Commander.",
	--"Think ahead and include anti-air and support units in your army.",
	--"Mastering hotkeys is the key to proficiency in TAP.\nUse Z,X,C to quickly cycle between most frequently built structures.",
	--"To share resources with teammates:\n - Double-click tank icon next to the player's name to share units\n - Click-drag metal/energy bar next to player's name to send resources.\n - Press H to share an exact amount.",
	--"It is efficient to support your lab with constructors increasing its build-power.\nRight click on the factory with a constructor selected to guard (assist) with construction",
	--"Remember to separate your highly explosive buildings (like metal makers) from the rest of your base.",
	--"Most long-ranged units are very vulnerable in close combat. Always keep a good distance from your targets.",
	--"Keep all your builders busy.\nPress CTRL+B to select and center camera on your idle constructor.",
	--"The best way to prevent air strikes is building fighters and putting them on PATROL in front of your base.",
	--"Use radar jammers to hide your units from enemy radar and hinder artillery strikes.",
	--"Cloaking your Commander drains 100E stationary and 1000E when walking (every second)",
	--"Combine CLOAK with radar jamming to completely hide your units.",
	--"Long-ranged units need scouting for accurate aiming.\nGenerate a constant stream of fast, cheap units for better vision.",
	--"You can assign units to groups by pressing CTRL+[num].\nSelect the group using numbers (1-9).",
	--"When performing a bombing run fly your fighters first to eliminate enemy's fighter-wall.\nUse FIGHT or PATROL command for more effective engagement.",
	--"You can disable enemy's anti-nukes using EMP missiles (built by ARM T2 cons)",
	--"Don't build too much stuff around Moho-geothermal powerplants or everything will go boom!",
	"Missile Towers may morph into Adv. Missile Towers, both firing at air and ground targets. Their third morph is the Adv. AA tower, which sport long range missiles able to take down most aircraft with one shot. Bear in mind those have limited load and take some time to recharge.",
	--"Your commander's Dgun can be used to insta-kill T3 units. Don't forget to cloak it first.\nFor quickly cloaking press K.",
	--"If you are certain of losing some unit in enemy territory, self-destruct it to prevent him from getting the metal. \nPress CTRL+D to initiate the self-destruct countdown.",
	--"Mines are super-cheap and quick to build. Remember to make them away from enemy's line of sight.",
	--"Enemy's mines, radars, and jammers may be disabled using the Juno - built by both factions with T1 constructors.",
    --"Use Alt+0-9 sets the autogroup number (1 .. 9, 0) for selected unit type(s). Newly built units get automatically added to their autogroup number. Alt+Tilde (~) remove units from that autogroup.",
    "Tier 0 (starting) builder units can not assist the production of factories, unlike their advanced (Tier 2) counterparts. Morph the into Adv. builders as soon as you can.",
    "Before you start building a ton of Outposts, please notice they spend +50e per tick. Super-effective Nano Towers won't exist for 2000 more years.",
}

-- Random unit descriptions we can show
local titleColor = "\255\215\255\215"
local contentColor = "\255\255\255\255"
local unit_descs = {
    "armoutpost.dds "..titleColor.."Pro Tip:\n"..contentColor.."Losing your Tier2+ Tech Center won't throw you back to the stone age if you managed to morph at least one Outpost to Tier 2. (and keep it alive, ofc!)",
    "armack.dds "..titleColor.."Adv. Builder (ARM T2):\n"..contentColor.."Advanced Builders can assist factory production, just like outposts, commanders and FARKs. Building (or morphing) a couple beforehand might save you from total disaster if you lose your T2 Tech Center.",
    "corca.dds "..titleColor.."Construction Plane (CORE T1):\n"..contentColor.."Differently from their ground counterparts, basic Construction Planes can build both missile and laser defenses.",
	"armck.dds "..titleColor.."Builder (ARM T1)\n"..contentColor.."Slightly slower and weaker than the Dozer, this kbot builder can climb steeper hills, effective for expansion especially in mountainous terrain.",
	--"armflea.dds "..titleColor.."Flea (ARM T1 Kbot)\n"..contentColor.."Supercheap and fast, used for scouting and raiding enemy structures in early-game stages. Avoid laser towers and destroy metal extractors to slow down your foe’s expansion!",
	"armham.dds "..titleColor.."Hammer (ARM T1 Kbot)\n"..contentColor.."Plasma kbots are the sturdiest basic kbots, extremely resistant to defenses and excellent at taking out commanders. They have a minimum attack range, but their mid-ranged arced projectiles can fly over dragon teeth.",
	--"armjeth.dds "..titleColor.."Jethro (ARM T1 Amphibious Kbot)\n"..contentColor.."Amphibious mobile anti-air to take down light aircraft. Always send a few with your army to protect it from EMP drones and gunships.",
	"armpw.dds "..titleColor.."Peewee (ARM T1 Kbot)\n"..contentColor.."Cheap and fast moving, average-to-low health and built in groups of 3 at a time. With its good LOS, it's effective for scouting and early economy harassment. Excellent vs missile kbots.",
	"armrectr.dds "..titleColor.."Rector (ARM T1 Kbot)\n"..contentColor.."Fast Kbot which can rapidly heal units and resurrect destroyed units. Extends the lifetime and adds a snowballing effect to your attack forces",
	"armrock.dds "..titleColor.."Rocko (ARM T1 Kbot)\n"..contentColor.."Light rocket Kbot excellent vs tanks and with good damage against defenses. Mixed with plasma kbots they form a great combo vs defense towers. Watch out for rifle bots (A.K./Peewee)",
	--"armwar.dds "..titleColor.."Warrior (ARM T1 Kbot)\n"..contentColor.."Durable Kbot armed with a rapid firing double laser. Has high health and can take down multiple light assault units. Combine with resurrection Kbots for quick repairing.",
	--"corak.dds "..titleColor.."A.K. (CORE T1 Kbot)\n"..contentColor.."Light infantry Kbot which is cheap and quick to build. It is armed with a light, but precise laser which outranges the PeeWee.",
	--"corcrash.dds "..titleColor.."Crasher (CORE T1 Amphibious Kbot)\n"..contentColor.."Amphibious mobile anti-air (AA) Kbot that can easily take down light aircraft. Send a few with your army to protect it from EMP drones and gunships.",
	--"corstorm.dds "..titleColor.."Storm (CORE T1 Kbot)\n"..contentColor.."Light rocket Kbot used to push the frontline towards opponent's base. Outranges light laser turrets. Slow but stronger than its ARM counterpart.",
	--"cornecro.dds "..titleColor.."Necro (CORE T1 Kbot)\n"..contentColor.."Fast, light Kbot that can ressurect destroyed units. Also can quickly reclaim and repair units. Adds a snowballing effect to your attacks.",
	--"corthud.dds "..titleColor.."Thud ((CORE T1 Kbot))\n"..contentColor.."Deals significant damage with relatively low cost. Used in big numbers to destroy T1 defences. Works great for defending mountain tops, as elevation increases their range.",
	--"armfav.dds "..titleColor.."Jeffy (ARM T1 Vehicle)\n"..contentColor.."Cheap and the fastest unit in the whole game. Evade laser towers and destroy metal extractors to slow down your foe's expansion.",
	--"armflash.dds "..titleColor.."Flash (ARM T1 Vehicle)\n"..contentColor.."A light, fast tank with close combat rapid fire weapon. Slightly more powerful and faster than Peewee and A.K. on flat terrain.",
	--"armart.dds "..titleColor.."Shellshocker (ARM T1 Vehicle)\n"..contentColor.."Artillery vehicle used to take down T1 defenses, esp. Heavy Laser Turrets. It can outrange all T1 defense towers. Always keep them protected by Stumpies/Flashes.",
	--"armbeaver.dds "..titleColor.."Beaver (ARM T1 Amphibious Vehicle)\n"..contentColor.."Amphibious construction vehicle, can travel on land and underwater allowing easy expansion between islands, under rivers and across seas. Can build the amphibious factory.",
	--"armcv.dds "..titleColor.."Construction Vehicle (ARM T1)\n"..contentColor.."Able to build basic T1 defences and economy. Slightly faster and stronger than Kbot constructor. Each Construction vehicle increases the player's energy and metal storage capacity by 50.",
	--"armjanus.dds "..titleColor.."Janus (ARM T1 Vehicle)\n"..contentColor.."Heavy dual rocket tank. Slow speed and fire rate makes it vulnerable to fast units. Its large damage, range and AoE make it useful for destroying Commanders. Requires heavy micro and close attention.",
	--"armmlv.dds "..titleColor.."Podger (ARM T1 Vehicle)\n"..contentColor.."Stealthy mine-layer and sweeper. Use the attack command to clear mines in an area. REMEMBER that mines use energy to remain cloaked!",
	--"armpincer.dds "..titleColor.."Pincer (ARM T1 Amphibious Vehicle)\n"..contentColor.."Light amphibious tank which can travel on land and underwater. Weaker than most tanks. Avoid direct fire exchange and try to surprise enemies by destroying undefended targets near the shoreline.",
	--"armsam.dds "..titleColor.."Samson (ARM T1 Vehicle)\n"..contentColor.."Missile truck that can target land and air units. It has a good range and line-of-sight. Good for supporting or destroying light defences.",
	--"armstump.dds "..titleColor.."Stumpy (ARM T1 Vehicle)\n"..contentColor.."A general purpose assault tank. Thanks to good armor, it works great as a brute-force skirmish unit.",
	--"corcv.dds "..titleColor.."Construction Vehicle (CORE T1)\n"..contentColor.."Able to build basic T1 structures. It is slightly faster and stronger than the Kbot constructor, but it can't climb steeper hills.",
	--"corfav.dds "..titleColor.."Weasel (CORE T1 Vehicle)\n"..contentColor.."Cheap and very fast unit used for scouting and early strikes. Evade laser towers and destroy metal extractors to slow down your foe's expansion.",
	--"corgarp.dds "..titleColor.."Garpike (CORE T1 Amphibious Vehicle)\n"..contentColor.."Light amphibious tank which can travel on land and underwater. Weaker than most tanks. Avoid direct fire exchange and try to surprise enemies by destroying undefended targets near the shoreline.",
	--"corgator.dds "..titleColor.."Instigator (CORE T1 Vehicle)\n"..contentColor.."Light, fast moving tank armed with a precise laser weapon. Slower than its ARM counterpart - Flash, but it has a greater range, so always try to keep the distance.",
	--"corlevlr.dds "..titleColor.."Leveler (CORE T1 Vehicle) \n"..contentColor.."Powerful tank armed with an impulse weapon that deals AoE damage and repels light units. It makes it highly effective against swarms of peewees, flashes etc.",
	--"cormist.dds "..titleColor.."Slasher (CORE T1 Vehicle)\n"..contentColor.."Long-range light missile truck. Able to outrange most T1 defensive units. They can also serve as basic anti-air defense. Very ineffective in close combat.",
	--"cormlv.dds "..titleColor.."Spoiler (CORE T1 Vehicle)\n"..contentColor.."Stealthy mine-layer and minesweeper. Use the attack command to clear mines in an area. REMEMBER that mines use energy to remain cloaked!",
	--"cormuskrat.dds "..titleColor.."Muskrat (CORE T1 Amphibious Vehicle)\n"..contentColor.."Construction vehicle, which can travel on land and underwater. Builds basic defenses and economy for both land and sea. Useful for expansion in water when you don't have ships.",
	--"corraid.dds "..titleColor.."Raider (CORE T1 Vehicle)\n"..contentColor.."A general purpose assault tank. Thanks to good armor, it works great as a brute-force skirmish unit.",
	--"corwolv.dds "..titleColor.."Wolverine (CORE T1 Vehicle)\n"..contentColor.."The Wolverine is an artillery vehicle used to take down T1 defenses, especially Heavy Laser Turrets. Helpless in close quarters combat.",
	--"armatlas.dds "..titleColor.."Atlas ARM T1 Aircraft\n"..contentColor.."Transportation unit. It can pick up all T1 land based units and smaller T2 units. Cannot load units like the Fatboy or Goliath. Can be used for transporting nano turrets too.",
	--"armca.dds "..titleColor.."Construction Aircraft (ARM T1)\n"..contentColor.."Can make basic T1 defences, economy structures and most importantly the T2 Aircraft Plant. Useful for building and reclaiming in remote areas.",
	--"armfig.dds "..titleColor.."Freedom Fighter (ARM T1 Aircraft)\n"..contentColor.."A fighter jet that is designed for eliminating aircraft. Always put your fighters on patrol in front of your base, so they attack any incoming aircraft.",
	--"armkam.dds "..titleColor.."Banshee (ARM T1 Aircraft)\n"..contentColor.."A light gunship that can fire at surface units. It has very weak armor, so always send them in groups and avoid anti-air (AA). It is best as a weapon of surprise.",
	--"armpeep.dds "..titleColor.."Peeper (ARM T1 Aircraft)\n"..contentColor.."A cheap and fast moving air scout. Its weapon is its huge line of sight. It is used to gain intelligence on what your enemy is planning, and where he keeps his most important units.",
	--"armthund.dds "..titleColor.."Thunder (ARM T1 Aircraft)\n"..contentColor.."A bomber designed mainly for destroying buildings. A little bit weaker than its CORE counterpart (Shadow). It can strike every 9 seconds. Press 'A' for attack and drag your RMB to execute a carpet bombing.",
	--"corca.dds "..titleColor.."Construction Aircraft (CORE T1)\n"..contentColor.."Can make basic T1 defences, economy structures and most importantly the T2 Aircraft Plant. Useful for building and reclaiming in remote areas.",
	--"corshad.dds "..titleColor.."Shadow (CORE T1 Aircraft)\n"..contentColor.."A bomber designed mainly for destroying buildings. A little bit stronger than its ARM counterpart (Thunder). It can strike every 9 seconds. Press 'A' for attack and drag your RMB to execute carpet bombing.",
	--"corvalk.dds "..titleColor.."Valkyrie (CORE T1 Aircraft)\n"..contentColor.."Airborne transportation unit. It can pick up all T1 land based units and smaller T2 units. Used for unexpected unit drops bypassing enemy's defense line.",
	--"corfink.dds "..titleColor.."Fink (CORE T1 Aircraft)\n"..contentColor.."A cheap and fast moving air scout. Its weapon is a huge line of sight. It is used to gain intelligence on what your enemy is planning, and where he keeps his most important units.",
	--"corbw.dds "..titleColor.."Bladewing (CORE T0 Drone)\n"..contentColor.."Small, fast drones armed with regular and EMP lasers.",
	--"corveng.dds "..titleColor.."Avenger(CORE T1 Aircraft)\n"..contentColor.."A fighter jet that is designed for eliminating aircraft. Always put your fighters on patrol in front of your base, so they attack any incoming aircraft.",
}

local quotes = {
	{"The two most powerful warriors are patience and time.", "Leo Tolstoy"},
	{"Know thy self, know thy enemy. A thousand battles, a thousand victories.", "Sun Tzu"},
	{"People never lie so much as after a hunt, during a war or before an election.", "Otto von Bismarck"},
	{"The best weapon against an enemy is another enemy.", "Friedrich Nietzsche"},
	{"Thus, what is of supreme importance in war is to attack the enemy's strategy.", "Sun Tzu"},
	{"Great is the guilt of an unnecessary war.", "John Adams"},
	{"I have never advocated war except as a means of peace.", "Ulysses S Grant"},
	{"War is not only a matter of equipment, artillery, group troops or air force; it is largely a matter of spirit, or morale.", "Chiang Kai-Shek"},
	{"In nuclear war all men are cremated equal.", "Dexter Gordon"},
	{"There are no absolute rules of conduct, either in peace or war. Everything depends on circumstances.", "Leon Trotsky"},
	{"Weapons are an important factor in war, but not the decisive one; it is man and not materials that counts.", "Mao Zedong"},
	{"To secure peace is to prepare for war.", "Carl von Clausewitz"},
	{"Quickness is the essence of the war.", "Sun Tzu"},
	{"The whole art of war consists of guessing at what is on the other side of the hill.", "Arthur Wellesley"},
	{"War is a game that is played with a smile. If you can't smile, grin. If you can't grin, keep out of the way till you can.", "Winston Churchill"},
	{"War can only be abolished through war, and in order to get rid of the gun it is necessary to take up the gun.", "Mao Zedong"},
	{"The quickest way of ending a war is to lose it.", "George Orwell"},
	{"Heaven cannot brook two suns, nor earth two masters.", "Alexander the Great"},
	{"People always make war when they say they love peace.", "D H Lawrence"},
	{"War is like love; it always finds a way.", "Bertolt Brecht"},
	{"Ten soldiers wisely led will beat a hundred without a head.", "Euripides"},
	{"In war there is no prize for runner-up.", "Lucius Annaeus Seneca"},
	{"I think there should be holy war against yoga classes.", "Werner herzog"},
	{"An army marches on its stomach.", "Napoleon Bonaparte"},
	{"It is fatal to enter any war without the will to win it.", "Douglas MacArthur"},
	{"You cannot simultaneously prevent and prepare for war.", "Albert Einstein"},
	{"Try not to become a man of success, but rather try to become a man of value.", "Albert Einstein"},
	{"Every failure is a step to success.", "William Whewell"},
	{"If everyone is moving forward together, then success takes care of itself.", "Henry Ford"},
	{"Failure is success if we learn from it.", "Malcolm Forbes"},
	{"It is no use saying, 'We are doing our best.' You have got to succeed in doing what is necessary.", "Winston Churchill"},
	{"Knowledge will give you power, but character respect.", "Bruce Lee"},
	{"In time of war the laws are silent.", "Marcus Tullius Cicero"},
	{"War is a contagion.", "Franklin D Roosevelt"},
	{"War is the unfolding of miscalculations.", "Barbara Tuchman"},
	{"Girl power is about loving yourself and having confidence and strength from within, so even if you're not wearing a sexy outfit, you feel sexy.", "Nicole Scherzinger"},
	{"The most common way people give up their power is by thinking they don't have any.", "Alice Walker"},
	{"Mastering others is strength. Mastering yourself is true power.", "Lao Tzu"},
	{"There is more power in unity than division.", "Emmanuel Cleaver"},
	{"I am not afraid of an army of lions led by a sheep; I am afraid of an army of sheep led by a lion.", "Alexander the Great"},
	{"The power of an air force is terrific when there is nothing to oppose it.", "Winston Churchill"},
	{"You must never underestimate the power of the eyebrow.", "Jack Black"},
	{"Common sense is not so common.", "Voltaire"},
	{"If everyone is thinking alike, then somebody isn't thinking.", "George S Patton"},
	{"Ignorance is bold and knowledge reserved.", "Thucydides"},
	{"Don't find fault, find a remedy.", "Henry Ford"},
	{"There is nothing impossible to him who will try.", "Alexander the Great"},
	{"Peace is produced by war", "Pierre Corneille"},
}


-- Since math.random is not random and always the same, we save a counter to a file and use that.
filename = "LuaUI/Config/randomseed.data"
k = os.time() % 1500
if VFS.FileExists(filename) then
	k = tonumber(VFS.LoadFile(filename))
	if not k then k = 0 end
end
k = k + 1
local file = assert(io.open(filename,'w'), "Unable to save latest randomseed from "..filename)
    file:write(k)
    file:close()
file = nil

local random_tip_or_desc = unit_descs[((k/2) % #unit_descs) + 1]
if k%2 == 1 then
	random_tip_or_desc = tips[((math.ceil(k/2)) % #tips) + 1]
--elseif k%3 == 2 then
--	random_tip_or_desc = quotes[((math.ceil(k/3)) % #quotes) + 1]
end

local loadedFontSize = 70
local font = gl.LoadFont("FreeSansBold.otf", 70, 22, 1.15)

function DrawRectRound(px,py,sx,sy,cs)

	--local csx = cs
	--local csy = cs
	--if sx-px < (cs*2) then
	--	csx = (sx-px)/2
	--	if csx < 0 then csx = 0 end
	--end
	--if sy-py < (cs*2) then
	--	csy = (sy-py)/2
	--	if csy < 0 then csy = 0 end
	--end
	--cs = math.min(cs, csy)

	gl.TexCoord(0.8,0.8)
	gl.Vertex(px+cs, py, 0)
	gl.Vertex(sx-cs, py, 0)
	gl.Vertex(sx-cs, sy, 0)
	gl.Vertex(px+cs, sy, 0)

	gl.Vertex(px, py+cs, 0)
	gl.Vertex(px+cs, py+cs, 0)
	gl.Vertex(px+cs, sy-cs, 0)
	gl.Vertex(px, sy-cs, 0)
	
	gl.Vertex(sx, py+cs, 0)
	gl.Vertex(sx-cs, py+cs, 0)
	gl.Vertex(sx-cs, sy-cs, 0)
	gl.Vertex(sx, sy-cs, 0)
	
	local offset = 0.05		-- texture offset, because else gaps could show
	local o = offset
	
	-- top left
	--if py <= 0 or px <= 0 then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(px, py, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(px+cs, py, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(px+cs, py+cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(px, py+cs, 0)
	-- top right
	--if py <= 0 or sx >= vsx then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(sx, py, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(sx-cs, py, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(sx-cs, py+cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(sx, py+cs, 0)
	-- bottom left
	--if sy >= vsy or px <= 0 then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(px, sy, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(px+cs, sy, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(px+cs, sy-cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(px, sy-cs, 0)
	-- bottom right
	--if sy >= vsy or sx >= vsx then o = 0.5 else o = offset end
	gl.TexCoord(o,o)
	gl.Vertex(sx, sy, 0)
	gl.TexCoord(o,1-o)
	gl.Vertex(sx-cs, sy, 0)
	gl.TexCoord(1-o,1-o)
	gl.Vertex(sx-cs, sy-cs, 0)
	gl.TexCoord(1-o,o)
	gl.Vertex(sx, sy-cs, 0)
end

function RectRound(px,py,sx,sy,cs)
	--local px,py,sx,sy,cs = math.floor(px),math.floor(py),math.ceil(sx),math.ceil(sy),math.floor(cs)
	
	gl.Texture(":n:luaui/Images/bgcorner.png")
	--gl.Texture(":n:luaui/Images/bgcorner.png")
	gl.BeginEnd(GL.QUADS, DrawRectRound, px,py,sx,sy,cs)
	gl.Texture(false)
end

function gradienth(px,py,sx,sy, c1,c2)
	gl.Color(c1)
	gl.Vertex(sx, sy, 0)
	gl.Vertex(sx, py, 0)
	gl.Color(c2)
	gl.Vertex(px, py, 0)
	gl.Vertex(px, sy, 0)
end


local lastLoadMessage = ""
local lastProgress = {0, 0}

local progressByLastLine = {
	["Parsing Map Information"] = {0, 20},
	["Loading Weapon Definitions"] = {10, 50},
	["Loading LuaRules"] = {40, 80},
	["Loading LuaUI"] = {70, 95},
	["Finalizing"] = {100, 100}
}
for name,val in pairs(progressByLastLine) do
	progressByLastLine[name] = {val[1]*0.01, val[2]*0.01}
end

function addon.LoadProgress(message, replaceLastLine)
	lastLoadMessage = message
	if message:find("Path") then -- pathing has no rigid messages so cant use the table
		lastProgress = {0.8, 1.0}
	end
	lastProgress = progressByLastLine[message] or lastProgress
end

function addon.DrawLoadScreen()
	local loadProgress = SG.GetLoadProgress()
	if loadProgress == 0 then
		loadProgress = lastProgress[1]
	else
		loadProgress = math.min(math.max(loadProgress, lastProgress[1]), lastProgress[2])
	end

	local vsx, vsy = gl.GetViewSizes()

	-- draw progressbar
	local hbw = 3.5/vsx
	local vbw = 3.5/vsy
	local hsw = 0.2
	local vsw = 0.2
	local yPos =  0.125 --0.054
	local yPosTips = yPos + 0.1245
	local loadvalue = 0.2 + (math.max(0, loadProgress) * 0.6)

	if not showTips then
		yPos = 0.165
		yPosTips = yPos
	end

	--bar bg
	local paddingH = 0.004
	local paddingW = paddingH * (vsy/vsx)
	gl.Color(0.085,0.085,0.085,0.925)
	RectRound(0.2-paddingW,yPos-0.05-paddingH,0.8+paddingW,yPosTips+paddingH,0.007)

	gl.Color(0,0,0,0.75)
	RectRound(0.2-paddingW,yPos-0.05-paddingH,0.8+paddingW,yPos+paddingH,0.007)

    if loadvalue > 0.215 then
	    -- loadvalue
        gl.Color(0.4-(loadProgress/7),loadProgress*0.4,0,0.4)
        RectRound(0.2,yPos-0.05,loadvalue,yPos,0.0055)

        -- loadvalue gradient
        gl.Texture(false)
        gl.BeginEnd(GL.QUADS, gradienth, 0.2,yPos-0.05,loadvalue,yPos, {1-(loadProgress/3)+0.2,loadProgress+0.2,0+0.08,0.14}, {0,0,0,0.14})

        -- loadvalue inner glow
        gl.Color(1-(loadProgress/3.5)+0.15,loadProgress+0.15,0+0.05,0.04)
        gl.Texture(":n:luaui/Images/barglow-center.png")
        gl.TexRect(0.2,yPos-0.05,loadvalue,yPos)

        -- loadvalue glow
        local glowSize = 0.06
        gl.Color(1-(loadProgress/3)+0.15,loadProgress+0.15,0+0.05,0.1)
        gl.Texture(":n:luaui/Images/barglow-center.png")
        gl.TexRect(0.2,	yPos-0.05-glowSize,	loadvalue,	yPos+glowSize)

        gl.Texture(":n:luaui/Images/barglow-edge.png")
        gl.TexRect(0.2-(glowSize*1.3), yPos-0.05-glowSize, 0.2, yPos+glowSize)
        gl.TexRect(loadvalue+(glowSize*1.3), yPos-0.05-glowSize, loadvalue, yPos+glowSize)
    end

	-- progressbar text
	gl.PushMatrix()
		gl.Scale(1/vsx,1/vsy,1)
		local barTextSize = vsy * 0.026

		--font:Print(lastLoadMessage, vsx * 0.5, vsy * 0.3, 50, "sc")
		--font:Print(Game.gameName, vsx * 0.5, vsy * 0.95, vsy * 0.07, "sca")
		font:Print(lastLoadMessage, vsx * 0.21, vsy * (yPos-0.017), barTextSize * 0.67, "oa")
		if loadProgress>0 then
			font:Print(("%.0f%%"):format(loadProgress * 100), vsx * 0.5, vsy * (yPos-0.0325), barTextSize, "oc")
		else
			font:Print("Loading...", vsx * 0.5, vsy * (yPos-0.031), barTextSize, "oc")
		end
	gl.PopMatrix()


	if showTips then
		-- In this format, there can be an optional image before the tip/description.
		-- Any image ends in .dss, so if such a text piece is found, we extract that and show it as an image.
		local text_to_show = random_tip_or_desc
		yPos = yPosTips
		if random_tip_or_desc[2] then
			text_to_show = random_tip_or_desc[1]
		else
			i, j = string.find(random_tip_or_desc, ".dds")
		end
		local numLines = 1
		local image_text = nil
		local fontSize = barTextSize * 0.77
		local image_size = 0.0485
		local height = 0.123

		if i ~= nil then
			text_to_show = string.sub(text_to_show, j+2)
			local maxWidth = ((0.58-image_size-0.012) * vsx) * (loadedFontSize/fontSize)
			text_to_show, numLines = font:WrapText(text_to_show, maxWidth)
		else
			local maxWidth = (0.585 * vsx) * (loadedFontSize/fontSize)
			text_to_show, numLines = font:WrapText(text_to_show, maxWidth)
		end

		-- Tip/unit description
		-- Background
		--gl.Color(1,1,1,0.033)
		--RectRound(0.2,yPos-height,0.8,yPos,0.005)

		-- Text
		gl.PushMatrix()
		gl.Scale(1/vsx,1/vsy,1)

		if i ~= nil then
			image_text = string.sub(random_tip_or_desc, 0, j)
			gl.Texture(":n:unitpics/" .. image_text)
			gl.Color(1.0,1.0,1.0,0.8)
			gl.TexRect(vsx * 0.21, vsy*(yPos-0.015), vsx*(0.21+image_size), (vsy*(yPos-0.015))-(vsx*image_size),false,true)
			font:Print(text_to_show, vsx * (0.21+image_size+0.012) , vsy * (yPos-0.0175), fontSize, "oa")
		else
			font:Print(text_to_show, vsx * 0.21, vsy * (yPos-0.0175), fontSize, "oa")
		end

		if random_tip_or_desc[2] then
			font:Print('\255\255\222\155'..random_tip_or_desc[2], vsx * 0.79, (vsy * ((yPos-0.0175)-height)) +(fontSize*2.66) , fontSize, "oar")
		end
		gl.PopMatrix()
	end
end


function addon.MousePress(...)
	--Spring.Echo(...)
end


function addon.Shutdown()
	gl.DeleteFont(font)
end
