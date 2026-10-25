package net.bigpoint.darkorbit.map.view3D.effects
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.FlashLightEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AirstrikeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.LaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.RocketEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.laser.LaserEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.laser.LongRangeLaser3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.laser.ScatterLaserEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.laser.SnipedLaser3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.laser.StopLaserEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.rocket.AirstrikeEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.rocket.BezierRocketEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.combat.rocket.RocketEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.AbsorbShieldAndHpEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.AbsorptionBeamEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.AchievementGainEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.AntiMineTransmittorEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.AssimilateEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.BerserkEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ChainboltEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ChargeShieldBeamEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ChargeShotEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ChasingShotEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.CollectorBeamEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ConstructingEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.DDOLEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.DamageEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.DamageTrasferBeamEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.DecloakEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.DeflectorShieldEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.DiminisherEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.DisruptionEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.DrawFireEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.EmergencyRepairEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.EmergencyReservesEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.EmpEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.FireworksEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.FlashLightEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.FortifyEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.FrostFieldEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.GhostNPCEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.GlowingRingEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.HealBeamEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.HeatReleaseEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.HologramEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.IcyCubeEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.IncinerateEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.InstaShieldEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.InvincibilityEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.JAMXCreedDamageEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.KillStreakActivationEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.KillStreakCloudEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.KillStreakTrailEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.LeechEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.LevelUpEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.LowHpEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.MLaserBeamEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.MapObjectGlowRingEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.MarkTargetEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.MarkedByReconEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.MayhemRageEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.MayhemWinnerEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.MirroredControllsEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ModuleInstallEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.NeutralizingTargetEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.NoxiousNebulaEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.NoxiousNebulaRadiusEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.OutOfRangeEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.POIZoneExplosionEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.POIZoneExplosionEffectContainer3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.PetSpawnEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.PhaseOutEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.PlagueCureEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.PlagueEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.PolarityPowerupEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.PrismaticEnduranceEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ProtectedEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ProtectionEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.PvPProtectionEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.PvpModeEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.PyroEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.RadiationEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.RapidFireEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.RedirectEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.RepairRobotEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.RevengeEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ReversalEnemyEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ReversalSelfEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ScrambleEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SelfRepairEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SentinelEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ShieldBackupTech3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ShieldDisarrayEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ShieldEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ShipGlowEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ShipWarpEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ShockwaveEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SkullEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SlowDownEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SolaceEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SpawnChildrenEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SpawnEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SpawnEffectWithFadeIn3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SpectrumEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SpeedBuffEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SpeedBurstEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SphereShieldEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.SpreadEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StickyBombEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StockpileEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StunEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.TartarusPetDockAnimationEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.TartarusSpeedBoostEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.TechEnergyLeechEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ValentineBuffEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.VenomEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.VoltBackupEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.VoltDischargeEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.WarpPowerupEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.WorldBossContinuousLaserBeamEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.WorldBossMissileTelegraphEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.cannon.CannonHitEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.cannon.CannonPositionAreaEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.cannon.CannonSkillCorrosiveEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.cannon.CannonSkillThermalEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.cannon.CannonThermalWavesEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.drive.DriveAreaEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.drive.DriveShieldEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.paladin.LastStandEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.paladin.RipperEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss.BossEmpShockEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss.BossEnergyBayActivateEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss.BossEnergyBayEmpEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss.BossEnergyBayLinkEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss.BossEscapeEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss.BossLaserChargeEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss.BossLaserShotEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss.BossLaserWarningEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss.BossShieldEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.retiarus.BuffEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.retiarus.LastPersistantEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.strikeAndExit.EscapeZoneEffect3D;
   
   public class EffectsViewManager3D
   {
      
      private static const MAP:Object = {};
      
      MAP[EffectIDList.PYRO] = PyroEffect3D;
      MAP[EffectIDList.OUT_OF_RANGE_EFFECT] = OutOfRangeEffect3D;
      MAP[EffectIDList.RADIATION_EFFECT] = RadiationEffect3D;
      MAP[EffectIDList.COLLECTOR_BEAM] = CollectorBeamEffect3D;
      MAP[EffectIDList.LASER] = LaserEffect3D;
      MAP[EffectIDList.STOP_LASER] = StopLaserEffect3D;
      MAP[EffectIDList.ROCKET] = RocketEffect3D;
      MAP[EffectIDList.AIRSTRIKE] = AirstrikeEffect3D;
      MAP[EffectIDList.LOW_HP_EFFECT] = LowHpEffect3D;
      MAP[EffectIDList.LEVEL_UP_EFFECT] = LevelUpEffect3D;
      MAP[EffectIDList.SPAWN] = SpawnEffect3D;
      MAP[EffectIDList.ACHIEVEMENT_GAIN_EFFECT] = AchievementGainEffect3D;
      MAP[EffectIDList.SPECTRUM_EFFECT] = SpectrumEffect3D;
      MAP[EffectIDList.SENTINEL_EFFECT] = SentinelEffect3D;
      MAP[EffectIDList.EMERGENCY_REPAIR_EFFECT] = EmergencyRepairEffect3D;
      MAP[EffectIDList.DRAW_FIRE_EFFECT] = DrawFireEffect3D;
      MAP[EffectIDList.WARP_POWERUP_EFFECT] = WarpPowerupEffect3D;
      MAP[EffectIDList.POLARITY_POWERUP_EFFECT] = PolarityPowerupEffect3D;
      MAP[EffectIDList.EMP] = EmpEffect3D;
      MAP[EffectIDList.PROTECTED_EFFECT] = ProtectedEffect3D;
      MAP[EffectIDList.PROTECTION_EFFECT] = ProtectionEffect3D;
      MAP[EffectIDList.SHIP_WARP_EFFECT] = ShipWarpEffect3D;
      MAP[EffectIDList.DEFLECTOR_SHIELD_EFFECT] = DeflectorShieldEffect3D;
      MAP[EffectIDList.CONSTRUCTING_EFFECT] = ConstructingEffect3D;
      MAP[EffectIDList.PET_SPAWN] = PetSpawnEffect3D;
      MAP[EffectIDList.TECH_SHIELD_BACKUP_EFFECT] = ShieldBackupTech3D;
      MAP[EffectIDList.DECLOAK_EFFECT] = DecloakEffect3D;
      MAP[EffectIDList.EMPEROR_LORDAKIUM_SPAWN_EFFECT] = SpawnEffectWithFadeIn3D;
      MAP[EffectIDList.MIRRORED_CONTROLS_EFFECT] = MirroredControllsEffect3D;
      MAP[EffectIDList.MODULE_INSTALL_EFFECT] = ModuleInstallEffect3D;
      MAP[EffectIDList.TECH_ENERGY_LEECH_EFFECT] = TechEnergyLeechEffect3D;
      MAP[EffectIDList.SKULL] = SkullEffect3D;
      MAP[EffectIDList.SOLACE_EFFECT] = SolaceEffect3D;
      MAP[EffectIDList.DIMINISHER_EFFECT] = DiminisherEffect3D;
      MAP[EffectIDList.VENOM_EFFECT] = VenomEffect3D;
      MAP[EffectIDList.INVINCIBILITY] = InvincibilityEffect3D;
      MAP[EffectIDList.MARKED_BY_RECON_EFFECT] = MarkedByReconEffect3D;
      MAP[EffectIDList.CHASING_SHOT] = ChasingShotEffect3D;
      MAP[EffectIDList.SPEED_BUFF_EFFECT] = SpeedBuffEffect3D;
      MAP[EffectIDList.SLOW_DOWN_EFFECT] = SlowDownEffect3D;
      MAP[EffectIDList.SHIELD_EFFECT] = ShieldEffect3D;
      MAP[EffectIDList.SPHERE_SHIELD_EFFECT] = SphereShieldEffect3D;
      MAP[EffectIDList.HEALBEAM_EFFECT] = HealBeamEffect3D;
      MAP[EffectIDList.BIG_PUMPKIN_ABILITY_EFFECT] = ShipGlowEffect3D;
      MAP[EffectIDList.FIREWORKS] = FireworksEffect3D;
      MAP[EffectIDList.SHOCKWAVE] = ShockwaveEffect3D;
      MAP[EffectIDList.ABSORBATION_EFFECT] = AbsorptionBeamEffect3D;
      MAP[EffectIDList.DAMAGE] = DamageEffect3D;
      MAP[EffectIDList.RAGE] = ShipGlowEffect3D;
      MAP[EffectIDList.HOME_BONUS_EFFECT] = ShipGlowEffect3D;
      MAP[EffectIDList.SOLAR_GLOW_EFFECT] = ShipGlowEffect3D;
      MAP[EffectIDList.EMBRACING_GLOW_EFFECT] = ShipGlowEffect3D;
      MAP[EffectIDList.WARGAME_GLOW_EFFECT] = ShipGlowEffect3D;
      MAP[EffectIDList.POIZONE_EXPLOSION_EFFECT] = POIZoneExplosionEffect3D;
      MAP[EffectIDList.DAMAGE_TRANSFER_BEAM_EFFECT] = DamageTrasferBeamEffect3D;
      MAP[EffectIDList.CHARGE_SHIELD_BEAM_EFFECT] = ChargeShieldBeamEffect3D;
      MAP[EffectIDList.SATURN_EVIL_GLOW_EFFECT] = ShipGlowEffect3D;
      MAP[EffectIDList.GLOWING_RING_EFFECT] = GlowingRingEffect3D;
      MAP[EffectIDList.POIZONE_EXPLOSION_EFFECT_CONTAINER] = POIZoneExplosionEffectContainer3D;
      MAP[EffectIDList.FORTIFY_EFFECT] = FortifyEffect3D;
      MAP[EffectIDList.CHAIN_BOLT] = ChainboltEffect3D;
      MAP[EffectIDList.TECH_BATTLE_REP_BOT_EFFECT] = RepairRobotEffect3D;
      MAP[EffectIDList.REP_BOT_EFFECT] = RepairRobotEffect3D;
      MAP[EffectIDList.SPAWN_CHILDREN_EFFECT] = SpawnChildrenEffect3D;
      MAP[EffectIDList.MARK_TARGET_EFFECT] = MarkTargetEffect3D;
      MAP[EffectIDList.GHOST_NPC_EFFECT] = GhostNPCEffect3D;
      MAP[EffectIDList.INSTA_SHIELD] = InstaShieldEffect3D;
      MAP[EffectIDList.STICKYBOMB_EFFECT] = StickyBombEffect3D;
      MAP[EffectIDList.CHARGING_BLOB_EFFECT] = StickyBombEffect3D;
      MAP[EffectIDList.ICY_CUBE_EFFECT] = IcyCubeEffect3D;
      MAP[EffectIDList.PLAGUE_EFFECT] = PlagueEffect3D;
      MAP[EffectIDList.PLAGUE_CURE] = PlagueCureEffect3D;
      MAP[EffectIDList.DISRUPTION_EFFECT] = DisruptionEffect3D;
      MAP[FlashLightEffect.ID] = FlashLightEffect3D;
      MAP[EffectIDList.TARTARUS_SPEEDBUFF_EFFECT] = TartarusSpeedBoostEffect3D;
      MAP[EffectIDList.RAPID_FIRE_EFFECT] = RapidFireEffect3D;
      MAP[EffectIDList.SCRAMBLE_EFFECT] = ScrambleEffect3D;
      MAP[EffectIDList.PHASE_OUT_EFFECT] = PhaseOutEffect3D;
      MAP[EffectIDList.HOLOGRAM_EFFECT] = HologramEffect3D;
      MAP[EffectIDList.TARTARUS_PET_DOCK_EFFECT] = TartarusPetDockAnimationEffect3D;
      MAP[EffectIDList.SCATTER_LASER] = ScatterLaserEffect3D;
      MAP[EffectIDList.LONG_RANGE_LASER] = LongRangeLaser3D;
      MAP[EffectIDList.ABSORB_SHIELD_AND_HP_EFFECT] = AbsorbShieldAndHpEffect3D;
      MAP[EffectIDList.LEECH_EFFECT] = LeechEffect3D;
      MAP[EffectIDList.MAYHEM_RAGE_EFFECT] = MayhemRageEffect3D;
      MAP[EffectIDList.MAYHEM_WINNER_EFFECT] = MayhemWinnerEffect3D;
      MAP[EffectIDList.TECH_BATTLE_REP_BOT_EFFECT2] = RepairRobotEffect3D;
      MAP[EffectIDList.PARTICLE_BEAM] = ChainboltEffect3D;
      MAP[EffectIDList.TECH_SHIELD_BACKUP_EFFECT_2] = ShieldBackupTech3D;
      MAP[EffectIDList.PVP_PROTECTION] = PvPProtectionEffect3D;
      MAP[EffectIDList.KILL_STREAK_CLOUD_EFFECT] = KillStreakCloudEffect3D;
      MAP[EffectIDList.KILL_STREAK_TRAIL_EFFECT] = KillStreakTrailEffect3D;
      MAP[EffectIDList.KILL_STREAK_ACTIVATION_EFFECT] = KillStreakActivationEffect3D;
      MAP[EffectIDList.PROMETHEUS_KILL_STREAK_CLOUD_EFFECT] = KillStreakCloudEffect3D;
      MAP[EffectIDList.PROMETHEUS_KILL_STREAK_TRAIL_EFFECT] = KillStreakTrailEffect3D;
      MAP[EffectIDList.PROMETHEUS_KILL_STREAK_ACTIVATION_EFFECT] = KillStreakActivationEffect3D;
      MAP[EffectIDList.REDIRECT] = RedirectEffect3D;
      MAP[EffectIDList.SHIELD_DISARRAY] = ShieldDisarrayEffect3D;
      MAP[EffectIDList.DISTRIBUTED_DENIAL_OF_LASERS] = DDOLEffect3D;
      MAP[EffectIDList.SHIELD_LINK] = ChainboltEffect3D;
      MAP[EffectIDList.BERSERK] = BerserkEffect3D;
      MAP[EffectIDList.REVENGE] = RevengeEffect3D;
      MAP[EffectIDList.HP_LINK] = ChainboltEffect3D;
      MAP[EffectIDList.INCINERATE] = IncinerateEffect3D;
      MAP[EffectIDList.VALENTINE_BUFF] = ValentineBuffEffect3D;
      MAP[EffectIDList.SPREAD_EFFECT] = SpreadEffect3D;
      MAP[EffectIDList.MAPOBJECT_GLOWING_RING_EFFECT] = MapObjectGlowRingEffect3D;
      MAP[EffectIDList.CHARGE_SHOT] = ChargeShotEffect3D;
      MAP[EffectIDList.SPEED_BURST] = SpeedBurstEffect3D;
      MAP[EffectIDList.ANTI_MINE_TRANSMITTER] = AntiMineTransmittorEffect3D;
      MAP[EffectIDList.SHIP_GLOW_EFFECT] = ShipGlowEffect3D;
      MAP[EffectIDList.EMERGENCY_RESERVES] = EmergencyReservesEffect3D;
      MAP[EffectIDList.ASSIMILATE] = AssimilateEffect3D;
      MAP[EffectIDList.PVP_MODE] = PvpModeEffect3D;
      MAP[EffectIDList.FROST_FIELD] = FrostFieldEffect3D;
      MAP[EffectIDList.REVERSAL_SELF_EFFECT] = ReversalSelfEffect3D;
      MAP[EffectIDList.REVERSAL_ENEMY_EFFECT] = ReversalEnemyEffect3D;
      MAP[EffectIDList.PRISMATIC_ENDURANCE_EFFECT] = PrismaticEnduranceEffect3D;
      MAP[EffectIDList.SELF_REPAIR_EFFECT] = SelfRepairEffect3D;
      MAP[EffectIDList.STOCKPILE_EFFECT] = StockpileEffect3D;
      MAP[EffectIDList.HEAT_RELEASE_EFFECT] = HeatReleaseEffect3D;
      MAP[EffectIDList.JAMX_CREED_DAMAGE_EFFECT] = JAMXCreedDamageEffect3D;
      MAP[EffectIDList.NEUTRALIZING_TARGET] = NeutralizingTargetEffect3D;
      MAP[EffectIDList.VOLTAGE_LINK_EFFECT] = ChainboltEffect3D;
      MAP[EffectIDList.STUN_EFFECT] = StunEffect3D;
      MAP[EffectIDList.VOLT_DISCHARGE_EFFECT] = VoltDischargeEffect3D;
      MAP[EffectIDList.VOLT_BACKUP_EFFECT] = VoltBackupEffect3D;
      MAP[EffectIDList.SHEER_CHAOS_EFFECT] = ShipGlowEffect3D;
      MAP[EffectIDList.WORLDBOSS_MISSILE_TELEGRAPH_EFFECT] = WorldBossMissileTelegraphEffect3D;
      MAP[EffectIDList.NOXIOUS_NEBULA_EFFECT] = NoxiousNebulaEffect3D;
      MAP[EffectIDList.NOXIOUS_NEBULA_RADIUS_EFFECT] = NoxiousNebulaRadiusEffect3D;
      MAP[EffectIDList.BEZIER_ROCKET_EFFECT] = BezierRocketEffect3D;
      MAP[EffectIDList.SNIPED_LASER_EFFECT] = SnipedLaser3D;
      MAP[EffectIDList.WORLDBOSS_CONTINUOUS_LASER_BEAM_EFFECT] = WorldBossContinuousLaserBeamEffect3D;
      MAP[EffectIDList.M_LASER_BEAM_EFFECT] = MLaserBeamEffect3D;
      MAP[EffectIDList.LAST_STAND] = LastStandEffect3D;
      MAP[EffectIDList.RIPPER] = RipperEffect3D;
      MAP[EffectIDList.BOSS_LASER_CHARGE] = BossLaserChargeEffect3D;
      MAP[EffectIDList.BOSS_EMP_SHOCK] = BossEmpShockEffect3D;
      MAP[EffectIDList.BOSS_ENERGY_BAY_ACTIVATE] = BossEnergyBayActivateEffect3D;
      MAP[EffectIDList.BOSS_ENERGY_BAY_EMP] = BossEnergyBayEmpEffect3D;
      MAP[EffectIDList.BOSS_ENERGY_BAY_LINK] = BossEnergyBayLinkEffect3D;
      MAP[EffectIDList.BOSS_LASER_WARNING] = BossLaserWarningEffect3D;
      MAP[EffectIDList.BOSS_LASER_SHOT] = BossLaserShotEffect3D;
      MAP[EffectIDList.BOSS_SHIELD] = BossShieldEffect3D;
      MAP[EffectIDList.BOSS_ESCAPE] = BossEscapeEffect3D;
      MAP[EffectIDList.ESCAPE_ZONE] = EscapeZoneEffect3D;
      MAP[EffectIDList.CANNON_SHOT] = ChainboltEffect3D;
      MAP[EffectIDList.CANNON_HIT] = CannonHitEffect3D;
      MAP[EffectIDList.CANNON_SKILL_THERMAL] = CannonSkillThermalEffect3D;
      MAP[EffectIDList.CANNON_SKILL_CORROSIVE] = CannonSkillCorrosiveEffect3D;
      MAP[EffectIDList.CANNON_SKILL_ELECTRO] = ChainboltEffect3D;
      MAP[EffectIDList.CANNON_THERMAL_WAVES] = CannonThermalWavesEffect3D;
      MAP[EffectIDList.CANNON_POSITION_AREA] = CannonPositionAreaEffect3D;
      MAP[EffectIDList.CHSP_UP] = LastPersistantEffect3D;
      MAP[EffectIDList.SPCP_UP] = BuffEffect3D;
      MAP[EffectIDList.CHSP_W_UP] = LastPersistantEffect3D;
      MAP[EffectIDList.SPCP_W_UP] = BuffEffect3D;
      MAP[EffectIDList.CHSP_HIT] = ShieldEffect3D;
      MAP[EffectIDList.CHSP_W_HIT] = ShieldEffect3D;
      MAP[EffectIDList.CHSP_OUT_BREAK] = LastPersistantEffect3D;
      MAP[EffectIDList.CHSP_W_OUT_BREAK] = LastPersistantEffect3D;
      MAP[EffectIDList.DA_OUTER_ENEMY_01] = DriveAreaEffect3D;
      MAP[EffectIDList.DA_OUTER_FRIENDLY_01] = DriveAreaEffect3D;
      MAP[EffectIDList.DA_OUTER_ENEMY_02] = DriveAreaEffect3D;
      MAP[EffectIDList.DA_OUTER_FRIENDLY_02] = DriveAreaEffect3D;
      MAP[EffectIDList.DA_OUTER_ENEMY_03] = DriveAreaEffect3D;
      MAP[EffectIDList.DA_OUTER_FRIENDLY_03] = DriveAreaEffect3D;
      MAP[EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE] = DriveAreaEffect3D;
      MAP[EffectIDList.DA_END_FRIENDLY] = DriveShieldEffect3D;
      MAP[EffectIDList.DA_START_FRIENDLY] = DriveShieldEffect3D;
      MAP[EffectIDList.DA_END_ENEMY] = DriveShieldEffect3D;
      MAP[EffectIDList.DA_START_ENEMY] = DriveShieldEffect3D;
      MAP[EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_END] = DriveShieldEffect3D;
      MAP[EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_START] = DriveShieldEffect3D;
      
      private var _effect2view:Dictionary = new Dictionary(true);
      
      private var _manager:EffectManager;
      
      private var _view:MapView3D;
      
      public function EffectsViewManager3D(param1:MapView3D)
      {
         super();
         this._view = param1;
      }
      
      public function set map(param1:Map) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Effect = null;
         if(this._manager)
         {
            this._manager.effectAdded.remove(this.handleEffectAdded);
            this._manager.effectRemoved.remove(this.handleEffectRemoved);
            for(_loc2_ in this._effect2view)
            {
               this.handleEffectRemoved(_loc2_ as Effect);
            }
         }
         this._manager = param1 ? param1.effects : null;
         if(this._manager)
         {
            this._manager.effectAdded.add(this.handleEffectAdded);
            this._manager.effectRemoved.add(this.handleEffectRemoved);
            for each(_loc3_ in this._manager.effects)
            {
               this.handleEffectAdded(_loc3_);
            }
         }
      }
      
      private function handleEffectAdded(param1:Effect) : void
      {
         var source:Object;
         var target:Object;
         var viewClass:Class;
         var effectView:Object = null;
         var driveShieldView:DriveShieldEffect3D = null;
         var effect:Effect = param1;
         if(effect is MapObjectEffect && (effect.id == EffectIDList.DA_END_FRIENDLY || effect.id == EffectIDList.DA_START_FRIENDLY || effect.id == EffectIDList.DA_END_ENEMY || effect.id == EffectIDList.DA_START_ENEMY || effect.id == EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_START || effect.id == EffectIDList.GRAVITATIONAL_ANCHOR_ACTIVATE_END) && !EffectRange3D.near(MapObjectEffect(effect).source.position,800))
         {
            return;
         }
         source = effect is LaserEffect ? LaserEffect(effect).attacker : (effect is RocketEffect ? RocketEffect(effect).attacker : (effect is AirstrikeEffect ? AirstrikeEffect(effect).attacker : null));
         target = effect is LaserEffect ? LaserEffect(effect).target : (effect is RocketEffect ? RocketEffect(effect).target : (effect is AirstrikeEffect ? AirstrikeEffect(effect).target : null));
         if(Boolean(source) && Boolean(target) && !EffectRange3D.link(source.position,target.position))
         {
            return;
         }
         viewClass = MAP[effect.id] as Class;
         if(viewClass != null)
         {
            effectView = new viewClass(this._view,effect);
            if(effect.persistent || effect.timeout)
            {
               this._effect2view[effect] = effectView;
            }
            else if(effectView is DriveShieldEffect3D)
            {
               driveShieldView = effectView as DriveShieldEffect3D;
               this._effect2view[effect] = driveShieldView;
               driveShieldView.completed.addOnce(function():void
               {
                  if(_effect2view[effect] == driveShieldView)
                  {
                     delete _effect2view[effect];
                  }
               });
            }
         }
      }
      
      private function handleEffectRemoved(param1:Effect) : void
      {
         var _loc2_:Object = this._effect2view[param1];
         if(_loc2_ != null)
         {
            if(_loc2_ is IDisposable)
            {
               IDisposable(_loc2_).disposeView();
            }
            delete this._effect2view[param1];
         }
      }
   }
}

