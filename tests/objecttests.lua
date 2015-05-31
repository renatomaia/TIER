local encoding  = require"encoding"
local primitive = require"encoding.primitive"
local standard	= require"encoding.standard"
local testing   = require"tests.testing"


print("Starting object tests")

local tuple   		= standard.tuple(primitive.stream, primitive.varint)
local objectlist   	= standard.list(standard.object(tuple))
local outstream      = testing.outstream();
local encoder 		= encoding.encoder(outstream)

local shared = 
{
	{
		"Foo", 2	
	},
	{
		"Bar", 2
	}	
}

local data = 
{
	shared[1],
	shared[1],
	shared[2],
	shared[1],
	shared[2],
	shared[1]
}


encoder:encode(objectlist, data)

local decoder = encoding.decoder(testing.instream(outstream.buffer))
local value = decoder:decode(objectlist)
assert(#value == 6)
assert(value[1] == value[2])
assert(value[1] == value[4])
assert(value[1] == value[6])
assert(value[3] == value[5])

print("all tests succeeded")