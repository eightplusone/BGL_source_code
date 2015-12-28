--[[
-- Author: Hai Tran
-- Date: Nov 10, 2015
-- Filename: bgl_dataLoading2.lua
-- Description: Load data from the given text file and store it in different arrays. This file has 2 functions:
--   1. loadFile(path): Load data from a file given its location. Each line of the loaded file will then stored
--      in different arrays representing 8 aspects of each interval of a day:
--        + Date of measurement
--        + Time of measurement
--        + Current glucose level
--        + Amount of short acting insulin
--        + Amount of long acting insulin
--        + Amount of food intake
--        + Amount of exercise (from 1 to 5)
--        + Level of stress
--
--   2. split(delimiter)
--
-- When we convert a Lua table to a tensor in Torch 7, we cannot pick which entry to be included. Therefore,
-- with this file, I separate different intervals into different tables. Starting from 8 tables in total in 
-- bgl_dataLoading.lua, we now have 32 tables, with 8 tables for each interval.
-- 
-- ]]

-- ====================
--
-- Load data from file
--
-- ====================

function loadFile(fileLocation)
    local file = io.open(fileLocation)

    -- 8 aspects to extract from each line of the file
    local morning_date, 
        morning_time, 
        morning_glucose, 
        morning_SAI,  -- short acting insulin 
        morning_LAI,  -- long acting insulin
        morning_food, 
        morning_exercise, 
        morning_stress,
        ----
        afternoon_date, 
        afternoon_time, 
        afternoon_glucose, 
        afternoon_SAI,  -- short acting insulin 
        afternoon_LAI,  -- long acting insulin 
        afternoon_food, 
        afternoon_exercise, 
        afternoon_stress,
        ----
        evening_date, 
        evening_time, 
        evening_glucose, 
        evening_SAI,  -- short acting insulin  
        evening_LAI,  -- long acting insulin 
        evening_food, 
        evening_exercise, 
        evening_stress,
        ----
        night_date, 
        night_time, 
        night_glucose, 
        night_SAI,  -- short acting insulin  
        night_LAI,  -- long acting insulin 
        night_food, 
        night_exercise, 
        night_stress 

        = { }, { }, { }, { }, { }, { }, { }, { },
        { }, { }, { }, { }, { }, { }, { }, { },
        { }, { }, { }, { }, { }, { }, { }, { },
        { }, { }, { }, { }, { }, { }, { }, { }

    if file then
    	local lineCounter = 1

    	-- Iterate through every line of the data file and insert values into the arrays
    	for line in file:lines() do

            -- It's strange here. I always received an integer when I divide lineCounter by 2,
            -- but in this case, I have to call math.ceil to round the division.
            local i = math.ceil(lineCounter / 8)

            if lineCounter % 8 == 2 then
        		morning_date[i], 
                morning_time[i], 
                morning_glucose[i], 
                morning_SAI[i], 
                morning_LAI[i], 
                morning_food[i], 
                morning_exercise[i], 
                morning_stress[i] 
                = unpack(line:split(";"))
    		end

            if lineCounter % 8 == 4 then
                afternoon_date[i], 
                afternoon_time[i], 
                afternoon_glucose[i], 
                afternoon_SAI[i], 
                afternoon_LAI[i], 
                afternoon_food[i], 
                afternoon_exercise[i], 
                afternoon_stress[i] 
                = unpack(line:split(";"))
            end

            if lineCounter % 8 == 6 then
                evening_date[i], 
                evening_time[i], 
                evening_glucose[i], 
                evening_SAI[i], 
                evening_LAI[i], 
                evening_food[i], 
                evening_exercise[i], 
                evening_stress[i] 
                = unpack(line:split(";"))
            end

            if lineCounter % 8 == 0 then
                night_date[i], 
                night_time[i], 
                night_glucose[i], 
                night_SAI[i], 
                night_LAI[i], 
                night_food[i], 
                night_exercise[i], 
                night_stress[i] 
                = unpack(line:split(";"))
            end

            -- Go to the next line
            lineCounter = lineCounter + 1
    	end
        
    else
    	print("Cannot open file") 
    end

    for i = 1, #morning_date do
        if (morning_glucose[i] == nil) then
            morning_glucose[i] = 0
        else
            morning_glucose[i] = tonumber(morning_glucose[i])
        end

        if (morning_SAI[i] == nil) then
            morning_SAI[i] = 0
        else
            morning_SAI[i] = tonumber(morning_SAI[i])
        end

        if (morning_LAI[i] == nil) then
            morning_LAI[i] = 0
        else
            morning_LAI[i] = tonumber(morning_LAI[i])
        end

        if (morning_food[i] == nil) then
            morning_food[i] = 0
        else
            morning_food[i] = tonumber(morning_food[i])
        end

        if (morning_exercise[i] == nil) then
            morning_exercise[i] = 0
        else
            morning_exercise[i] = tonumber(morning_exercise[i])
        end

        if (morning_stress[i] == nil) then
            morning_stress[i] = 0
        else
            morning_stress[i] = tonumber(morning_stress[i])
        end

        if (afternoon_glucose[i] == nil) then
            afternoon_glucose[i] = 0
        else
            afternoon_glucose[i] = tonumber(afternoon_glucose[i])
        end

        if (afternoon_SAI[i] == nil) then
            afternoon_SAI[i] = 0
        else
            afternoon_SAI[i] = tonumber(afternoon_SAI[i])
        end

        if (afternoon_LAI[i] == nil) then
            afternoon_LAI[i] = 0
        else
            afternoon_LAI[i] = tonumber(afternoon_LAI[i])
        end

        if (afternoon_food[i] == nil) then
            afternoon_food[i] = 0
        else
            afternoon_food[i] = tonumber(afternoon_food[i])
        end

        if (afternoon_exercise[i] == nil) then
            afternoon_exercise[i] = 0
        else
            afternoon_exercise[i] = tonumber(afternoon_exercise[i])
        end

        if (afternoon_stress[i] == nil) then
            afternoon_stress[i] = 0
        else
            afternoon_stress[i] = tonumber(afternoon_stress[i])
        end

        if (evening_glucose[i] == nil) then
            evening_glucose[i] = 0
        else
            evening_glucose[i] = tonumber(evening_glucose[i])
        end

        if (evening_SAI[i] == nil) then
            evening_SAI[i] = 0
        else
            evening_SAI[i] = tonumber(evening_SAI[i])
        end

        if (evening_LAI[i] == nil) then
            evening_LAI[i] = 0
        else
            evening_LAI[i] = tonumber(evening_LAI[i])
        end

        if (evening_food[i] == nil) then
            evening_food[i] = 0
        else
            evening_food[i] = tonumber(evening_food[i])
        end

        if (evening_exercise[i] == nil) then
            evening_exercise[i] = 0
        else
            evening_exercise[i] = tonumber(evening_exercise[i])
        end

        if (evening_stress[i] == nil) then
            evening_stress[i] = 0
        else
            evening_stress[i] = tonumber(evening_stress[i])
        end

        if (night_glucose[i] == nil) then
            night_glucose[i] = 0
        else
            night_glucose[i] = tonumber(night_glucose[i])
        end

        if (night_SAI[i] == nil) then
            night_SAI[i] = 0
        else
            night_SAI[i] = tonumber(night_SAI[i])
        end

        if (night_LAI[i] == nil) then
            night_LAI[i] = 0
        else
            night_LAI[i] = tonumber(night_LAI[i])
        end

        if (night_food[i] == nil) then
            night_food[i] = 0
        else
            night_food[i] = tonumber(night_food[i])
        end

        if (night_exercise[i] == nil) then
            night_exercise[i] = 0
        else
            night_exercise[i] = tonumber(night_exercise[i])
        end

        if (night_stress[i] == nil) then
            night_stress[i] = 0
        else
            night_stress[i] = tonumber(night_stress[i])
        end


        --[[
        morning_glucose[i] = tonumber(morning_glucose[i]) 
        morning_SAI[i] = tonumber(morning_SAI[i])
        morning_LAI[i] = tonumber(morning_LAI[i])
        morning_food[i] = tonumber(morning_food[i])
        morning_exercise[i] = tonumber(morning_exercise[i])
        morning_stress[i] = tonumber(morning_stress[i])
        ----
        afternoon_glucose[i] = tonumber(afternoon_glucose[i])
        afternoon_SAI[i] = tonumber(afternoon_SAI[i])
        afternoon_LAI[i] = tonumber(afternoon_LAI[i])
        afternoon_food[i] = tonumber(afternoon_food[i])
        afternoon_exercise[i] = tonumber(afternoon_exercise[i])
        afternoon_stress[i] = tonumber(afternoon_stress[i])
        ----
        evening_glucose[i] = tonumber(evening_glucose[i])
        evening_SAI[i] = tonumber(evening_SAI[i])
        evening_LAI[i] = tonumber(evening_LAI[i])
        evening_food[i] = tonumber(evening_food[i])
        evening_exercise[i] = tonumber(evening_exercise[i])
        evening_stress[i] = tonumber(evening_stress[i])
        ----
        night_glucose[i] = tonumber(night_glucose[i])
        night_SAI[i] = tonumber(night_SAI[i])
        night_LAI[i] = tonumber(night_LAI[i])
        night_food[i] = tonumber(night_food[i])
        night_exercise[i] = tonumber(night_exercise[i])
        night_stress[i] = tonumber(night_stress[i])
        ]]
    end


    -- It's interesting that Lua can return multiple values like this. Very convenient.
    return 
        morning_date, 
        morning_time, 
        morning_glucose, 
        morning_SAI,  -- short acting insulin 
        morning_LAI,  -- long acting insulin
        morning_food, 
        morning_exercise, 
        morning_stress,
        ----
        afternoon_date, 
        afternoon_time, 
        afternoon_glucose, 
        afternoon_SAI,  -- short acting insulin 
        afternoon_LAI,  -- long acting insulin 
        afternoon_food, 
        afternoon_exercise, 
        afternoon_stress,
        ----
        evening_date, 
        evening_time, 
        evening_glucose, 
        evening_SAI,  -- short acting insulin  
        evening_LAI,  -- long acting insulin 
        evening_food, 
        evening_exercise, 
        evening_stress,
        ----
        night_date, 
        night_time, 
        night_glucose, 
        night_SAI,  -- short acting insulin  
        night_LAI,  -- long acting insulin 
        night_food, 
        night_exercise, 
        night_stress 
