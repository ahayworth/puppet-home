sources = {
  'media_player.living_room_apple_tv': {
    'power': {
      'receiver': ['on'],
      'living_room_tv': ['on', 'playing'],
      'living_room_apple_tv': ['on', 'idle'],
      'xbox_one': ['off', 'standby'],
      'playstation_4': 'off',
    },
    'sources': {
      'receiver': 'strm-box',
      'living_room_tv': 'HDMI1',
    }
  },
  'media_player.playstation_4': {
    'power': {
      'receiver': ['on'],
      'living_room_tv': ['on', 'playing'],
      'living_room_apple_tv': ['off', 'standby'],
      'xbox_one': ['off', 'standby'],
      'playstation_4': ['on', 'idle'],
    },
    'sources': {
      'receiver': 'video6_pc',
      'living_room_tv': 'HDMI1',
    }
  },
  'media_player.xbox_one': {
    'power': {
      'receiver': ['on'],
      'living_room_tv': ['on', 'playing'],
      'living_room_apple_tv': ['off', 'standby'],
      'xbox_one': ['on', 'idle'],
      'playstation_4': ['off', 'standby'],
    },
    'sources': {
      'receiver': 'video6_pc',
      'living_room_tv': 'HDMI1',
    }
  },
}

desired_source = data.get('source')
logger.info("changing to source {}".format(desired_source))

power_correct = False
for x in range(0, 10):
    for mp, power in sources[desired_source]['power'].items():
        current_power = hass.states.get('media_player.{}'.format(mp)).state
        if current_power not in power:
            d = {'entity_id': 'media_player.{}'.format(mp)}
            logger.info("setting power {} for {} (currently {})".format(power, mp, current_power))
            if 'off' in power:
                hass.services.call('media_player', 'turn_off'.format(power), d, False)
            else:
                hass.services.call('media_player', 'turn_on'.format(power), d, False)
        else:
            power_correct = True

    time.sleep(1)

if not power_correct:
    logger.error("Couldn't set some device power...giving up.")

sources_correct = False
if power_correct:
    for x in range(0, 10):
        for mp, source in sources[desired_source]['sources'].items():
            current_source = hass.states.get('media_player.{}'.format(mp)).attributes.get('source')
            if current_source != source:
                d = {'entity_id': 'media_player.{}'.format(mp), 'source': source}
                logger.info("setting source {} for {} (currently {})".format(source, mp, current_source))
                hass.services.call('media_player', 'select_source', d, False)
            else:
                sources_correct = True

        time.sleep(1)

if not sources_correct:
    logger.error("Couldn't set some device sources...giving up.")
