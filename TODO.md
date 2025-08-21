

# High Priority
These are things that are really important (and most of it should be relatively easy to do). ergo, should be the first things we do. I generally ordered them as the highest mix between easy and urgent, but this ordering isn't set in stone. If you wanna change the order a little that's fine, just so long as you ~generally~ work your way from the top down

- __Interactable Colliders__: they're having really weird inconsistencies with detecting when the player is looking at them. I suspect this has to do with my ray tracing code
- __Enemy Collider__: I want the enemy to have two sets of colliders, one which influences it's navigation, and one for interaction. The interaction one I very fervently want to be very large so that it's as easy as possible for the enemy to aim at him (since the firing doesn't even activate without looking at him). The issue we had was that the interaction collider was overriding the navigation for the enemy collider. Just see if you can find a way to get these two sets of colliders to play nicely together. I suspect it's something to do with layers but I think I also remember running into an issue where they'd keep getting put on each others layers (I think they just both have to read from the same rigidbody? I don't remember what exactly was happening).
- __Export Settings__ look into resolution and export settings and make sure that whatever version we put out to itch looks nice and clean factors I think are likely to be issues are:
    - __itch and Godot fullscreen behavior__: Itch has a few settings for how the game displays in window, Godot has their own set of options for this. Happy to elaborate on these and where to find them but the gist is to get them to match up nicely
    - __resolution__ this'll be a broad thing to look into, but a big one will be UI sizes and whether they're all within the same "universal" resolution
    - __raycasting__ tied to the HUD, so kinda related to resolution, but check that whatever interaction raycasting I do doesn't get borked by different resolutions
__UI Icon logic__: check that all the UI behavior is working as expected
    - __keys:__ expected behavior is for the player to be able to pick up 1 key, then have that go away when they interact with a door (as does the internal isHoldingKeyBoolean). if they interact with a door when not holding a key, or try to pick up a second key, flavor text tells them "I can't do that"
    - __bullets:__ expected behavior is player can pick up up to three bullets, then press 'R' to reload the bullet, then can fire the bullet. The icons should update for each step (icon shows up, then gets a 'loaded' text bar underneath, then disappears). I don't thiiiink I remember any issues with this, but keep an eye on it
    - __reload bar:__ should show lerped progress between when the player finishes loading the gun. Be aware that this progress should match up to the animation ~*eventually*~ but there's gonna be more headaches with that (see reload animation below)
    - __Enemy health bar:__ is hidden until the first bullet, then decreases with each shot
