package net.bigpoint.darkorbit.map.view2D.effects
{
   import net.bigpoint.darkorbit.map.common.AbstractViewEffectsManager;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AirstrikeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.LaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.RocketEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.StopLaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.drive.DriveAreaEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.ShipVisualBudget2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.ChasingShotEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.DamageEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.EMPEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.PyroEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.ShockwaveEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.laser.LaserEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.laser.StopLaserEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.rocket.AirstrikeEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.rocket.BezierRocketEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.rocket.Rocket2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.rocket.RocketEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.AbsorbationBeamEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.AchievementGainEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.AntiMineTransmitterEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.AssimilateEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.BerserkEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ChainBoltEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ChargeShotEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.CollectorBeamEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ConstructingEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.DDOLEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.DecloakEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.DeflectorShieldEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.DisruptionEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.DrawFireEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.EmergencyRepairEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.EmergencyReservesEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.EmitterBeamEffectView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.EnergyLeechTechEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.FireworksEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.FortifyEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.FrostFieldEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.GhostNPCEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.GlowingRingEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.HeatReleaseEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.HologramEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.IcyCubeEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.IncinerateEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.InstaShieldEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.InvincibilityEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.KillStreakActivationEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.KillStreakCloudEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.KillStreakTrailEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.LevelUpEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.LongRangeLaser2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.MapObjectGlowRingEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.MarkedByReconEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.MayhemWinnerEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.MimesisTurretOpenEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.MirroredControlsEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ModuleInstallEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.NeutralizingTargetEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.NoxiousNebulaEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.NoxiousNebulaRadiusEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.OutOfRangeEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.POIZoneExplosionEffectContainer2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.PetSpawnEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.PhaseOutEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.PlagueCureEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.PlagueEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.PolarityPowerupEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ProtectedEffectView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ProtectionEffectView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.PvPProtectionEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.PvpModeEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.RadiationEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.RageEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.RapidFireEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.RedirectEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.RepairRobotEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.RevengeEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ReversalEnemyEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ReversalSelfEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ScrambleEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ShieldDisarrayEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ShieldEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ShipGlowEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ShipWarpEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SkillEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.Skulleffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SlowDownEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SnipedLaser2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SolaceEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SpawnChildrenEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SpawnEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SpawnEffectWithFadeIn2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SpeedBuffEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SpeedBurstEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SphereShieldEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.SpreadEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.StickyBombEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.StreunerTurretOpenEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.TargetEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.TartarusSpeedBoostEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.TechShieldBackupEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ValentineBuffEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.WarpPowerupEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.WorldBossContinuousLaserBeamEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.WorldBossMissileTelegraphEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.cannon.CannonBeamEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.cannon.CannonChainLightningEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.cannon.CannonHitEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.cannon.CannonPositionAreaEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.cannon.CannonSkillCorrosiveEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.cannon.CannonSkillThermalEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.cannon.CannonThermalWavesEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.drive.DriveAreaEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.drive.DriveShieldEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.paladin.LastStandEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.paladin.RipperEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss.BossEmpShockEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss.BossEnergyBayActivateEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss.BossEnergyBayEmpEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss.BossEscapeEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss.BossLaserChargeEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss.BossLaserShotEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss.BossLaserWarningEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss.BossShieldEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.retiarus.BuffEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.retiarus.LastPersistantEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.strikeAndExit.EscapeZoneEffect2D;
   
   public class EffectsManager2D extends AbstractViewEffectsManager
   {
      
      private static const MAP:Object = {};
      
      MAP[EffectIDList.GLOWING_RING_EFFECT] = GlowingRingEffect2D;
      MAP[EffectIDList.REP_BOT_EFFECT] = RepairRobotEffect2D;
      MAP[EffectIDList.COLLECTOR_BEAM] = CollectorBeamEffect2D;
      MAP[EffectIDList.MIRRORED_CONTROLS_EFFECT] = MirroredControlsEffect2D;
      MAP[EffectIDList.BIG_PUMPKIN_ABILITY_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.HOME_BONUS_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.SATURN_EVIL_GLOW_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.SOLAR_GLOW_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.EMBRACING_GLOW_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.UBER_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.WARGAME_GLOW_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.TECH_BATTLE_REP_BOT_EFFECT] = RepairRobotEffect2D;
      MAP[EffectIDList.TECH_BATTLE_REP_BOT_EFFECT2] = RepairRobotEffect2D;
      MAP[EffectIDList.TECH_ENERGY_LEECH_EFFECT] = EnergyLeechTechEffect2D;
      MAP[EffectIDList.TECH_SHIELD_BACKUP_EFFECT] = TechShieldBackupEffect2D;
      MAP[EffectIDList.TECH_SHIELD_BACKUP_EFFECT_2] = TechShieldBackupEffect2D;
      MAP[EffectIDList.DECLOAK_EFFECT] = DecloakEffect2D;
      MAP[EffectIDList.SHIP_WARP_EFFECT] = ShipWarpEffect2D;
      MAP[EffectIDList.WARP_POWERUP_EFFECT] = WarpPowerupEffect2D;
      MAP[EffectIDList.LEVEL_UP_EFFECT] = LevelUpEffect2D;
      MAP[EffectIDList.ACHIEVEMENT_GAIN_EFFECT] = AchievementGainEffect2D;
      MAP[EffectIDList.CONSTRUCTING_EFFECT] = ConstructingEffect2D;
      MAP[EffectIDList.DEFLECTOR_SHIELD_EFFECT] = DeflectorShieldEffect2D;
      MAP[EffectIDList.DRAW_FIRE_EFFECT] = DrawFireEffect2D;
      MAP[EffectIDList.EMERGENCY_REPAIR_EFFECT] = EmergencyRepairEffect2D;
      MAP[EffectIDList.HEAL_EFFECT] = EmergencyRepairEffect2D;
      MAP[EffectIDList.GHOST_NPC_EFFECT] = GhostNPCEffect2D;
      MAP[EffectIDList.MARKED_BY_RECON_EFFECT] = MarkedByReconEffect2D;
      MAP[EffectIDList.MODULE_INSTALL_EFFECT] = ModuleInstallEffect2D;
      MAP[EffectIDList.SHIELD_EFFECT] = ShieldEffect2D;
      MAP[EffectIDList.SPHERE_SHIELD_EFFECT] = SphereShieldEffect2D;
      MAP[EffectIDList.RAGE] = RageEffect2D;
      MAP[EffectIDList.STICKYBOMB_EFFECT] = StickyBombEffect2D;
      MAP[EffectIDList.CHARGING_BLOB_EFFECT] = StickyBombEffect2D;
      MAP[EffectIDList.PROTECTION_EFFECT] = ProtectionEffectView2D;
      MAP[EffectIDList.PROTECTED_EFFECT] = ProtectedEffectView2D;
      MAP[EffectIDList.ABSORBATION_EFFECT] = AbsorbationBeamEffect2D;
      MAP[EffectIDList.PET_SPAWN] = PetSpawnEffect2D;
      MAP[EffectIDList.POIZONE_EXPLOSION_EFFECT_CONTAINER] = POIZoneExplosionEffectContainer2D;
      MAP[EffectIDList.SPAWN] = SpawnEffect2D;
      MAP[EffectIDList.SPEED_BUFF_EFFECT] = SpeedBuffEffect2D;
      MAP[EffectIDList.INVINCIBILITY] = InvincibilityEffect2D;
      MAP[EffectIDList.SKULL] = Skulleffect2D;
      MAP[EffectIDList.SLOW_DOWN_EFFECT] = SlowDownEffect2D;
      MAP[EffectIDList.HEALBEAM_EFFECT] = EmitterBeamEffectView2D;
      MAP[EffectIDList.CHARGE_SHIELD_BEAM_EFFECT] = EmitterBeamEffectView2D;
      MAP[EffectIDList.DAMAGE_TRANSFER_BEAM_EFFECT] = EmitterBeamEffectView2D;
      MAP[EffectIDList.POLARITY_POWERUP_EFFECT] = PolarityPowerupEffect2D;
      MAP[EffectIDList.EMPEROR_LORDAKIUM_SPAWN_EFFECT] = SpawnEffectWithFadeIn2D;
      MAP[EffectIDList.FORTIFY_EFFECT] = FortifyEffect2D;
      MAP[EffectIDList.SPAWN_CHILDREN_EFFECT] = SpawnChildrenEffect2D;
      MAP[EffectIDList.PYRO] = PyroEffect2D;
      MAP[EffectIDList.EMP] = EMPEffect2D;
      MAP[EffectIDList.DAMAGE] = DamageEffect2D;
      MAP[EffectIDList.SHOCKWAVE] = ShockwaveEffect2D;
      MAP[EffectIDList.CHASING_SHOT] = ChasingShotEffect2D;
      MAP[EffectIDList.FIREWORKS] = FireworksEffect2D;
      MAP[EffectIDList.RADIATION_EFFECT] = RadiationEffect2D;
      MAP[EffectIDList.OUT_OF_RANGE_EFFECT] = OutOfRangeEffect2D;
      MAP[EffectIDList.CHAIN_BOLT] = ChainBoltEffect2D;
      MAP[EffectIDList.SOLACE_EFFECT] = SolaceEffect2D;
      MAP[EffectIDList.DIMINISHER_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.SENTINEL_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.SPECTRUM_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.VENOM_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.LASER] = LaserEffect2D;
      MAP[EffectIDList.STOP_LASER] = StopLaserEffect2D;
      MAP[EffectIDList.ROCKET] = RocketEffect2D;
      MAP[EffectIDList.AIRSTRIKE] = AirstrikeEffect2D;
      MAP[EffectIDList.ICY_CUBE_EFFECT] = IcyCubeEffect2D;
      MAP[EffectIDList.MARK_TARGET_EFFECT] = TargetEffect2D;
      MAP[EffectIDList.INSTA_SHIELD] = InstaShieldEffect2D;
      MAP[EffectIDList.PLAGUE_EFFECT] = PlagueEffect2D;
      MAP[EffectIDList.PLAGUE_CURE] = PlagueCureEffect2D;
      MAP[EffectIDList.DISRUPTION_EFFECT] = DisruptionEffect2D;
      MAP[EffectIDList.STREUNER_TURRET_OPEN_EFFECT] = StreunerTurretOpenEffect2D;
      MAP[EffectIDList.TARTARUS_SPEEDBUFF_EFFECT] = TartarusSpeedBoostEffect2D;
      MAP[EffectIDList.RAPID_FIRE_EFFECT] = RapidFireEffect2D;
      MAP[EffectIDList.SCRAMBLE_EFFECT] = ScrambleEffect2D;
      MAP[EffectIDList.PHASE_OUT_EFFECT] = PhaseOutEffect2D;
      MAP[EffectIDList.HOLOGRAM_EFFECT] = HologramEffect2D;
      MAP[EffectIDList.LONG_RANGE_LASER] = LongRangeLaser2D;
      MAP[EffectIDList.ABSORB_SHIELD_AND_HP_EFFECT] = EmitterBeamEffectView2D;
      MAP[EffectIDList.MAYHEM_RAGE_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.MAYHEM_WINNER_EFFECT] = MayhemWinnerEffect2D;
      MAP[EffectIDList.PARTICLE_BEAM] = ChainBoltEffect2D;
      MAP[EffectIDList.PVP_PROTECTION] = PvPProtectionEffect2D;
      MAP[EffectIDList.KILL_STREAK_CLOUD_EFFECT] = KillStreakCloudEffect2D;
      MAP[EffectIDList.KILL_STREAK_TRAIL_EFFECT] = KillStreakTrailEffect2D;
      MAP[EffectIDList.KILL_STREAK_ACTIVATION_EFFECT] = KillStreakActivationEffect2D;
      MAP[EffectIDList.PROMETHEUS_KILL_STREAK_CLOUD_EFFECT] = KillStreakCloudEffect2D;
      MAP[EffectIDList.PROMETHEUS_KILL_STREAK_TRAIL_EFFECT] = KillStreakTrailEffect2D;
      MAP[EffectIDList.PROMETHEUS_KILL_STREAK_ACTIVATION_EFFECT] = KillStreakActivationEffect2D;
      MAP[EffectIDList.REDIRECT] = RedirectEffect2D;
      MAP[EffectIDList.SHIELD_DISARRAY] = ShieldDisarrayEffect2D;
      MAP[EffectIDList.DISTRIBUTED_DENIAL_OF_LASERS] = DDOLEffect2D;
      MAP[EffectIDList.SHIELD_LINK] = ChainBoltEffect2D;
      MAP[EffectIDList.BERSERK] = BerserkEffect2D;
      MAP[EffectIDList.REVENGE] = RevengeEffect2D;
      MAP[EffectIDList.HP_LINK] = ChainBoltEffect2D;
      MAP[EffectIDList.INCINERATE] = IncinerateEffect2D;
      MAP[EffectIDList.VALENTINE_BUFF] = ValentineBuffEffect2D;
      MAP[EffectIDList.SPREAD_EFFECT] = SpreadEffect2D;
      MAP[EffectIDList.MAPOBJECT_GLOWING_RING_EFFECT] = MapObjectGlowRingEffect2D;
      MAP[EffectIDList.CHARGE_SHOT] = ChargeShotEffect2D;
      MAP[EffectIDList.SPEED_BURST] = SpeedBurstEffect2D;
      MAP[EffectIDList.ANTI_MINE_TRANSMITTER] = AntiMineTransmitterEffect2D;
      MAP[EffectIDList.SHIP_GLOW_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.EMERGENCY_RESERVES] = EmergencyReservesEffect2D;
      MAP[EffectIDList.ASSIMILATE] = AssimilateEffect2D;
      MAP[EffectIDList.PVP_MODE] = PvpModeEffect2D;
      MAP[EffectIDList.FROST_FIELD] = FrostFieldEffect2D;
      MAP[EffectIDList.REVERSAL_SELF_EFFECT] = ReversalSelfEffect2D;
      MAP[EffectIDList.REVERSAL_ENEMY_EFFECT] = ReversalEnemyEffect2D;
      MAP[EffectIDList.PRISMATIC_ENDURANCE_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.SELF_REPAIR_EFFECT] = EmitterBeamEffectView2D;
      MAP[EffectIDList.STOCKPILE_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.HEAT_RELEASE_EFFECT] = HeatReleaseEffect2D;
      MAP[EffectIDList.JAMX_CREED_DAMAGE_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.NEUTRALIZING_TARGET] = NeutralizingTargetEffect2D;
      MAP[EffectIDList.VOLTAGE_LINK_EFFECT] = ChainBoltEffect2D;
      MAP[EffectIDList.STUN_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.VOLT_DISCHARGE_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.VOLT_BACKUP_EFFECT] = SkillEffect2D;
      MAP[EffectIDList.MIMESIS_TURRET_OPEN_EFFECT] = MimesisTurretOpenEffect2D;
      MAP[EffectIDList.SHEER_CHAOS_EFFECT] = ShipGlowEffect2D;
      MAP[EffectIDList.WORLDBOSS_MISSILE_TELEGRAPH_EFFECT] = WorldBossMissileTelegraphEffect2D;
      MAP[EffectIDList.NOXIOUS_NEBULA_EFFECT] = NoxiousNebulaEffect2D;
      MAP[EffectIDList.NOXIOUS_NEBULA_RADIUS_EFFECT] = NoxiousNebulaRadiusEffect2D;
      MAP[EffectIDList.BEZIER_ROCKET_EFFECT] = BezierRocketEffect2D;
      MAP[EffectIDList.WORLDBOSS_CONTINUOUS_LASER_BEAM_EFFECT] = WorldBossContinuousLaserBeamEffect2D;
      MAP[EffectIDList.SNIPED_LASER_EFFECT] = SnipedLaser2D;
      MAP[EffectIDList.M_LASER_BEAM_EFFECT] = EmitterBeamEffectView2D;
      MAP[EffectIDList.LAST_STAND] = LastStandEffect2D;
      MAP[EffectIDList.RIPPER] = RipperEffect2D;
      MAP[EffectIDList.BOSS_LASER_CHARGE] = BossLaserChargeEffect2D;
      MAP[EffectIDList.BOSS_EMP_SHOCK] = BossEmpShockEffect2D;
      MAP[EffectIDList.BOSS_ENERGY_BAY_ACTIVATE] = BossEnergyBayActivateEffect2D;
      MAP[EffectIDList.BOSS_ENERGY_BAY_EMP] = BossEnergyBayEmpEffect2D;
      MAP[EffectIDList.BOSS_ENERGY_BAY_LINK] = ChainBoltEffect2D;
      MAP[EffectIDList.BOSS_LASER_WARNING] = BossLaserWarningEffect2D;
      MAP[EffectIDList.BOSS_LASER_SHOT] = BossLaserShotEffect2D;
      MAP[EffectIDList.BOSS_ESCAPE] = BossEscapeEffect2D;
      MAP[EffectIDList.BOSS_SHIELD] = BossShieldEffect2D;
      MAP[EffectIDList.ESCAPE_ZONE] = EscapeZoneEffect2D;
      MAP[EffectIDList.CANNON_HIT] = CannonHitEffect2D;
      MAP[EffectIDList.CANNON_SHOT] = CannonBeamEffect2D;
      MAP[EffectIDList.CANNON_SKILL_THERMAL] = CannonSkillThermalEffect2D;
      MAP[EffectIDList.CANNON_SKILL_CORROSIVE] = CannonSkillCorrosiveEffect2D;
      MAP[EffectIDList.CANNON_SKILL_ELECTRO] = CannonChainLightningEffect2D;
      MAP[EffectIDList.CANNON_THERMAL_WAVES] = CannonThermalWavesEffect2D;
      MAP[EffectIDList.CANNON_POSITION_AREA] = CannonPositionAreaEffect2D;
      MAP[EffectIDList.CHSP_UP] = LastPersistantEffect2D;
      MAP[EffectIDList.CHSP_W_UP] = LastPersistantEffect2D;
      MAP[EffectIDList.SPCP_UP] = BuffEffect2D;
      MAP[EffectIDList.SPCP_W_UP] = BuffEffect2D;
      MAP[EffectIDList.CHSP_HIT] = ShieldEffect2D;
      MAP[EffectIDList.CHSP_W_HIT] = ShieldEffect2D;
      MAP[EffectIDList.CHSP_OUT_BREAK] = LastPersistantEffect2D;
      MAP[EffectIDList.CHSP_W_OUT_BREAK] = LastPersistantEffect2D;
      MAP[EffectIDList.DA_OUTER_ENEMY_01] = DriveAreaEffect2D;
      MAP[EffectIDList.DA_OUTER_FRIENDLY_01] = DriveAreaEffect2D;
      MAP[EffectIDList.DA_OUTER_ENEMY_02] = DriveAreaEffect2D;
      MAP[EffectIDList.DA_OUTER_FRIENDLY_02] = DriveAreaEffect2D;
      MAP[EffectIDList.DA_OUTER_ENEMY_03] = DriveAreaEffect2D;
      MAP[EffectIDList.DA_OUTER_FRIENDLY_03] = DriveAreaEffect2D;
      MAP[EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE] = DriveAreaEffect2D;
      MAP[EffectIDList.DA_END_FRIENDLY] = DriveShieldEffect2D;
      MAP[EffectIDList.DA_START_FRIENDLY] = DriveShieldEffect2D;
      MAP[EffectIDList.DA_END_ENEMY] = DriveShieldEffect2D;
      MAP[EffectIDList.DA_START_ENEMY] = DriveShieldEffect2D;
      MAP[EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_START] = DriveShieldEffect2D;
      MAP[EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_END] = DriveShieldEffect2D;
      
      private var _view:MapView2D;
      
      public function EffectsManager2D(param1:MapView2D)
      {
         this._view = param1;
         super();
      }
      
      override protected function buildEffect(param1:Effect) : Object
      {
         var _loc6_:Object = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:Object = param1 is LaserEffect ? LaserEffect(param1).attacker : (param1 is RocketEffect ? RocketEffect(param1).attacker : (param1 is AirstrikeEffect ? AirstrikeEffect(param1).attacker : (param1 is StopLaserEffect ? StopLaserEffect(param1).attacker : (param1 is MapObjectEffect ? MapObjectEffect(param1).source : (param1 is PyroEffect ? PyroEffect(param1).target : null)))));
         if(Boolean(_loc2_) && (Boolean(param1.id == EffectIDList.DA_END_FRIENDLY || param1.id == EffectIDList.DA_START_FRIENDLY || param1.id == EffectIDList.DA_END_ENEMY || param1.id == EffectIDList.DA_START_ENEMY || param1.id == EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_START || param1.id == EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_END)) && !EffectRange2D.near(_loc2_.position,800))
         {
            return null;
         }
         var _loc3_:Object = param1 is LaserEffect ? LaserEffect(param1).target : (param1 is RocketEffect ? RocketEffect(param1).target : (param1 is AirstrikeEffect ? AirstrikeEffect(param1).target : null));
         var _loc4_:Boolean = Boolean(_loc2_) && Boolean(_loc3_) && !EffectRange2D.link(_loc2_.position,_loc3_.position);
         if(Boolean(!_loc3_ && _loc2_ && (_loc2_ is Pet || param1 is PyroEffect)) && Boolean(!(param1 is StopLaserEffect)) && !(param1 is DriveAreaEffect))
         {
            _loc4_ = !EffectRange2D.near(_loc2_.position);
         }
         if(_loc4_)
         {
            return null;
         }
         if(!(param1 is StopLaserEffect) && !(param1 is DriveAreaEffect) && _loc2_ is Ship && ShipVisualBudget2D.isReduced(_loc2_ as Ship))
         {
            return null;
         }
         var _loc5_:Class = param1 ? MAP[param1.id] as Class : null;
         if(_loc5_ != null)
         {
            _loc6_ = param1 is PyroEffect ? new PyroEffect2D(this._view,PyroEffect(param1),Rocket2D.nativeImpactDispatchDepth > 0) : new _loc5_(this._view,param1);
         }
         return _loc6_;
      }
   }
}

