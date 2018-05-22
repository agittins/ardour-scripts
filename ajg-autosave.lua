ardour {
	["type"]    = "EditorHook",
	name        = "[AJG] Autosave",
	author      = "Ashley Gittins <ash@ajg.net.au> https://ajg.net.au/",
	description = "Saves a snapshot every minute, keeping the last 5 minutes of backups. Files are named <session-name>-autosave-N.ardour where N is between 0 and 4",
}

--{
-- Notes:
-- 	I had issues with periodic backups / crash recoveries not doing it for me. I suspect that just editing and tweaking plugins etc
-- 	wasn't enough to trigger the autosaves. Regardless, I like the idea of having multiple savepoints at all times in case something
-- 	bad happens, which is probably not a very good feature request - but an excellent user script, so here we are.
--
-- 	Because Ardour also creates a .bak copy of any file before it overwrites it, you actually get twice as many backup snapshots
-- 	when using this script. This may please or anger you. Note that these .bak files don't show in the sessions list dialog.
--
-- 	If you want to save more often than every minute you'll need to change the filenaming, since it just uses mod-5 of the current minute
-- 	(ie, from 0 to 4, so 2:23 does 3, 2:25 is 0, 2:30 is 0, 2:38 is 3).
--
-- 	Performance considerations:
-- 	 - I didn't want to make it a Session script as running on every process cycle is unecessary and prone to hogging cpu at exactly the
-- 	   wrong times. Hence, making it an action hook (which runs in the GUI thread).
-- 	 - LuaTimerDS seems to trigger every deci-second. In the interests of not hogging cpu, the first thing to do is test if we need to run,
-- 	   and if not, bail out ASAP with minimal instructions. 
-- 	 - We could just do the save every 600 deci-seconds, but I don't know how reliable
-- 	   the timer is - we might be called twice in one minute. Easier to just check a couple of times a minute and track the last write.
--
--}

function signals ()
	s = LuaSignal.Set()
	s:add (
		{
			[LuaSignal.LuaTimerDS] = true, -- every 100ms (ie, every Deci-Second)
		}
	)
	return s
end

function factory (params)
	local _backups_to_keep = 5
	local _check_interval = 20 -- how many seconds between checks if we need to do a backup. Suggest 20.
	local _yield_timer = 1
	local _last_save = nil

	return function (signal, ref, ...)
		_yield_timer = _yield_timer - 1
		if ( _yield_timer <= 0 ) then
			_yield_timer = _check_interval * 10
			local now = os.date('%M') % _backups_to_keep

			if ( _last_save ~= now ) then -- time to save a backup!
				outfilename= ( Session:name() .. '.autosave-' .. math.floor(now) )
				print("Autosaving to " .. outfilename)
				Session:save_state(outfilename)
				_last_save = now
			end -- time to backup
		end -- yield_timer test
	end -- function
end -- factory