- __Enemy Health:__ speaking of the enemy health, make sure that you set the variable back to what it had been in the code before all of my screwing with it (I lowered it to more easily test the end game). The enemy should die in three hits, therefore have a starting health of 3
- __Extra bullet?__ Fiona thinks there might be an extra extra bullet somewhere in the scene? Just check around for it there should only be three
- __UI/Menu Audio Transitions:__ I'm pretty sure I got it set up so that the music transitions when the player pauses, wins, and dies. See if that is in fact working properly, and if not see if you can fix it. You'll want to pull the most recent changes from blah (the branch, I didn't have time to come up with a better name) for this. I'm afraid I also have a bit of code on my home computer that I haven't pushed, and won't be able to until much later tonight. I'll also be available tomorrow to work out any kinks with this so feel free to wait until then to touch this task
- __Win Scene:__ we had this mostly working at one point? though I remember it being a little screwy and Idek remember whether we kept it in. Put it back in and make it not screwy
	- __most basic functionality:__  enemy dies, player is left with a bit of time after the music cuts out to let the ending sink in, then the win scene loads with a slower but almost bittersweet theme 
	- Note that the few second delay before loading the scene is intentional to add gravity to the ending. Other polish may or may not include other changes. see the section on moment polish for more details
- __Gunshot noise:__ have the gun play a "bang" sound. I'll ping Caleb to ask him to make one, but you could also probably just use a free asset online
- __Mouse Sensitivity:__ just lower it to set it to a reasonable value.
	- __(bonus) Menu Slider__ If you really want to you could also make this into a slider in an options menu. This'll probably require some work on Fiona's part but in the meantime you could maybe make a new UI element with just the slider, then Fiona and I can hook that up later
- __Reload Animations:__ This is gonna be a complicated one and will unfortunately probably need us to pester Cwyvern (and hope he responds). I'll handle the coordination on that but the short technical summary is that they reload animations (technically separate ones for the gun and the hands) don't match up nicely to the timer or each other. The matching up to each other probably requires some export finagling on Fiona's part, or if you want to learn how to do this yourself I'm happy to coordinate between you and Cwyv to get that sorted.
	- __(bonus) Scalability:__ design wise it'd be nice to be able to tweak the exact length of the animation in case we decide that a given length is too hard or too easy. I dunno how easy it is to scale the speed of animations but if it's possible then it'd be lovely 

# less urgent, but small
not important, but could make for nice little details, and should hopefully be really quick and easy. Feel free to play around with these but don't feel any pressure

- __random interactables:__ my interaction system should be mostly set up to be able to easily send signals and define new behavior. Could be fun to just throw in a few interactables here and there. examples could be:
	- __light switch:__ the player can flick a light switch to toggle another light on/off
	- __TV:__ the player can walk up to a TV and it starts playing images. I remember Fiona had ideas for a gif that we could send to a material and display on the TV. I don't thiiiink she has much set up for that but I've asked her and will lyk her response
- __Lighting Level Design:__ possibly hand in hand with the light switch interactable, but just throwing in point lights here and there to add to the ~ambiance~
- __smooth fadeout on flavor text:__ currently there's two ways the flavor text disappears. once after a few seconds, or it can also be overridden by another text prompt. tweaking the time-based disappearance to include an alpha LERP should be pretty easy and would be a nice touch. though you'd want to be careful to not break any of the rest of my system for the displays (it's quite messy) (sorry) (happy to help you with this)
- __player stats:__ little values to display to the player on the win and lose screens. biggest difficulty would be persistent data for the player deaths, which isn't an issue with unreal or Unity web builds, but idk how godot handles that data. Look into it but try not to spend long on it if it turns out to be complicated
	- __stats:__ number of times the player has died, timer, number of bullets found, keys
	- Don't worry too much about making them look good on the UI unless you want to, Fiona will be able to hook them up so long as you have the values accessible

# More in depth polish :
stuff that would be great if we can get it, but could likely take some time and are polish rather than necessity . Don't worry too much about needing to have these. If you see something on here that you'd like to do, then great. Just try to make sure you have the high priority stuff sorted first

__more in depth__
- __player death animation:__ have the player camera thrash around when dying rather than immediately cutting to the loss screen. Theoretically animations for this already exist, though haven't been imported to the engine at all
- __enemy fog/darkness:__ some sort of light-based ambiance to accompany the enemy when he gets close to the player
	- __music:__ come to think of it, the music felt like it kicks in a bit more often than would be ideal. Maybe tweaking the attenuation, sensitivity, and volume on that just a bit down could help build more suspense (or build suspense more slowly)
- __Shaders and Post Processing:__ one of Fiona's favorite things in every project. I thought that they thought you mentioned being curious about it, and it could definitely make for a great touch. I do know that if you don't do it, then they will want to 
- __Other assets?__ maybe Curtis or Caleb had other assets that didn't get used, or they want to make new ones. extra set dressing never hurts

## scene/moment polish:
both the very start and very end of the game feel a bit lacking overall. There's a few ideas for tweaking them and really adding a bit of extra oomph, but either one that could be a very huge bit of scope creep. for now I'll jot down a few ideas that have come up with it

### win:
most basic functionality (we SHOULD check that this is all in): player shoots the enemy, enemy dies, player is left with a bit of time after the music cuts out to let the ending sink in

ideally, it could be really cool to add more changes for the player to notice before the time cuts out. such as the enemy model changing to appear more humanoid, and a splatter of gory blood
remember that the 'lore' of this game is that the player experienced this break in as a child, and had to kill the stranger but is still traumatized by having taken a life. Any ways we can further allude to that would be great


### Start 
Currently trying to 'jumpscare' the player right as they start the game just doesn't work. all of these ideas center around trying to add a bit more breathing room at the very start to ease the player into it. feel free to edit this document to jot down any of your own ideas you have

we could just design the starting area so the enemy takes more time to reach the player and is behind a wall. This would probably be easiest.

I think it'd be cool to have the enemy play an animation mimicking that of breaking through a window to allude to the lore. This will require a new animation from Cwyvern though

Horror relies heavily on timing, so rather than just adding more space we could have the enemy 'activate' on a trigger. Either a volume trigger box and/or when they pick up their first key/ bullet. 
	could maybe do multiple triggers. one where the enemy starts walking, but then if they find a bullet before the enemy reaches them, the enemy rubberbands to catch up. 
	this could pair really nicely with a window break in animation, though could also work without one

rather than just adding space before the enemy reaches the player, a trigger or two before the enemy 'starts' would give the horror much more timing (comedy and horror are very similar after all and both rely heavily on timing and surprise )


# Assets

## Visual
Fix import/export settings on reload animations
__Break in Animation__: one of the ideas for polishing/fleshing out the start of the game is to have the enemy break in through the window, would be a nice hint to the lore. 
__hit/death:__ our current animations work, though I recall having some minor improvements I wanted to discuss with cwyvern depending on his interest in continued work
Player Death? (supposedly this exists, but may need some import/export tweaks)

## Audio
Gunshot Noise
__Gameplay tracks:__ I think it'd be really cool to transition between audio tracks depending on whether or not the player is close to the enemy. A hard cut could work but a slower fade would be really cool (so the ambient track fades out and the enemy track fades in as the enemy gets closer). However playing them at the same time would likely require two tracks designed for that purpose. or *at least* at the same BPM. So Caleb lmk if that's something you'd be interested in making