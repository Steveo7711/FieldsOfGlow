extends Node

# Game state
signal game_state_changed(new_state)

# Time
signal tick_passed
signal hour_changed(hour)
signal day_changed(day)

# Crops
signal crop_planted(crop_id, position)
signal crop_grew(crop_id, new_stage)
signal crop_harvested(crop_id, resource, amount)
signal crop_mutated(crop_id, trait_name)

# Spirits
signal spirit_spawned(spirit)
signal spirit_leveled_up(spirit)
signal spirit_state_changed(spirit, new_state)

# Player
signal player_harvested(crop_id, resource, amount)
signal player_interacted(target)

# AFK
signal afk_return_ready(summary_data)

# Field
signal field_harmony_changed(value)
