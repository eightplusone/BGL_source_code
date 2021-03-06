--[[
-- Author: Hai Tran
-- Date: May 22, 2016
-- File: doall.lua
--]]

require "optim"
require "nn"
require "gnuplot"
require("CustomLinear.lua")


-------------------------------------------------------------------------------
-- Constants.
--
INPUT_SIZE = 23
DATASET_SIZE = 305
TEST_SIZE = 60
NUM_FOLDS = 7
SUBSET_SIZE = 35


-------------------------------------------------------------------------------
-- Configuration
params = {
	seed = 1,  -- initial random seed
	threads = 1,  -- number of threads
	beta = 1e1,  -- prediction error coefficient
	batch_size = 1,  -- batch size
	max_epoch = 1e7,  -- max number of updates
}

optimState = {
	learningRate = 1e-5
	--, momentum = 1e-4
	, weightDecay = 1e-5
	, learningRateDecay = 1e-8
}

torch.manualSeed(os.clock())


-------------------------------------------------------------------------------
-- Run
--
-- Load files
dofile "1-data.lua"
load_data("data/data.txt")
local data, target = gen_data()

dofile "2-model.lua"
model, criterion = buildModel(1, 1, 1, 1, "sigmoid")

dofile "3-train.lua"

-- Build models and train
-- Number of hidden layers and hidden nodes are considered based on
-- number of input (23) and number of samples (305)
--   Layers: 2 -> 5
--   Nodes: 20 -> 25
for num_hidden_layers = 2, 2 do
	for num_hidden_nodes = 20, 20 do
		for turn = 1, 1 do
			print("\nNum of hidden layers: ", num_hidden_layers, "\nNum of hidden nodes: ", num_hidden_nodes, "\nTurn: ", turn)

			local log, logErr = io.open("log.txt", "a+")
			if logErr then 
				print("File open error")
				break
			end

			local timer = torch.Timer()

			-- Shuffle dataset
			local indices = torch.randperm(DATASET_SIZE)
			local train_indices, validate_indices, test_indices = {}, {}, {}

			-- Leave out the last indices for test set
			for i = DATASET_SIZE, DATASET_SIZE - TEST_SIZE + 1 do
				table.add(test_indices, indices[i])
			end

			-- For train and validate, use k-fold cross-validation
			local indices_train = torch.randperm(DATASET_SIZE - TEST_SIZE)
			local idx = {}
			-- Assign data into subsets
			for fold = 1, NUM_FOLDS do
				idx[fold] = {}
				for i = 1, SUBSET_SIZE do
					table.add(idx[fold], 
						indices[ indices_train[ (fold-1)*SUBSET_SIZE+i ] ])
				end
			end

			-- Train & Validate
			for fold = 1, NUM_FOLDS do
				for i = 1, NUM_FOLDS do
					if i ~= fold then
						-- Train
					else
						-- Validate
					end
				end
			end

			-- Log
			--
			log:write("\n-------------------------------------------\n")
			log:write("\nNum of hidden layers: ", num_hidden_layers)
			log:write("\nNum of hidden nodes: ", num_hidden_nodes)
			log:write("\nTurn: ", turn)
			log:write("\nTrain & Test Error: ")
			for fold = 1, NUM_FOLDS do
				log:write("\n" .. train_err[fold] .. ", " .. test_err[fold])
			end
			log:write("\nAverage Test Error: ", total_test_err/not_nan_counter)
			log:write("\nTime: ", timer:time().real)
			log:close()

			print("Total time: " .. timer:time().real .. " seconds\n")

			-- Plot
			--
			local graphFile = 'graph_' .. num_hidden_layers .. '_' .. num_hidden_nodes .. '_' .. turn .. '_' .. '.png'
			gnuplot.pngfigure(graphFile)
			gnuplot.title('Training & Test loss')
			gnuplot.ylabel('Loss')
			gnuplot.xlabel('Epoch')
			gnuplot.plot(
				{'Training Loss', torch.Tensor(train_plot[1])}
				, {'Test Loss', torch.Tensor(test_plot[1])}
			)
			gnuplot.plotflush()
		end
	end
end