end



-- ====================
--
-- Split a string 
-- The following code is derived from
--   http://stackoverflow.com/questions/19262761/lua-need-to-split-at-comma
--
-- ====================

function string:split(delimiter, returnResult)

    -- In Lua, a function can be called without being given enough parameters.
    -- In the case of this function, we can call stringA:split(';') -- it's
    -- totally fine. However, that function call will not result in anything
    -- if we don't include the below if statement. The reason is returnResult
    -- is not initiated; the function has no address to return its values to.
    if not returnResult then
        returnResult = { }
    end

    -- A pointer that iterates along the given string
    local currPtr = 1

    -- Indicates the first and the last letters of the substring
    local subStringBegin, subStringEnd = string.find(self, delimiter, currPtr)
    
    -- Keep iterating while the string.find() function still returns a non-nil value
    while subStringBegin do
        
        -- Cut the substring from the current position and insert it into returnResult.
        -- If a substring is empty, the value we put into returnResult will be 0.
        local sub = string.sub(self, currPtr, subStringBegin-1)
        if sub == nil or sub == '' then
           sub = 0
        end
        table.insert(returnResult, sub)

        -- Move everything forward
        currPtr = subStringEnd + 1
        subStringBegin, subStringEnd = string.find(self, delimiter, currPtr)
    end

    -- Insert the last piece of the string into returnResult
    table.insert(returnResult, string.sub(self, currPtr))

    return returnResult
end
