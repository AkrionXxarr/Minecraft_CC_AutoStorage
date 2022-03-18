# Minecraft ComputerCraft AutoStorage

A video of the AutoStorage in operation can be found here:
https://www.youtube.com/watch?v=EzEdtINWLKQ

These scripts allow a Turtle to automatically store items into designated storage locations. Can support any depth, any height, and multiple aisles, definable by the turtle's config file.

* Server 
    * Manages Storage Database
    * Responds to queries for item locations
    * Allocates empty storage (sorted by distance)
    * Notifies Turtle when there are items in the Input chest
* Turtle
    * Helps Server build Storage Database by walking all inventory locations and determining what's inside
    * Retrieves items from Input chest
    * Queries Server for where to store items
    * Stores items and dumps excess/invalid items
* Client
    * Communicates commands to the Server and Turtle
