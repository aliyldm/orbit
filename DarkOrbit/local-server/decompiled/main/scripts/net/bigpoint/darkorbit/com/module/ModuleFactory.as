package net.bigpoint.darkorbit.com.module
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.com.module.IModuleFactory;
   import net.bigpoint.darkorbit.com.module.autopilot.AutopilotStatus;
   import net.bigpoint.darkorbit.com.module.debug.EchoRequest;
   import net.bigpoint.darkorbit.com.module.debug.SummonNPCRequest;
   import net.bigpoint.darkorbit.com.module.liveops.europeanCup.ReqDroneBoostInfo;
   import net.bigpoint.darkorbit.com.module.liveops.seasonpass.RefreshQuestInfo;
   import net.bigpoint.darkorbit.com.module.liveops.seasonpass.SeasonPassRefreshCountCommand;
   import net.bigpoint.darkorbit.com.module.liveops.seasonpass.SeasonPassRefreshRequest;
   import net.bigpoint.darkorbit.com.module.porting.AllowUnityOnlyCommand;
   import net.bigpoint.darkorbit.com.module.porting.NormalTipsCommand;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.EventCommand;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.PlanetCommand;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchEventsCommand;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchMissionListCommand;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchRequest;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchSectorRewards;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchSectorRewardsCommand;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.UpdateSpaceSearchKeyCommand;
   import net.bigpoint.darkorbit.com.module.porting.TupleThreeModule;
   import net.bigpoint.darkorbit.com.module.porting.TupleTwoModule;
   import net.bigpoint.darkorbit.com.module.porting.achievement.AchievementInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.achievement.AchievementListCommand;
   import net.bigpoint.darkorbit.com.module.porting.achievement.AchievementListRequest;
   import net.bigpoint.darkorbit.com.module.porting.achievement.AchievementTitleCommand;
   import net.bigpoint.darkorbit.com.module.porting.achievement.AchievementValueCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.EventQuestCompletedCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.EventQuestDefinitionModule;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.EventQuestListCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope.EventANewHopeActionCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope.EventANewHopeActionRequest;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope.EventANewHopeContributorCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope.EventANewHopeContributorListCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope.EventANewHopeQuestCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope.EventANewHopeStatusCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero.EventReturnOfHeroActionCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero.EventReturnOfHeroActionRequest;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero.EventReturnOfHeroContributorCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero.EventReturnOfHeroContributorListCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero.EventReturnOfHeroQuestCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero.EventReturnOfHeroStatusCommand;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.unityclientreward.ClaimUnityClientRewardRequest;
   import net.bigpoint.darkorbit.com.module.porting.activityevent.unityclientreward.EventUnityClientRewardQuestCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimInfoGroupCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimRequest;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockDrawCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockDrawRequest;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockInfoRequest;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockLootShowCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockLootShowListCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockSelectGroupRequest;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionBidCommand;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionBidRequest;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionDataCommand;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionHistoryCommand;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionListCommand;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionListRequest;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionQuickBuyCommand;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionQuickBuyRequest;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionTestCommand;
   import net.bigpoint.darkorbit.com.module.porting.auction.AuctionTestRequest;
   import net.bigpoint.darkorbit.com.module.porting.auction.GetNamFIagRequest;
   import net.bigpoint.darkorbit.com.module.porting.auction.GetNamFlagCommand;
   import net.bigpoint.darkorbit.com.module.porting.auction.UpdateNamFIagCommand;
   import net.bigpoint.darkorbit.com.module.porting.auction.UpdateNamFIagRequest;
   import net.bigpoint.darkorbit.com.module.porting.autopilot.AutopilotInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.autopilot.AutopilotInfoRequest;
   import net.bigpoint.darkorbit.com.module.porting.autopilot.AutopilotInfoSaveCommand;
   import net.bigpoint.darkorbit.com.module.porting.autopilot.AutopilotInfoSaveRequest;
   import net.bigpoint.darkorbit.com.module.porting.balance.BalanceInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.balance.BalanceInfoListCommand;
   import net.bigpoint.darkorbit.com.module.porting.balance.BalanceInfoListRequest;
   import net.bigpoint.darkorbit.com.module.porting.battlestation.BattleStationHistoryInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.battlestation.BattleStationHistoryListCommand;
   import net.bigpoint.darkorbit.com.module.porting.battlestation.BattleStationHistoryListRequest;
   import net.bigpoint.darkorbit.com.module.porting.battlestation.BattleStationOverviewInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.battlestation.ClanBattleStationInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.battlestation.ClanBattleStationInfoRequest;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025ClaimRequest;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025GateEnterRequest;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025GateRewardCommand;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025GateWindowCommand;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025PointRewardCommand;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025PointRewardRequest;
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonAttackCommand;
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonUnstableModuleModule;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainActionRequest;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainCommand;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainDismissBackCommand;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainGetResourcesBackCommand;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainPerkCommand;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainPerkUpgradLevelCommand;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainPerkUpgradLevelCostCommand;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainRosterListCommand;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainUpdateActiveBackCommand;
   import net.bigpoint.darkorbit.com.module.porting.captain.CaptainUpgradPerkBackCommand;
   import net.bigpoint.darkorbit.com.module.porting.chat.ChatParamCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ApplyAcceptCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ApplyAcceptRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ApplyClanCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ApplyClanRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ApplyDeclineCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ApplyDeclineRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ChangeClanDescriptionCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ChangeClanDescriptionRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ChangeClanFirmaCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ChangeClanFirmaRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ChangeClanLeaderCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ChangeClanLeaderRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ChangeClanTaxCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ChangeClanTaxRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanAddNewsCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanAddNewsRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanAllInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanApplyInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanApplyInfoListCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanApplyInfoListRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteAllMessageCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteAllMessageRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteDiploCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteDiploRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteMessageCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteMessageRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteOpenDiploCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteOpenDiploRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteRankCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDeleteRankRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDiploInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanDiploReqInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanEditDiploOfferCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanEditDiploOfferRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanFilterSearchInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanFilterSearchRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanListCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanListRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanMemberInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanMemberListCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanMemberListRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanMessageInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanMessageListCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanMessageListRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanNameTagInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanNewDiplomacyCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanNewDiplomacyRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanNewRankCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanNewRankRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanNewsInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanNewsListCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanNewsListRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanRankListCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanRankListRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanReportAdminCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanReportAdminRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanSearchNameTagCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanSearchNameTagRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanSendAllMessageCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanSendAllMessageRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanSendMessageCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanSendMessageRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanTaxInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanTaxLogCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClanTestCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ClearClanCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.CompanyDateInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.DelClanCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.DelClanRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.DeleteClanApplyCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.DeleteClanApplyRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.DeleteClanCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.DeleteClanMemberCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.DeleteClanMemberRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.DeleteClanRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.DeleteMyRankCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.DeleteMyRankRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.EditClanInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.EditClanInfoRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.EditClanMemberCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.EditClanMemberRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.EditClanRanksCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.EditClanRanksRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.FoundClanCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.FoundClanRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.JoinClanCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.LeaveClanCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.LeaveClanRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.LoginInitClanCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.LoginInitClanRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.LoginInitMyApplyCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.NotifyNewDiploCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.NotifyNewDiploReqCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.PayoutClanCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.PayoutClanRequest;
   import net.bigpoint.darkorbit.com.module.porting.clan.ShowClanInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.clan.ShowClanInfoRequest;
   import net.bigpoint.darkorbit.com.module.porting.dailylogin.DailyLoginClaimTodayCommand;
   import net.bigpoint.darkorbit.com.module.porting.dailylogin.DailyLoginClaimTodayRequest;
   import net.bigpoint.darkorbit.com.module.porting.dailylogin.DailyLoginRewardDayCommand;
   import net.bigpoint.darkorbit.com.module.porting.dailylogin.DailyLoginRewardDayRequest;
   import net.bigpoint.darkorbit.com.module.porting.events.EndEventSummaryScoreCommand;
   import net.bigpoint.darkorbit.com.module.porting.events.EventLootShowCommand;
   import net.bigpoint.darkorbit.com.module.porting.events.EventPaymentActorCommand;
   import net.bigpoint.darkorbit.com.module.porting.events.EventSummaryScoreCommand;
   import net.bigpoint.darkorbit.com.module.porting.events.LootProbabilityModule;
   import net.bigpoint.darkorbit.com.module.porting.events.SpecialEventPaymentActorCommand;
   import net.bigpoint.darkorbit.com.module.porting.events.UpdateEventSummaryScoreCommand;
   import net.bigpoint.darkorbit.com.module.porting.evoucher.EvoucherHistoryInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.evoucher.EvoucherHistoryListCommand;
   import net.bigpoint.darkorbit.com.module.porting.evoucher.EvoucherHistoryListRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionActivateShipRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionBackRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionBuyTicketCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionBuyTicketRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionClearanceTimeCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionInfoRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionJumpLevelInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionJumpTargetLevelCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionJumpTargetLevelRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionRankUserInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionResetRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionRewardCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionSelectShipCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionSelectShipRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionSelectedShipListCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipListCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipListRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShowUiCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionStartInstanceCommand;
   import net.bigpoint.darkorbit.com.module.porting.halloffame.HallOfFameDataCommand;
   import net.bigpoint.darkorbit.com.module.porting.halloffame.HallOfFameDataListCommand;
   import net.bigpoint.darkorbit.com.module.porting.halloffame.HallOfFameDataListRequest;
   import net.bigpoint.darkorbit.com.module.porting.halloffame.HallOfFamePages;
   import net.bigpoint.darkorbit.com.module.porting.halloffame.HallOfFamePagesRequest;
   import net.bigpoint.darkorbit.com.module.porting.halloffame.HallOfFameRankingPoints;
   import net.bigpoint.darkorbit.com.module.porting.halloffame.HallOfFameTopDataListCommand;
   import net.bigpoint.darkorbit.com.module.porting.halloffame.HallOfFameTopRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarDroneEquipmentMsg;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarListRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarPetEquipmentMsg;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipActivateShipCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipActivateShipRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipAutoBuyCpuAmmoCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipAutoBuyCpuAmmoRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipBriefCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipChangeShipModelCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipChangeShipModelRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipClearConfigCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipClearConfigRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipDetailCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipDetailRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipDroneView;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentMsg;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipFavouriteCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipFavouriteRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipImportConfigCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipImportConfigRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipLoadConfigCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipLoadConfigRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipMoveItemsCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipMoveItemsRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipPetView;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipRenamePetCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipRenamePetRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipRepairDroneCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipRepairDroneRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipRepairModuleCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipRepairModuleRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipSaveConfigCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipSaveConfigRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipSellDroneCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipSellDroneRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipSellItemCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipSellItemRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipUnlockSlotCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipUnlockSlotRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipsCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.InventoryItemModifyCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.InventoryItemPack;
   import net.bigpoint.darkorbit.com.module.porting.hangar.InventoryItemSellPack;
   import net.bigpoint.darkorbit.com.module.porting.hangar.SetBonusInfo;
   import net.bigpoint.darkorbit.com.module.porting.hangar.ShipDesignPack;
   import net.bigpoint.darkorbit.com.module.porting.hangar.SingleDroneEquipmentMsg;
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemListCommand;
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemModule;
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemRerollCommand;
   import net.bigpoint.darkorbit.com.module.porting.lockattributeitem.LockAttributeItemRerollRequest;
   import net.bigpoint.darkorbit.com.module.porting.logbook.LogbookDataCommand;
   import net.bigpoint.darkorbit.com.module.porting.logbook.LogbookDataListCommand;
   import net.bigpoint.darkorbit.com.module.porting.logbook.LogbookDataListRequest;
   import net.bigpoint.darkorbit.com.module.porting.lottery.LotteryEventFlushCommand;
   import net.bigpoint.darkorbit.com.module.porting.lottery.LotteryLogCommand;
   import net.bigpoint.darkorbit.com.module.porting.lottery.LotteryLogRewardCommand;
   import net.bigpoint.darkorbit.com.module.porting.lottery.LotteryRequest;
   import net.bigpoint.darkorbit.com.module.porting.lottery.LotteryRequestCommand;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.ArgStackCommand;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   import net.bigpoint.darkorbit.com.module.porting.passevent.PassEventCommand;
   import net.bigpoint.darkorbit.com.module.porting.passevent.PassItemModule;
   import net.bigpoint.darkorbit.com.module.porting.pilotsheet.InternalPilotBioRequest;
   import net.bigpoint.darkorbit.com.module.porting.pilotsheet.InternalPilotBioUpdateRequest;
   import net.bigpoint.darkorbit.com.module.porting.pilotsheet.InternalPilotBioUpdateResultsCommand;
   import net.bigpoint.darkorbit.com.module.porting.pilotsheet.InternalPilotBioUpdateStatusRequest;
   import net.bigpoint.darkorbit.com.module.porting.pilotsheet.InternalPilotBioUpdateUserNameRequest;
   import net.bigpoint.darkorbit.com.module.porting.pilotsheet.InternalPilotBioUserProfileCommand;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRaidCommand;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRaidIntensity;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRankCommand;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRankReward;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRequest;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossTier;
   import net.bigpoint.darkorbit.com.module.porting.shop.ShopItemBuyCommand;
   import net.bigpoint.darkorbit.com.module.porting.shop.ShopItemBuyRequest;
   import net.bigpoint.darkorbit.com.module.porting.shop.ShopItemCommand;
   import net.bigpoint.darkorbit.com.module.porting.shop.ShopItemLevelDataCommand;
   import net.bigpoint.darkorbit.com.module.porting.shop.ShopItemListCommand;
   import net.bigpoint.darkorbit.com.module.porting.shop.ShopItemListRequest;
   import net.bigpoint.darkorbit.com.module.porting.shop.ShopLabelPrompt;
   import net.bigpoint.darkorbit.com.module.porting.shop.exchange.ExchangeShopCommand;
   import net.bigpoint.darkorbit.com.module.porting.shop.exchange.ExchangeShopRequest;
   import net.bigpoint.darkorbit.com.module.porting.shop.exchange.ExchangesShopItem;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.ConvertResearchPointsCommand;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.ConvertResearchPointsRequest;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.ResetSkillTreeCommand;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.ResetSkillTreeRequest;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.SkillTreeInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.SkillTreeListCommand;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.SkillTreeListRequest;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.UpLevelSkillTreeCommand;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.UpLevelSkillTreeRequest;
   import net.bigpoint.darkorbit.com.module.porting.skillTree.UpdateCargoSpaceCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabActionRequest;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabActiveRobotsLeftTimeCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabCollectorInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabMainViewCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabMainViewModuleCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabModuleProductivityCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabModuleUpgradeCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabPurchaseRobotRequest;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabRobotPriceCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabStorageInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabStorageOreCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabUnifiedReceiptCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabViewModuleBackCommand;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabViewModuleRequest;
   import net.bigpoint.darkorbit.com.module.porting.skylab.SkylabXenoInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.SpotLightPositionCommand;
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.StrikeAndExitInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.StrikeAndExitInfoRequest;
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.StrikeAndExitMapInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.StrikeAndExitRemoveScoreCommand;
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.StrikeAndExitScoreCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisCostLootCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisGroupCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisInventoryCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisInventoryRequest;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisItemRequest;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisListCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisModuleCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisModuleListCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsClaimPassRewardRequest;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsDropLevelCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsDropLevelOptionalCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsDropLevelOptionalRequest;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsGateEnterRequest;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsGateWindowCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsPassCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsRewardDescriptionCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsUIRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.AbsUserMessageInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.BlackListAddCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.BlackListAddRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.BlackListDeleteCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.BlackListDeleteRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.BlackListGetCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.BlackListGetRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.ContactBaseInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.ContactFriendAcceptTipsCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.ContactFriendInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.ContactInvitationInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.ContactListBlockInvitationsTipsCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.ContactListCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.ContactListRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageAuctionInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageClanInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageDeleteCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageDeleteRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageGetTargetCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageGetTargetRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageInboxListCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageInboxListRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageInfoInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageInitCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageInitRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageLootCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageLootRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNewCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNoteAddCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNoteAddRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNoteDeleteCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNoteDeleteRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNoteInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNoteListCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNoteListRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNoteUpdateCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageNoteUpdateRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageOutboxListCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageOutboxListRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageParentInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageSendCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageSendRequest;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageSystemInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageTargetInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageUpdateStatusCommand;
   import net.bigpoint.darkorbit.com.module.porting.userMessage.UserMessageUpdateStatusRequest;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersClaimPassRewardRequest;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersGateEnterRequest;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersGateStarRewardCommand;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersGateWindowCommand;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersPassCommand;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersUIRequest;
   
   public class ModuleFactory implements IModuleFactory
   {
      
      private static const fac:IModuleFactory = new ModuleFactory();
      
      public function ModuleFactory()
      {
         super();
      }
      
      public static function get() : IModuleFactory
      {
         return fac;
      }
      
      public function createInstance(param1:int) : IModule
      {
         switch(param1)
         {
            case -32546:
               return new UpdateEventSummaryScoreCommand();
            case -32404:
               return new ArmoryUnlockDrawRequest();
            case -32380:
               return new UserMessageAuctionInfoCommand();
            case -32337:
               return new TrainingGroundConfirmRequest();
            case -32332:
               return new UserMessageGetTargetCommand();
            case -32107:
               return new EternalGateKeyInfoCommand();
            case -31954:
               return new Birthday2025PointRewardRequest();
            case -31905:
               return new HangarShipAutoBuyCpuAmmoRequest();
            case -31831:
               return new DroneRemovedCommand();
            case -31527:
               return new EggTriggerRequest();
            case -31515:
               return new LoginInitClanCommand();
            case -31483:
               return new DispatchGetRewardPackageRequest();
            case -31448:
               return new EventANewHopeContributorCommand();
            case -31334:
               return new AgatusEventBossInfoCommand();
            case -31331:
               return new WarGameLeaveQueueRequest();
            case -31327:
               return new GalaxyGateBuilderLootItemModule();
            case -31315:
               return new WarGameInitLobbyCommand();
            case -31241:
               return new RewardContentRequest();
            case -31225:
               return new MemberJumpCommand();
            case -31223:
               return new ConvertResearchPointsRequest();
            case -31218:
               return new DelClanCommand();
            case -31204:
               return new Birthday2025GateWindowCommand();
            case -31128:
               return new ClanSearchNameTagCommand();
            case -31102:
               return new UpdateSpaceSearchKeyCommand();
            case -31070:
               return new RzoneConfirmRequest();
            case -31025:
               return new HangarShipSellDroneCommand();
            case -30954:
               return new SpaceSearchInfoCommand();
            case -30943:
               return new GalaxyGateBuilderInfoRequest();
            case -30908:
               return new PublicWorldBossTier();
            case -30853:
               return new RzoneStatusCommand();
            case -30703:
               return new BoosterDetailModule();
            case -30656:
               return new ClanListRequest();
            case -30607:
               return new ReloginCommand();
            case -30544:
               return new CCBooleanRangeModule();
            case -30534:
               return new EventReturnOfHeroContributorCommand();
            case -30478:
               return new EventQuestCompletedCommand();
            case -30116:
               return new PayoutClanRequest();
            case -30100:
               return new PVPSummerEventSelfReputationUpdateCommand();
            case -29981:
               return new EventProgressCollectRequest();
            case -29914:
               return new ClearClanCommand();
            case -29891:
               return new TrainingGroundConfirmationStatusCommand();
            case -29889:
               return new UIItemAddHighlightCommand();
            case -29839:
               return new WorldBossRankingInfoCommand();
            case -29812:
               return new KillUiCloseMessageCommand();
            case -29807:
               return new QuantumFluidCoreRequest();
            case -29656:
               return new HallOfFameDataListRequest();
            case -29644:
               return new HuntInfoCommand();
            case -29616:
               return new EditClanInfoRequest();
            case -29603:
               return new RzoneQueueingStatusModule();
            case -29419:
               return new EventLootShowCommand();
            case -29387:
               return new NotifyNewDiploReqCommand();
            case -29300:
               return new HallOfFameTopRequest();
            case -29298:
               return new ChangeClanDescriptionCommand();
            case -29223:
               return new UILayoutCommand();
            case -29222:
               return new InvitationCancelRequest();
            case -29213:
               return new ContactListBlockInvitationsTipsCommand();
            case -29206:
               return new ExchangeShopCommand();
            case -29164:
               return new AssemblyRecipeStatusUpdateCommand();
            case -29100:
               return new MapAddPOICommand();
            case -28955:
               return new WorldBossRewardModule();
            case -28722:
               return new VoyagersGateStarRewardCommand();
            case -28603:
               return new PlutusInfoCommand();
            case -28574:
               return new ContactListEntryAttributeNameModule();
            case -28530:
               return new InventoryItemRemovedCommand();
            case -28410:
               return new ClanMemberInfoCommand();
            case -28303:
               return new DailyLoginClaimTodayRequest();
            case -28295:
               return new InvitationModeModule();
            case -28196:
               return new TrainingGroundRegistrationUnavailableStatusCommand();
            case -28042:
               return new CCDateRangeModule();
            case -27877:
               return new ClanEditDiploOfferCommand();
            case -27799:
               return new VIPMerchantExchangeModule();
            case -27777:
               return new ClanDeleteRankRequest();
            case -27715:
               return new InvitationRemovalCommand();
            case -27687:
               return new PublicWorldBossRankReward();
            case -27566:
               return new UserMessageNoteUpdateRequest();
            case -27491:
               return new SkylabPurchaseRobotRequest();
            case -27470:
               return new ExpeditionBuyTicketRequest();
            case -27444:
               return new AutopilotInfoCommand();
            case -27397:
               return new RzoneOnRZoneStatusModule();
            case -27341:
               return new HangarDroneEquipmentMsg();
            case -27327:
               return new RzoneCancelRequest();
            case -27294:
               return new SectorControlSectorStateCommand();
            case -27270:
               return new UserMessageNoteAddCommand();
            case -27265:
               return new UserSettingsCommand();
            case -27219:
               return new QuestGiverWindowClosedRequest();
            case -27026:
               return new ShipUpgradeModuleUpdateCommand();
            case -26820:
               return new GroupInvitationBlockToggleRequest();
            case -26622:
               return new NpcEventInfoCommand();
            case -26562:
               return new RogueLiteInfoCommand();
            case -26502:
               return new BlackListDeleteCommand();
            case -26466:
               return new ApplyDeclineCommand();
            case -26445:
               return new CCRequestAttributeModule();
            case -26215:
               return new EpicNumberedFightMessageTypeModule();
            case -26179:
               return new RerollWindowSettingsRequest();
            case -26127:
               return new UserMessageGetTargetRequest();
            case -26058:
               return new TrainingGroundRemainingTimeToTimeoutCommand();
            case -25837:
               return new CaptchaCollectRequest();
            case -25809:
               return new ChangeClanDescriptionRequest();
            case -25665:
               return new VIPMerchantExchangeBuyCommand();
            case -25661:
               return new EventReturnOfHeroQuestCommand();
            case -25506:
               return new CCQuestValueModule();
            case -25367:
               return new TieredArenaEventReputationUpdateCommand();
            case -25252:
               return new TrainingGroundFightStatusCommand();
            case -25226:
               return new UserMessageInitCommand();
            case -25207:
               return new AuctionBidCommand();
            case -25143:
               return new TitleFrenzyOwnerUpdateCommand();
            case -25070:
               return new LeaveClanRequest();
            case -25000:
               return new PageRefreshCommand();
            case -24639:
               return new CreateMinimapMark();
            case -24613:
               return new VIPMerchantExchangeInsufficientResourcesCommand();
            case -24583:
               return new DispatchGetGateListRequest();
            case -24564:
               return new DeleteMyRankRequest();
            case -24553:
               return new TrackVariableRequest();
            case -24550:
               return new TrainingGroundSignUpRequest();
            case -24527:
               return new PVPSummerEventFeverInfoCommand();
            case -24468:
               return new UnstableModulesShardCommand();
            case -24460:
               return new BattlePassKeyExchangeInfoCommand();
            case -24450:
               return new OreTypeModule();
            case -24397:
               return new AssemblyRecipeSelectRequest();
            case -24391:
               return new AssemblyRecipeKeyModule();
            case -24357:
               return new MileageMarketPackageUpdateCommand();
            case -24325:
               return new BattlePassKeyExchangeUpdateCommand();
            case -24292:
               return new ShipBoostEventUpdateInfoCommand();
            case -24284:
               return new DeleteClanRequest();
            case -24143:
               return new DispatchRewardModule();
            case -24125:
               return new DeleteClanApplyCommand();
            case -24105:
               return new StrikeAndExitRemoveScoreCommand();
            case -24041:
               return new DeleteClanCommand();
            case -24008:
               return new RzoneClosingMapStatusModule();
            case -23921:
               return new PublicWorldBossRequest();
            case -23783:
               return new RogueLiteShipModule();
            case -23737:
               return new LogbookDataListRequest();
            case -23588:
               return new InvitationModeRequest();
            case -23538:
               return new ContactListEntryAttributeClanTagModule();
            case -23449:
               return new EditClanInfoCommand();
            case -23432:
               return new HangarShipImportConfigCommand();
            case -23416:
               return new MarkRangeCommand();
            case -23385:
               return new EternalGateBoosterCommand();
            case -23042:
               return new ShopItemCommand();
            case -22989:
               return new ContactListUpdateContactsCommand();
            case -22959:
               return new SynthesisModuleCommand();
            case -22814:
               return new AssemblyRecipeTemporaryTypeModule();
            case -22757:
               return new SpaceSearchEventsCommand();
            case -22707:
               return new RaidGateGameStageModule();
            case -22706:
               return new SynthesisModuleListCommand();
            case -22695:
               return new SkylabRobotPriceCommand();
            case -22625:
               return new CCListRangeModule();
            case -22607:
               return new HangarShipMoveItemsRequest();
            case -22566:
               return new EquipAttributeModule();
            case -22526:
               return new ClanDiploReqInfoCommand();
            case -22505:
               return new HangarShipEquipmentCommand();
            case -22423:
               return new AuctionQuickBuyCommand();
            case -22404:
               return new CCNumericRangeModule();
            case -22394:
               return new GalaxyGateBuilderItemModule();
            case -22362:
               return new ClanSendMessageCommand();
            case -22343:
               return new BlackListGetRequest();
            case -22282:
               return new SeasonPassMissionModule();
            case -22236:
               return new GalaxyGateBuilderPartItemModule();
            case -22169:
               return new ClanMessageListCommand();
            case -22050:
               return new RogueLiteCashOutCommand();
            case -22034:
               return new PlayerInfluenceUpdateCommand();
            case -21996:
               return new TrinityTrialsUIRequest();
            case -21889:
               return new LotteryEventFlushCommand();
            case -21683:
               return new UserMessageDeleteRequest();
            case -21591:
               return new CCInitCommand();
            case -21317:
               return new SeasonPassMissionInfoCommand();
            case -21218:
               return new ExpeditionActivateShipRequest();
            case -21162:
               return new InventoryItemSellPack();
            case -21113:
               return new RerollWindowSettingsModule();
            case -21108:
               return new DominationFactionInfluenceUpdateCommand();
            case -21035:
               return new ResetSkillTreeRequest();
            case -20925:
               return new QuestSettingsRequest();
            case -20714:
               return new ApplyAcceptCommand();
            case -20695:
               return new CaptainPerkUpgradLevelCostCommand();
            case -20667:
               return new ClanApplyInfoCommand();
            case -20643:
               return new FrozenLabyrinthRankInfoCommand();
            case -20634:
               return new AssemblyCollectRequest();
            case -20579:
               return new SeasonPassLevelPurchaseRequest();
            case -20408:
               return new SlotInfoCommand();
            case -20339:
               return new ActivePerkUpdateCommand();
            case -20331:
               return new MemberLoggedOutModule();
            case -20329:
               return new SeasonPassRewardModule();
            case -20312:
               return new GalaxyGateBuilderInfoCommand();
            case -20276:
               return new SeasonPassRewardInfoCommand();
            case -20062:
               return new HangarListRequest();
            case -20038:
               return new SetBonusInfo();
            case -19971:
               return new ExpeditionShipListCommand();
            case -19955:
               return new InstantRepairAssetInformationModule();
            case -19899:
               return new AssemblyRecipeAvailableStatusModule();
            case -19755:
               return new AutopilotInfoSaveRequest();
            case -19749:
               return new ShipBoostEventBoostInfoCommand();
            case -19630:
               return new VIPMerchantExchangeInfoCommand();
            case -19463:
               return new ExpeditionJumpTargetLevelRequest();
            case -19457:
               return new UserMessageClanInfoCommand();
            case -19398:
               return new TrainingGroundPreparingForFightStatusCommand();
            case -19380:
               return new UridiumBankClaimRequest();
            case -19117:
               return new InventoryItemModifyCommand();
            case -19020:
               return new PassItemModule();
            case -18932:
               return new VoyagersPassCommand();
            case -18923:
               return new ReturneeLoginInitialRewardInfoCommand();
            case -18820:
               return new UnstableModuleRerollRequest();
            case -18807:
               return new EnergyUpdateCommand();
            case -18768:
               return new HallOfFamePagesRequest();
            case -18677:
               return new EventReturnOfHeroActionCommand();
            case -18627:
               return new RogueLiteRankInfoCommand();
            case -18578:
               return new PVPSummerEventReputationUpdateCommand();
            case -18572:
               return new ClanMemberListRequest();
            case -18421:
               return new ContactFriendInfoCommand();
            case -18395:
               return new RogueLiteSelectRewardCommand();
            case -18373:
               return new AssemblyWindowSettingsModule();
            case -18328:
               return new WildcardMessageModule();
            case -18315:
               return new CCDateValueModule();
            case -18251:
               return new ArenaMatchResultModule();
            case -18128:
               return new RankRewardCommand();
            case -17946:
               return new GalaxyGateBuilderProbabilityModule();
            case -17944:
               return new EternalGateSkillPointInfoCommand();
            case -17887:
               return new ShipDesignAddedCommand();
            case -17811:
               return new DispatchGetGateListCommand();
            case -17772:
               return new InternalPilotBioUpdateStatusRequest();
            case -17717:
               return new Curcubitor2019Command();
            case -17601:
               return new SeasonPassRewardClaimCommand();
            case -17587:
               return new UserMessageSendRequest();
            case -17553:
               return new RogueLiteScoreInfoCommand();
            case -17522:
               return new EditClanRanksCommand();
            case -17488:
               return new UnstableModuleRestabilizeResultCommand();
            case -17447:
               return new VIPMerchantExchangePackageUpdateCommand();
            case -17444:
               return new StrikeAndExitInfoRequest();
            case -17396:
               return new SkillTreeInfoCommand();
            case -17332:
               return new StrikeAndExitInfoCommand();
            case -17183:
               return new PreBlackFridaySalesInfoCommand();
            case -17156:
               return new UnstableModuleRecycleRequest();
            case -17140:
               return new BattlePassSetFilterRequest();
            case -17082:
               return new ExpeditionJumpTargetLevelCommand();
            case -17068:
               return new AchievementTitleCommand();
            case -17041:
               return new CaptainUpdateActiveBackCommand();
            case -16975:
               return new CommandCenterGetDontShowRequest();
            case -16954:
               return new MileageMarketInfoUpdateCommand();
            case -16910:
               return new PlutusStatusCommand();
            case -16874:
               return new BattlePassKeyExchangeRequest();
            case -16859:
               return new PayoutClanCommand();
            case -16771:
               return new GalaxyGateBuilderBatteryItemModule();
            case -16690:
               return new MinimapStrategyModule();
            case -16650:
               return new ArmoryUnlockClaimCommand();
            case -16529:
               return new AccountStatusChangeCommand();
            case -16461:
               return new ArenaMatchEndRequest();
            case -16338:
               return new PassEventCommand();
            case -16273:
               return new AuctionTestCommand();
            case -16228:
               return new FrozenLabyrinthSynkInfoCommand();
            case -16211:
               return new VIPMerchantExchangeItemModule();
            case -16209:
               return new CCommandRequest();
            case -16092:
               return new AssemblyRecipeRemoveCommand();
            case -16031:
               return new CCIntValueModule();
            case -15999:
               return new FrozenLabyrinthTopRankerInfoCommand();
            case -15973:
               return new MessageModule();
            case -15967:
               return new LeaderChangeCommand();
            case -15966:
               return new HintWindowClosedRequest();
            case -15960:
               return new ClanMessageInfoCommand();
            case -15948:
               return new VIPMerchantExchangeBuyRequest();
            case -15793:
               return new ExchangesShopItem();
            case -15717:
               return new AchievementInfoCommand();
            case -15662:
               return new TitleFrenzyRankingInfoCommand();
            case -15524:
               return new MileageMarketInsufficientResourcesCommand();
            case -15423:
               return new TitleFrenzyScheduleUpdateCommand();
            case -15205:
               return new SeasonPassLevelPurchaseCommand();
            case -15147:
               return new SkylabViewModuleRequest();
            case -14971:
               return new InventoryItemModule();
            case -14909:
               return new UIFeatureBarCommand();
            case -14859:
               return new AssetCreateCommand();
            case -14830:
               return new MonthlyDeluxeDayInfoCommand();
            case -14823:
               return new AutopilotInfoSaveCommand();
            case -14725:
               return new UiItemSourceModule();
            case -14707:
               return new EventANewHopeActionRequest();
            case -14686:
               return new ExpeditionSelectShipRequest();
            case -14580:
               return new DeleteClanMemberRequest();
            case -14536:
               return new ClanDeleteDiploCommand();
            case -14495:
               return new AssemblySetFilterRequest();
            case -14453:
               return new ClanRankListCommand();
            case -14383:
               return new LotteryRequest();
            case -14347:
               return new TrinityTrialsPassCommand();
            case -14283:
               return new SingleDroneEquipmentMsg();
            case -14193:
               return new RankRewardRangeModule();
            case -14075:
               return new SkylabMainViewModuleCommand();
            case -14070:
               return new UserMessageInfoCommand();
            case -14043:
               return new DispatchModule();
            case -13966:
               return new CaptainCommand();
            case -13945:
               return new RankingsEventsInfoRequest();
            case -13901:
               return new DispatchSlotCostCommand();
            case -13861:
               return new BlackListGetCommand();
            case -13847:
               return new TrainingGroundFightInfoCommand();
            case -13770:
               return new CaptainPerkUpgradLevelCommand();
            case -13736:
               return new InstantRepairRequest();
            case -13691:
               return new DispatchSlotModule();
            case -13532:
               return new CaptainGetResourcesBackCommand();
            case -13472:
               return new UnstableModulesListCommand();
            case -13451:
               return new LoginInitMyApplyCommand();
            case -13432:
               return new PayloadEscortScoreCommand();
            case -13415:
               return new ContactListRemoveContactsCommand();
            case -13281:
               return new EventQuestListCommand();
            case -13149:
               return new UserInventoryModule();
            case -13061:
               return new ReturneeLoginBundleBuyCommand();
            case -12981:
               return new HealthModule();
            case -12955:
               return new MenuItemTimerCommand();
            case -12947:
               return new ItemCommand();
            case -12941:
               return new ExpeditionRankUserInfoCommand();
            case -12924:
               return new GalaxyGateBuilderGateCompleteCommand();
            case -12901:
               return new SeasonPassRefreshRequest();
            case -12777:
               return new HangarShipEquipmentMsg();
            case -12768:
               return new MessageKeyListWildcardCommand();
            case -12658:
               return new ShipBoostEventModule();
            case -12650:
               return new CombatMusicCommand();
            case -12632:
               return new BattleStationHistoryListCommand();
            case -12606:
               return new FrozenLabyrinthInfoCommand();
            case -12408:
               return new SynthesisGroupCommand();
            case -12406:
               return new CCItemValueModule();
            case -12375:
               return new TrinityTrialsGateEnterRequest();
            case -12124:
               return new MonthlyDeluxeTimeInfoCommand();
            case -12118:
               return new RankInfoCommand();
            case -11982:
               return new KickMemberRequest();
            case -11977:
               return new ShopLabelPrompt();
            case -11925:
               return new AuctionTestRequest();
            case -11902:
               return new UserMessageLootRequest();
            case -11820:
               return new ClanInfoCommand();
            case -11778:
               return new MileageMarketPackageBuyRequest();
            case -11775:
               return new InvitationInitializationCommand();
            case -11730:
               return new RogueLiteGateRewardModule();
            case -11717:
               return new ContactListEntryAttributeClanModule();
            case -11606:
               return new ActivityModule();
            case -11502:
               return new EventANewHopeQuestCommand();
            case -11351:
               return new ClanNewRankRequest();
            case -11273:
               return new CCValueModule();
            case -11155:
               return new UpdateCargoSpaceCommand();
            case -11103:
               return new CCBooleanValueModule();
            case -11096:
               return new AssemblyRecipeUnavailableStatusModule();
            case -11095:
               return new AssemblyRecipeModule();
            case -11088:
               return new CaptainPerkCommand();
            case -11031:
               return new EquipReadyCommand();
            case -10813:
               return new JoinClanCommand();
            case -10753:
               return new GalaxyGateBuilderSetupGateCommand();
            case -10734:
               return new ClanDeleteOpenDiploRequest();
            case -10680:
               return new EternalBlacklightSkillPointInfoCommand();
            case -10623:
               return new SpaceSearchSectorRewardsCommand();
            case -10545:
               return new SkylabModuleUpgradeCommand();
            case -10518:
               return new InternalPilotBioUpdateUserNameRequest();
            case -10455:
               return new CaptainDismissBackCommand();
            case -10357:
               return new ReturneeLoginRewardClaimRequest();
            case -10262:
               return new ReturneeLoginBundleBuyRequest();
            case -10149:
               return new ExpeditionStartInstanceCommand();
            case -10087:
               return new BlackListAddRequest();
            case -9940:
               return new ExpeditionSelectShipCommand();
            case -9878:
               return new AbsUserMessageInfoCommand();
            case -9836:
               return new EternalBlacklightRankModule();
            case -9814:
               return new EventReturnOfHeroActionRequest();
            case -9602:
               return new GalaxyGateBuilderGateLifeLostCommand();
            case -9516:
               return new HangarShipEquipmentRequest();
            case -9499:
               return new EventModule();
            case -9454:
               return new RogueLiteDroneModule();
            case -9432:
               return new GalaxyGateBuilderSaveSpinAmountRequest();
            case -9323:
               return new HangarShipBriefCommand();
            case -9316:
               return new AddFireworkBoxCommand();
            case -9260:
               return new MiniClientItemRewardModule();
            case -9210:
               return new BoosterSharedDetailModule();
            case -9150:
               return new DeleteClanApplyRequest();
            case -9059:
               return new TrainingGroundLookingForOpponentStatusCommand();
            case -8903:
               return new HangarShipActivateShipRequest();
            case -8899:
               return new MonthlyDeluxeRewardModule();
            case -8898:
               return new HangarShipSellDroneRequest();
            case -8871:
               return new WorldBossRankingRewardsInfoCommand();
            case -8724:
               return new RogueLiteRankEventInfoCommand();
            case -8718:
               return new TrainingArenaRankInfoCommand();
            case -8708:
               return new RankingsEventsInfoModule();
            case -8508:
               return new EventANewHopeStatusCommand();
            case -8500:
               return new RogueLiteModifierModule();
            case -8448:
               return new CommandCenterNewsInfoRequest();
            case -8380:
               return new SpotLightPositionCommand();
            case -8355:
               return new RogueLiteCpuInfoCommand();
            case -8333:
               return new UpLevelSkillTreeCommand();
            case -8237:
               return new SeasonPassRewardUnclaimedInfoCommand();
            case -8223:
               return new UserMessageNoteDeleteRequest();
            case -8215:
               return new ActivePerkModule();
            case -8140:
               return new MenuInitializationCommand();
            case -8115:
               return new UserMessageOutboxListRequest();
            case -8107:
               return new RogueLiteSelectShipCommand();
            case -8103:
               return new AuctionDataCommand();
            case -8057:
               return new TrackStringVariableModule();
            case -7956:
               return new MonthlyDeluxeInfoCommand();
            case -7935:
               return new TrackIntVariableModule();
            case -7923:
               return new MemberLeaveCommand();
            case -7891:
               return new NpcEventBossInfoCommand();
            case -7724:
               return new AchievementValueCommand();
            case -7716:
               return new EventUnityClientRewardQuestCommand();
            case -7713:
               return new ClanModule();
            case -7705:
               return new LotteryLogCommand();
            case -7571:
               return new PetHeatUpdateCommand();
            case -7449:
               return new LotteryLogRewardCommand();
            case -7443:
               return new TieredArenaEventTierUpdateCommand();
            case -7356:
               return new TrainingGroundPlayerCombatStatusInfoCommand();
            case -7327:
               return new PingCommand();
            case -7278:
               return new EternalGateBoosterInfoCommand();
            case -7158:
               return new WarGameStatusUpdateCommand();
            case -7148:
               return new RefreshQuestInfo();
            case -7114:
               return new DispatchActiveEventCommand();
            case -7112:
               return new HallOfFameTopDataListCommand();
            case -7107:
               return new CaptainUpgradPerkBackCommand();
            case -7044:
               return new ChangeClanFirmaCommand();
            case -7006:
               return new LoginInitClanRequest();
            case -6951:
               return new SkillTreeListRequest();
            case -6731:
               return new HangarShipSaveConfigRequest();
            case -6643:
               return new SpacePlagueBossSummoningProgressCommand();
            case -6623:
               return new PlaySoundCommand();
            case -6590:
               return new ClanAddNewsRequest();
            case -6548:
               return new RewardContentCommand();
            case -6449:
               return new LocationModule();
            case -6415:
               return new DispatchGateModule();
            case -6348:
               return new CloakDeviceActivityModule();
            case -6245:
               return new SpacePlagueInfectionStatusCommand();
            case -6217:
               return new QuantumFluidCoreData();
            case -6137:
               return new RemoveCollectableCommand();
            case -6023:
               return new ChangeClanLeaderRequest();
            case -5978:
               return new CompanyDateInfoCommand();
            case -5957:
               return new InvitationBlockModule();
            case -5491:
               return new DisplayOfferCommand();
            case -5398:
               return new WindowItemCommand();
            case -5342:
               return new UserMessageLootCommand();
            case -5333:
               return new MileageMarketExchangeRequest();
            case -5303:
               return new SeasonPassStatusCommand();
            case -5208:
               return new LevelModule();
            case -5174:
               return new ClanEditDiploOfferRequest();
            case -5165:
               return new PVPSummerEventShuffleInfoCommand();
            case -5164:
               return new UserMessageNoteAddRequest();
            case -5026:
               return new MapAssetIconAddHighlightCommand();
            case -4955:
               return new SeasonPassCaptainLimitCommand();
            case -4951:
               return new AssemblyRecipeBuildStatusModule();
            case -4889:
               return new ClanDeleteDiploRequest();
            case -4822:
               return new SpaceSearchMissionListCommand();
            case -4688:
               return new BattlePassCollectRequest();
            case -4678:
               return new BattlePassInfoCommand();
            case -4652:
               return new StrikeAndExitMapInfoCommand();
            case -4583:
               return new ClanMemberListCommand();
            case -4475:
               return new RankRewardRequest();
            case -4336:
               return new RogueLiteSelectRewardRequest();
            case -4321:
               return new JackpotArenaMatchResultModule();
            case -4144:
               return new ClanListCommand();
            case -4047:
               return new GroupMemberUpdateCommand();
            case -4037:
               return new AddBoxCommand();
            case -3967:
               return new CPUInitializationCommand();
            case -3855:
               return new EventPaymentActorCommand();
            case -3769:
               return new UnstableAttributeModule();
            case -3749:
               return new ExpeditionJumpLevelInfoCommand();
            case -3669:
               return new ContactListCommand();
            case -3580:
               return new EternalGateSelectionCommand();
            case -3504:
               return new HuntRewardCommand();
            case -3461:
               return new MenuCategoryInitializationCommand();
            case -3426:
               return new TargetModule();
            case -3325:
               return new MessageKeyListWildcardModule();
            case -3281:
               return new EventActivationFactionAttributeModule();
            case -3264:
               return new PayloadEscortInfoCommand();
            case -3201:
               return new ExpeditionSelectedShipListCommand();
            case -3030:
               return new MapAddControlPOIZoneCommand();
            case -2962:
               return new InvitationAcceptRequest();
            case -2909:
               return new ShowClanInfoCommand();
            case -2840:
               return new HintWindowListInitCommand();
            case -2733:
               return new DispatchCollectRetrieverRequest();
            case -2405:
               return new EternalBlacklightWaveInfoCommand();
            case -2396:
               return new TrackVariableModule();
            case -2172:
               return new ArmoryUnlockClaimRequest();
            case -2028:
               return new HuntRewardRequest();
            case -2023:
               return new GroupMemberSelectRequest();
            case -1965:
               return new UserMessageNoteInfoCommand();
            case -1964:
               return new ClanDeleteMessageCommand();
            case -1923:
               return new TrainingGroundRoundInfoCommand();
            case -1902:
               return new RzoneRegistrationStatusModule();
            case -1859:
               return new RefreshSelectedUICategoryCommand();
            case -1858:
               return new SkylabViewModuleBackCommand();
            case -1848:
               return new HangarShipUnlockSlotCommand();
            case -1736:
               return new ArenaStatusCommand();
            case -1692:
               return new ClanTaxLogCommand();
            case -1655:
               return new AssemblyRecipeContentModule();
            case -1653:
               return new ExpeditionBackRequest();
            case -1587:
               return new EternalBlacklightBoosterInfoCommand();
            case -1585:
               return new NameChangeCommand();
            case -1319:
               return new ChangeLeaderRequest();
            case -1234:
               return new NpcEventTimeInfoCommand();
            case -1183:
               return new EpicFightMessageTypeModule();
            case -1145:
               return new AttackHitNoLockCommand();
            case -1090:
               return new EpicFightMessageCommand();
            case -814:
               return new BattlePassKeyExchangeLootModule();
            case -722:
               return new SynthesisItemRequest();
            case -721:
               return new WorldBossInfoCommand();
            case -719:
               return new ClanReportAdminRequest();
            case -620:
               return new SlotBarInitializationCommand();
            case -611:
               return new BattleStationHistoryListRequest();
            case -520:
               return new AssemblySkipRequest();
            case -504:
               return new InventoryItemAttributeModule();
            case -310:
               return new VoyagersUIRequest();
            case -241:
               return new SpacePlagueCounterDataModule();
            case -238:
               return new EventActivationMapExchangeAttributeModule();
            case -185:
               return new ContactListEntryAttributeBaseModule();
            case 1:
               return new LegacyModule();
            case 2:
               return new KeepAlive();
            case 3:
               return new AttackLaserRunCommand();
            case 4:
               return new AttackLaserRequest();
            case 5:
               return new AttackHitAssetCommand();
            case 6:
               return new AttackRocketCommand();
            case 7:
               return new LoginRequest();
            case 8:
               return new AttributeHitpointUpdateCommand();
            case 9:
               return new AttributeCreditsUpdateCommand();
            case 10:
               return new JumpRequest();
            case 11:
               return new CombatStateCommand();
            case 12:
               return new AmmunitionEmptyCommand();
            case 13:
               return new AmmunitionFallbackCommand();
            case 14:
               return new ReadyRequest();
            case 15:
               return new LogoutCancelRequest();
            case 16:
               return new LogoutCommand();
            case 17:
               return new ShipDeselectionCommand();
            case 18:
               return new JumpDeniedCommand();
            case 19:
               return new JumpInitiatedCommand();
            case 20:
               return new JumpToServerCommand();
            case 21:
               return new ServerChangeCommand();
            case 25:
               return new AttackAbortLaserRequest();
            case 26:
               return new CollectBoxRequest();
            case 27:
               return new AttackTypeModule();
            case 28:
               return new AttackHitCommand();
            case 29:
               return new HeroMoveCommand();
            case 30:
               return new ShipDestroyedCommand();
            case 31:
               return new HealCommand();
            case 32:
               return new ActivationStatedRequest();
            case 33:
               return new ActivationRequest();
            case 34:
               return new DropRequest();
            case 35:
               return new ConfigChangeRequest();
            case 36:
               return new JumpCPUUpdateRequest();
            case 37:
               return new JumpCPUSelectRequest();
            case 38:
               return new AmmunitionTypeModule();
            case 39:
               return new AmmunitionPrizeItem();
            case 40:
               return new AmmunitionPrizeInfoCommand();
            case 41:
               return new AmmunitionBuyRequest();
            case 42:
               return new AmmunitionBuyCommand();
            case 46:
               return new MessageLocalizedCommand();
            case 47:
               return new MessageLocalizedWildcardCommand();
            case 48:
               return new MessageWildcardReplacementModule();
            case 49:
               return new ShipInitializationCommand();
            case 50:
               return new ShipSelectionCommand();
            case 51:
               return new AssetDeselection();
            case 52:
               return new ShipRemoveCommand();
            case 56:
               return new ExtraInfoCommand();
            case 57:
               return new CPUInfoHomeJumpCommand();
            case 58:
               return new CPUInfoAimCommand();
            case 59:
               return new CPUInfoCloakCommand();
            case 60:
               return new CPUInfoAutoRocketCommand();
            case 61:
               return new LoginErrorCommand();
            case 62:
               return new CPUInfoTradeDroneCommand();
            case 63:
               return new JumpCPUSelectCommand();
            case 64:
               return new JumpCPUPowerupStatusCommand();
            case 65:
               return new JumpCPUUpdateCommand();
            case 66:
               return new JumpCPUPriceMappingModule();
            case 67:
               return new AdvertisementViableCommand();
            case 68:
               return new TechTypeModule();
            case 69:
               return new TechActivationRequest();
            case 70:
               return new StatusModule();
            case 71:
               return new TechStatusItemModule();
            case 72:
               return new TechStatusCommand();
            case 73:
               return new TechActivationCommand();
            case 74:
               return new TechDeactivationCommand();
            case 80:
               return new AssetInfoCommand();
            case 81:
               return new TradeRequest();
            case 82:
               return new MoveRequest();
            case 83:
               return new ShipCreateCommand();
            case 84:
               return new SettingSetRequest();
            case 85:
               return new SettingSetCommand();
            case 86:
               return new CPUInfoAutoRocketLauncherCommand();
            case 87:
               return new SettingRemoveRequest();
            case 88:
               return new SettingsOldFlashCommand();
            case 89:
               return new AttackRocketRequest();
            case 90:
               return new MoveCommand();
            case 91:
               return new CooldownReachedCommand();
            case 92:
               return new CooldownTypeModule();
            case 93:
               return new CooldownStartedCommand();
            case 94:
               return new HarvestRequest();
            case 95:
               return new AttributeLevelUpUpdateCommand();
            case 96:
               return new AttributeShipSpeedUpdateCommand();
            case 97:
               return new AttributeSpaceUpdateCommand();
            case 98:
               return new AttributeConfigCountUpdateCommand();
            case 100:
               return new BoosterUpdateModule();
            case 101:
               return new AttributeBoosterUpdateCommand();
            case 102:
               return new AttributeSkillRepairUpdateCommand();
            case 103:
               return new AttributeSkillShieldUpdateCommand();
            case 105:
               return new OreCountModule();
            case 106:
               return new AttributeOreCountUpdateCommand();
            case 107:
               return new AchievementEarnedCommand();
            case 108:
               return new AchievementEndCommand();
            case 112:
               return new UICamLockToHeroCommand();
            case 113:
               return new UICamLockToShipCommand();
            case 114:
               return new UICamLockToCoordinatesCommand();
            case 115:
               return new UIMinimapNoiseCommand();
            case 116:
               return new UIMinimapMarkerCommand();
            case 117:
               return new UIWindowCreateCommand();
            case 118:
               return new UIWindowDestroyCommand();
            case 119:
               return new UIWindowNextPageRequest();
            case 120:
               return new UIArrowCommand();
            case 121:
               return new WindowIDModule();
            case 122:
               return new UIWindowActionCommand();
            case 123:
               return new UIWindowActionModule();
            case 124:
               return new ButtonIDModule();
            case 125:
               return new UIButtonActionModule();
            case 126:
               return new UIButtonActionCommand();
            case 127:
               return new UILayerAdvertisementCommand();
            case 129:
               return new OrePriceModule();
            case 130:
               return new TradeReplyCommand();
            case 131:
               return new TradeSellOreRequest();
            case 132:
               return new LabRefinementRequest();
            case 133:
               return new LabUpdateItemRequest();
            case 134:
               return new LabItemModule();
            case 135:
               return new LabUpdateItemCommand();
            case 136:
               return new UpdateItemModule();
            case 137:
               return new LabUpdateRequest();
            case 138:
               return new MapChangedCommand();
            case 141:
               return new JumpGateTypeModule();
            case 143:
               return new MapEventOreCommand();
            case 146:
               return new AssetTypeModule();
            case 147:
               return new AddOreCommand();
            case 149:
               return new PerformanceTrackingGetCommand();
            case 150:
               return new PerformanceTrackingSendInfoRequest();
            case 151:
               return new DebuggingServerShipPositionCommand();
            case 152:
               return new AlignmentModule();
            case 153:
               return new PetRequest();
            case 154:
               return new PetGearActivationRequest();
            case 155:
               return new PetHeroActivationCommand();
            case 156:
               return new PetDeactivationCommand();
            case 157:
               return new PetStatusCommand();
            case 158:
               return new PetHitpointsUpdateCommand();
            case 159:
               return new PetExperiencePointsUpdateCommand();
            case 160:
               return new PetLevelUpdateCommand();
            case 161:
               return new PetShieldUpdateCommand();
            case 162:
               return new PetFuelUpdateCommand();
            case 163:
               return new AttackMissedCommand();
            case 164:
               return new PetGearTypeModule();
            case 165:
               return new ShipSelectRequest();
            case 166:
               return new PetLocatorGearInitializationCommand();
            case 174:
               return new MessageMapEventCommand();
            case 176:
               return new MessageGameEventCommand();
            case 177:
               return new MapEventAttackedObjectOwnedCommand();
            case 178:
               return new MapEventAttackedObjectReleasedCommand();
            case 179:
               return new MapEventCloakStateCommand();
            case 180:
               return new MapEventDroneInfoCommand();
            case 181:
               return new MapEventEnemyWarningCommand();
            case 182:
               return new ShipSpawnChildSwarmCommand();
            case 183:
               return new MapEventTitleUpdateCommand();
            case 184:
               return new MapEventSmartbombExplosionCommand();
            case 185:
               return new MapEventInstashieldActivationCommand();
            case 186:
               return new MapEventEMPActivationCommand();
            case 187:
               return new BoosterFoundOnMapCommand();
            case 188:
               return new MapEventMapTitleUpdateCommand();
            case 189:
               return new MapEventSetShipAttackableCommand();
            case 190:
               return new SpaceBallInitializeScoreCommand();
            case 191:
               return new SpaceBallUpdateScoreCommand();
            case 192:
               return new SpaceBallUpdateSpeedCommand();
            case 194:
               return new HuntEventRankingPointsUpdateCommand();
            case 197:
               return new HuntEventNotificationCommand();
            case 198:
               return new CTBSetHomeZonesCommand();
            case 199:
               return new LMJackpotLeftShipsCommand();
            case 201:
               return new LMDiscountInfoCommand();
            case 202:
               return new LogMessengerPriorityModule();
            case 203:
               return new LMCollectResourcesCommand();
            case 204:
               return new LMColletJackpotCommand();
            case 205:
               return new LMCollectLogFilesCommand();
            case 206:
               return new LMCollectCreditsCommand();
            case 207:
               return new LMCollectUridiumCommand();
            case 208:
               return new LMCollectExperiencePointsCommand();
            case 209:
               return new LMCollectHonorPointsCommand();
            case 210:
               return new LMCollectAmmunitionCommand();
            case 211:
               return new LMCollectBankingMultiplierCommand();
            case 212:
               return new LMGGEnergyCollectedCommand();
            case 213:
               return new LMItemCollectedCommand();
            case 214:
               return new LMLootCollectedCommand();
            case 215:
               return new LMMineExplodedCommand();
            case 216:
               return new LMBoxCollectionCancelledCommand();
            case 217:
               return new LMInvisibilityDetectorInfoCommand();
            case 218:
               return new CTBScoreUpdateCommand();
            case 219:
               return new CTBMatchStateCommand();
            case 220:
               return new CTBBeaconCapturedCommand();
            case 221:
               return new CTBBeaconReleasedCommand();
            case 222:
               return new CTBBeaconPositionCommand();
            case 223:
               return new InvasionEventInitCommand();
            case 226:
               return new PetOutOfFuelCommand();
            case 227:
               return new PetIsDestroyedCommand();
            case 228:
               return new PetEvasionCommand();
            case 229:
               return new PetInitializationCommand();
            case 230:
               return new PetRepairCompleteCommand();
            case 231:
               return new PetPurchasedCommand();
            case 232:
               return new PetActivationCommand();
            case 233:
               return new PetGearRemoveCommand();
            case 234:
               return new PetGearAddCommand();
            case 235:
               return new PetGearResetCommand();
            case 236:
               return new PetGearSelectCommand();
            case 237:
               return new PetGearLocatorUpdate();
            case 239:
               return new PetBuffCommand();
            case 240:
               return new UIWindowBlockModeCommand();
            case 241:
               return new PetHarvestEffectCommand();
            case 242:
               return new PetIdleModeCommand();
            case 243:
               return new PetLaserAttackStopCommand();
            case 244:
               return new PetUIRepairButtonCommand();
            case 245:
               return new ClientLoggedInCommand();
            case 246:
               return new PetBlockUICommand();
            case 247:
               return new PetTradeWindowShowCommand();
            case 248:
               return new AttributeShieldUpdateCommand();
            case 249:
               return new MessageQueueModule();
            case 250:
               return new CollectionBeamStartCommand();
            case 251:
               return new CollectionBeamStopCommand();
            case 252:
               return new KillScreenPostCommand();
            case 253:
               return new KillScreenOptionModule();
            case 254:
               return new KillScreenOptionTypeModule();
            case 255:
               return new KillScreenRepairRequest();
            case 257:
               return new DroneFormationChangeCommand();
            case 258:
               return new DroneFormationAvailableFormationsCommand();
            case 259:
               return new DestructionTypeModule();
            case 260:
               return new ChannelCloseRequest();
            case 264:
               return new QualitySettingsRequest();
            case 265:
               return new GameplaySettingsRequest();
            case 266:
               return new DisplaySettingsRequest();
            case 267:
               return new AudioSettingsRequest();
            case 268:
               return new WindowSettingsRequest();
            case 269:
               return new QualitySettingsModule();
            case 270:
               return new DisplaySettingsModule();
            case 271:
               return new AudioSettingsModule();
            case 272:
               return new WindowSettingsModule();
            case 273:
               return new GameplaySettingsModule();
            case 275:
               return new AbilityEffectActivationCommand();
            case 276:
               return new AbilityStatusSingleCommand();
            case 277:
               return new AbilityStatusFullCommand();
            case 278:
               return new AbilityStopCommand();
            case 279:
               return new AbilityStartCommand();
            case 280:
               return new VisualModifierCommand();
            case 281:
               return new MarkTargetCommand();
            case 282:
               return new AbilityEffectDeActivationCommand();
            case 287:
               return new HellstormAttackCommand();
            case 288:
               return new ShipExtensionsCommand();
            case 290:
               return new ShipWarpRequest();
            case 291:
               return new ShipWarpWindowCommand();
            case 293:
               return new ShipWarpModule();
            case 296:
               return new ShopItemListCommand();
            case 316:
               return new SpacePlagueRatingStatusCommand();
            case 331:
               return new SpecialEventPaymentActorCommand();
            case 340:
               return new UIWindowSettingsCommand();
            case 341:
               return new UIWindowSettingsRequest();
            case 342:
               return new UIWindowSettingModule();
            case 343:
               return new ResetSettingsRequest();
            case 399:
               return new ReturneeLoginInitialRewardClaimableInfoCommand();
            case 498:
               return new UpdateNamFIagCommand();
            case 509:
               return new MapAssetIconRemoveHighlightCommand();
            case 520:
               return new SectorControlMatchOverviewRequest();
            case 521:
               return new SectorControlMatchOverviewCommand();
            case 523:
               return new SectorControlMatchOverviewModule();
            case 524:
               return new SectorControlMatchDetailRequest();
            case 525:
               return new SectorControlMatchJoinRequest();
            case 527:
               return new SectorControlMatchDetailCommand();
            case 572:
               return new GalaxyGateBuilderBonusGGRewardModule();
            case 629:
               return new ClanTaxInfoCommand();
            case 666:
               return new VersionRequest();
            case 667:
               return new VersionCommand();
            case 672:
               return new KillUiFullMessageCommand();
            case 682:
               return new EternalGateWaveInfoCommand();
            case 684:
               return new LootProbabilityModule();
            case 692:
               return new HangarShipDetailRequest();
            case 712:
               return new HangarShipMoveItemsCommand();
            case 741:
               return new TupleTwoModule();
            case 773:
               return new BalanceInfoListRequest();
            case 800:
               return new UserKeyBindingsModule();
            case 801:
               return new UserKeyBindingsUpdate();
            case 871:
               return new ClearMarkersCommand();
            case 899:
               return new AddMapEntityCommand();
            case 927:
               return new VoyagersGateEnterRequest();
            case 1001:
               return new ShipWarpCompletedCommand();
            case 1002:
               return new ShipWarpNotAllowedCommand();
            case 1010:
               return new ShipWarpCanceledCommand();
            case 1011:
               return new ShipWarpWindowCloseCommand();
            case 1059:
               return new AttackRangeExceededCommand();
            case 1111:
               return new ClanNewDiplomacyCommand();
            case 1150:
               return new StarmapStationCommand();
            case 1151:
               return new StarmapStationInfo();
            case 1300:
               return new HitpointInfoCommand();
            case 1311:
               return new BoostedAttributeTypeModule();
            case 1339:
               return new ClanNewRankCommand();
            case 1394:
               return new ClanFilterSearchInfoCommand();
            case 1520:
               return new TeamDeathMatchOverviewInitRequest();
            case 1521:
               return new TeamDeathMatchOverviewCommand();
            case 1523:
               return new TeamDeathMatchOverviewModule();
            case 1524:
               return new TeamDeathMatchDetailRequest();
            case 1525:
               return new TeamDeathMatchJoinRequest();
            case 1527:
               return new TeamDeathMatchDetailCommand();
            case 1542:
               return new HangarShipUnlockSlotRequest();
            case 1550:
               return new EvoucherHistoryListRequest();
            case 1555:
               return new AgatusEventTimeInfoCommand();
            case 1558:
               return new SpaceSearchRequest();
            case 1657:
               return new ApplyClanRequest();
            case 1667:
               return new TeamDeathMatchStatusUpdateCommand();
            case 1670:
               return new ShowClanInfoRequest();
            case 1724:
               return new TeamDeathMatchResultScreenPlayerModule();
            case 1725:
               return new RewardModule();
            case 1738:
               return new ChangeClanTaxCommand();
            case 1810:
               return new UnstableModuleRecycleResultCommand();
            case 1811:
               return new QuestLocalizationModule();
            case 1870:
               return new OreTradeInfoCommand();
            case 1880:
               return new TimerStateModule();
            case 1883:
               return new ContactListRequest();
            case 1978:
               return new GalaxyGateBuilderSetupGateRequest();
            case 2000:
               return new QuestCaseModule();
            case 2001:
               return new QuestElementModule();
            case 2002:
               return new QuestConditionModule();
            case 2004:
               return new QuestCompletedCommand();
            case 2005:
               return new QuestFailedCommand();
            case 2006:
               return new QuestCancelledCommand();
            case 2014:
               return new QuestConditionUpdateCommand();
            case 2016:
               return new LootModule();
            case 2017:
               return new QuestInitializationCommand();
            case 2022:
               return new QuestPrivilegeCommand();
            case 2023:
               return new QuestPrivilegeRequest();
            case 2024:
               return new QuestCancelRequest();
            case 2035:
               return new QuestAcceptRequest();
            case 2037:
               return new QuestConditionStateModule();
            case 2073:
               return new QuestInfoRequest();
            case 2074:
               return new QuestListRequest();
            case 2075:
               return new QuestListCommand();
            case 2078:
               return new QuestSlimInfoModule();
            case 2085:
               return new QuestGiverModule();
            case 2090:
               return new QuestInfoCommand();
            case 2099:
               return new QuestDefinitionModule();
            case 2100:
               return new QuestIconModule();
            case 2154:
               return new ClanAddNewsCommand();
            case 2200:
               return new ExpeditionInfoCommand();
            case 2211:
               return new EventActivationStateCommand();
            case 2213:
               return new ArmoryUnlockClaimInfoGroupCommand();
            case 2237:
               return new BattlePassKeyExchangeRewardModule();
            case 2270:
               return new VideoWindowCreateCommand();
            case 2271:
               return new VideoWindowNextPageCommand();
            case 2272:
               return new VideoWindowRemoveCommand();
            case 2280:
               return new CameraLockToCoordinatesCommand();
            case 2281:
               return new CameraLockToHeroCommand();
            case 2282:
               return new CameraLockToShipCommand();
            case 2333:
               return new ClanNewsListCommand();
            case 2345:
               return new QuestGiversAvailableCommand();
            case 2371:
               return new PVPSummerEventInfoCommand();
            case 2398:
               return new EternalGateRankInfoCommand();
            case 2521:
               return new TeamDeathMatchOverviewInitCommand();
            case 2590:
               return new LogMessageCommand();
            case 2610:
               return new PublicWorldBossInfoCommand();
            case 2833:
               return new Birthday2025PointRewardCommand();
            case 2835:
               return new DailyLoginRewardDayCommand();
            case 2850:
               return new AddBeaconCommand();
            case 2853:
               return new TieredArenaEventSelfReputationUpdateCommand();
            case 2870:
               return new EventActivationAttributeModule();
            case 2891:
               return new HangarShipAutoBuyCpuAmmoCommand();
            case 2904:
               return new ClanApplyInfoListRequest();
            case 3034:
               return new AssemblyBuildRequest();
            case 3106:
               return new EventSummaryScoreCommand();
            case 3135:
               return new ArmoryUnlockClaimInfoCommand();
            case 3245:
               return new AssetRemoveCommand();
            case 3260:
               return new MapAssetAddBillboardCommand();
            case 3261:
               return new PartnerTypeModule();
            case 3292:
               return new MiniClientRewardInfoCommand();
            case 3333:
               return new GroupInvitationRequest();
            case 3336:
               return new ClanMemberModule();
            case 3350:
               return new QuestGiverApproachedRequest();
            case 3360:
               return new EchoRequest();
            case 3366:
               return new QuestRequirementModule();
            case 3375:
               return new TrainingGroundCancelRequest();
            case 3389:
               return new JumpgateCreateCommand();
            case 3520:
               return new ClanDeleteOpenDiploCommand();
            case 3523:
               return new CommandCenterNewsModule();
            case 3530:
               return new POIVisualModifierCommand();
            case 3575:
               return new GroupErrorCommand();
            case 3583:
               return new UpdateNamFIagRequest();
            case 3792:
               return new BoosterPlayerDetailModule();
            case 3853:
               return new UserMessageNoteListRequest();
            case 3885:
               return new MileageMarketEventBuyRequest();
            case 3923:
               return new HangarShipClearConfigRequest();
            case 4042:
               return new ExpeditionShowUiCommand();
            case 4060:
               return new HangarShipDetailCommand();
            case 4064:
               return new CCommandModule();
            case 4076:
               return new ContactListEntryTypeCommand();
            case 4087:
               return new TrinityTrialsDropLevelOptionalRequest();
            case 4141:
               return new QuestTypeModule();
            case 4195:
               return new RemoveMinimapMark();
            case 4228:
               return new ClanFilterSearchRequest();
            case 4274:
               return new JumpGateRemoveCommand();
            case 4321:
               return new QuestChallengeRatingModule();
            case 4334:
               return new HangarShipRenamePetCommand();
            case 4444:
               return new ClanTagChangedCommand();
            case 4465:
               return new HangarShipDroneView();
            case 4519:
               return new WarGameExitRequest();
            case 4613:
               return new HangarShipRepairDroneRequest();
            case 4642:
               return new ArmoryUnlockDrawCommand();
            case 4712:
               return new InfiltrationStatusCommand();
            case 4713:
               return new CountdownStatusCommand();
            case 4714:
               return new CountdownStatusTypeModule();
            case 4715:
               return new CountdownStatusCloseWindowCommand();
            case 4718:
               return new HintWindowAddComand();
            case 4739:
               return new EmoteActivationCommand();
            case 4818:
               return new MileageMarketPackageModule();
            case 4837:
               return new InvitationErrorCommand();
            case 4845:
               return new ClanApplyInfoListCommand();
            case 4861:
               return new ClanDeleteAllMessageCommand();
            case 4874:
               return new AuctionListRequest();
            case 4898:
               return new UserMessageNoteListCommand();
            case 4943:
               return new PetGearActivationChangeCommand();
            case 5030:
               return new CaptchaBoxModule();
            case 5101:
               return new ContactListEntryAttributeMapModule();
            case 5159:
               return new WarGameJoinRequest();
            case 5199:
               return new UserMessageTargetInfoCommand();
            case 5255:
               return new SectorControlMatchLeaveQueueRequest();
            case 5305:
               return new RewardContentModule();
            case 5351:
               return new Birthday2025ClaimRequest();
            case 5366:
               return new SkylabActiveRobotsLeftTimeCommand();
            case 5390:
               return new OfferRequest();
            case 5412:
               return new InternalPilotBioUpdateResultsCommand();
            case 5457:
               return new BlackListAddCommand();
            case 5478:
               return new ClanDeleteMessageRequest();
            case 5593:
               return new CommandCenterInfoCommand();
            case 5598:
               return new Birthday2025GateEnterRequest();
            case 5738:
               return new ReqDroneBoostInfo();
            case 5769:
               return new BoosterBattleStationDetailModule();
            case 5955:
               return new HallOfFamePages();
            case 5985:
               return new ChangeClanFirmaRequest();
            case 6001:
               return new AvailableModulesCommand();
            case 6002:
               return new AsteroidProgressCommand();
            case 6003:
               return new BattleStationBuildingStateCommand();
            case 6004:
               return new BattleStationManagementUiInitializationCommand();
            case 6005:
               return new BattleStationStatusCommand();
            case 6006:
               return new BuildStationRequest();
            case 6007:
               return new CompanyHierarchyInitializationCommand();
            case 6008:
               return new CompanyHierarchyRankingModule();
            case 6009:
               return new CompanyHierarchyRequest();
            case 6010:
               return new DeflectorShieldStatusChangeRequest();
            case 6011:
               return new EmergencyRepairRequest();
            case 6012:
               return new BattleStationErrorCommand();
            case 6013:
               return new EquipModuleRequest();
            case 6014:
               return new EquippedModulesModule();
            case 6015:
               return new OutOfBattleStationRangeCommand();
            case 6016:
               return new BattleStationBuildingUiInitializationCommand();
            case 6017:
               return new StationModuleModule();
            case 6018:
               return new UnequipModuleRequest();
            case 6030:
               return new BattleStationNoClanUiInitializationCommand();
            case 6226:
               return new PayloadEscortTimeInfoCommand();
            case 6247:
               return new ChrominUpdateCommand();
            case 6277:
               return new WordPuzzleLetterAchievedCommand();
            case 6278:
               return new WordPuzzleWindowInitCommand();
            case 6279:
               return new WordPuzzleLetterModule();
            case 6290:
               return new EventQuestDefinitionModule();
            case 6297:
               return new GalaxyGateBuilderGetGatePartsCommand();
            case 6392:
               return new BattlePassWindowSettingsModule();
            case 6521:
               return new SectorControlMatchExitRequest();
            case 6530:
               return new MapAssetActionAvailableCommand();
            case 6570:
               return new SynthesisCostLootCommand();
            case 6587:
               return new MapAssetActivationRequest();
            case 6661:
               return new TitleFrenzyRankingInfoModule();
            case 6667:
               return new SectorControlMatchStateInfoCommand();
            case 6668:
               return new SectorControlBonusCommand();
            case 6669:
               return new SectorControlTicketCountCommand();
            case 6671:
               return new PlayerQueueRegistrationCommand();
            case 6672:
               return new PlayerQueueAlreadyRegisteredCommand();
            case 6674:
               return new POITypeModule();
            case 6675:
               return new POIDesignModule();
            case 6676:
               return new MapRemovePOICommand();
            case 6677:
               return new POIReadyCommand();
            case 6678:
               return new SectorControlCaptureParticipationCommand();
            case 6745:
               return new EditClanMemberRequest();
            case 6768:
               return new AllowUnityOnlyCommand();
            case 6777:
               return new KillScreenUpdateCommand();
            case 6844:
               return new EditClanRanksRequest();
            case 6855:
               return new HangarShipsCommand();
            case 6868:
               return new ContactListEntryAttributeLevelModule();
            case 6918:
               return new ExpeditionClearanceTimeCommand();
            case 6926:
               return new SpacePlagueStatusCommand();
            case 6987:
               return new SeasonPointsInfoCommand();
            case 7002:
               return new ModuleStatusUpdateCommand();
            case 7010:
               return new ClanRelationModule();
            case 7011:
               return new SpaceSearchSectorRewards();
            case 7023:
               return new DiminishingQuestAcceptQuestRequest();
            case 7032:
               return new ReplacementModule();
            case 7050:
               return new ExchangeShopRequest();
            case 7088:
               return new HangarShipRepairModuleRequest();
            case 7121:
               return new BattleStationHistoryInfoCommand();
            case 7123:
               return new SectorControlErrorCommand();
            case 7124:
               return new SectorControlDraftConfirmationCommand();
            case 7125:
               return new SectorControlDraftConfirmationRequest();
            case 7199:
               return new TeamDeathMatchDraftConfirmationRequest();
            case 7337:
               return new QuestSettingsModule();
            case 7492:
               return new ContactListEntryModule();
            case 7507:
               return new WarGameLobbyStatusModule();
            case 7513:
               return new LevelUpCommand();
            case 7600:
               return new HangarShipRenamePetRequest();
            case 7651:
               return new MemberDestructionCommand();
            case 7652:
               return new ClanDiploInfoCommand();
            case 7715:
               return new AssemblyRecipeReadyToCollectStatusModule();
            case 7747:
               return new PingPositionRequest();
            case 7763:
               return new ContactFriendAcceptTipsCommand();
            case 7770:
               return new SectorControlPlayerCountModule();
            case 7779:
               return new HealBeamCommand();
            case 7872:
               return new PlayVisualEffectCommand();
            case 7906:
               return new SeasonPassMissionStatusModule();
            case 7953:
               return new CCAttributeModule();
            case 7997:
               return new LockAttributeItemModule();
            case 8160:
               return new PlayerAttributeModule();
            case 8345:
               return new SkylabStorageOreCommand();
            case 8404:
               return new ClanMessageListRequest();
            case 8408:
               return new GetNamFIagRequest();
            case 8427:
               return new StayinAlive();
            case 8687:
               return new PublicWorldBossRankCommand();
            case 8766:
               return new MenuActionRequest();
            case 8782:
               return new ClanNameTagInfoCommand();
            case 8850:
               return new UserMessageUpdateStatusCommand();
            case 8899:
               return new SeasonPassRewardClaimRequest();
            case 8991:
               return new ExpeditionInfoRequest();
            case 9070:
               return new EndEventSummaryScoreCommand();
            case 9075:
               return new InvitationCreationRequest();
            case 9131:
               return new TeamDeathMatchErrorCommand();
            case 9237:
               return new AchievementListRequest();
            case 9325:
               return new ShopItemListRequest();
            case 9421:
               return new PopupErrorMessageCommand();
            case 9574:
               return new ApplyClanCommand();
            case 9667:
               return new FactionScoreModule();
            case 9705:
               return new JackpotArenaMatchResultCommand();
            case 9750:
               return new LotteryRequestCommand();
            case 9790:
               return new KillUiInfoMessageCommand();
            case 9826:
               return new SummonNPCRequest();
            case 9999:
               return new FactionModule();
            case 10101:
               return new QuestAcceptabilityStatusModule();
            case 10104:
               return new FrozenLabyrinthTimeInfoCommand();
            case 10141:
               return new AttackAbortLaserCommand();
            case 10175:
               return new ReturneeLoginRewardInfoCommand();
            case 10223:
               return new EvoucherHistoryInfoCommand();
            case 10291:
               return new TrainingGroundStatusDataModule();
            case 10344:
               return new MileageMarketBuyCommand();
            case 10529:
               return new HangarShipActivateShipCommand();
            case 10597:
               return new PetFuelCargoFullMessage();
            case 10613:
               return new ShipBoostEventAttributeModule();
            case 10623:
               return new EventRewardConfirmationCommand();
            case 10659:
               return new EternalBlacklightRankInfoCommand();
            case 10716:
               return new RzoneSignUpRequest();
            case 10736:
               return new BlackListDeleteRequest();
            case 10857:
               return new EternalBlacklightRankingEventInfoCommand();
            case 10888:
               return new EventANewHopeContributorListCommand();
            case 11037:
               return new ClanSendAllMessageRequest();
            case 11090:
               return new CaptainActionRequest();
            case 11117:
               return new CaptchaResolvedCommand();
            case 11445:
               return new MessageCommand();
            case 11573:
               return new SkylabStorageInfoCommand();
            case 11676:
               return new CaptchaTriggerCommand();
            case 11704:
               return new ActivationZoneStatusCommand();
            case 11779:
               return new LeaveGroupRequest();
            case 11796:
               return new GroupInitializationCommand();
            case 11805:
               return new CommandCenterDontShowInfoCommand();
            case 11902:
               return new NpcUndockCommand();
            case 12053:
               return new CCStringValueModule();
            case 12101:
               return new RogueLiteSelectShipRequest();
            case 12117:
               return new FollowRequest();
            case 12121:
               return new QuestListRemoveCommand();
            case 12122:
               return new QuestListUpdateCommand();
            case 12147:
               return new HangarShipFavouriteRequest();
            case 12260:
               return new ApplyAcceptRequest();
            case 12271:
               return new TrainingGroundSummingUpStatusCommand();
            case 12398:
               return new ShipBoostEventInfoCommand();
            case 12409:
               return new PlayerUpdateCommand();
            case 12706:
               return new AutopilotStatus();
            case 12716:
               return new DispatchSlotInfoCommand();
            case 12806:
               return new WorldBossCompletionModule();
            case 12937:
               return new ProActionBarOpenStateChangeRequest();
            case 12941:
               return new DisassemblyRequest();
            case 13016:
               return new ClanBattleStationInfoCommand();
            case 13131:
               return new PriceModule();
            case 13149:
               return new BattleStationOverviewInfoCommand();
            case 13230:
               return new ShopItemLevelDataCommand();
            case 13255:
               return new TeamDeathMatchLeaveQueueRequest();
            case 13300:
               return new ClanSearchNameTagRequest();
            case 13360:
               return new AuctionListCommand();
            case 13418:
               return new RogueLiteDisableEquipCommand();
            case 13422:
               return new ContactRequest();
            case 13545:
               return new MiniClientRewardClaimRequest();
            case 13627:
               return new DispatchGetRetrieverListRequest();
            case 13628:
               return new RzoneLeavingStatusModule();
            case 13647:
               return new PublicWorldBossRaidCommand();
            case 13922:
               return new LoginResponse();
            case 13943:
               return new DispatchLootMessageCommand();
            case 13970:
               return new EditClanMemberCommand();
            case 14061:
               return new VoyagersGateWindowCommand();
            case 14081:
               return new CannonAttackCommand();
            case 14104:
               return new EventActivationIntegerAttributeModule();
            case 14139:
               return new ContactUiUnblockCommand();
            case 14187:
               return new HangarShipLoadConfigCommand();
            case 14266:
               return new AssetInformationModule();
            case 14378:
               return new CannonUnstableModuleModule();
            case 14407:
               return new TieredArenaEventScheduleInfoCommand();
            case 14466:
               return new AddMineCommand();
            case 14497:
               return new WarGameTeamCountUpdateCommand();
            case 14525:
               return new SkylabXenoInfoCommand();
            case 14839:
               return new GalaxyGateBuilderMultiGateProgressModule();
            case 14848:
               return new InternalPilotBioRequest();
            case 14903:
               return new AssemblyRecipeRegularTypeModule();
            case 14934:
               return new UnstableModuleRestabiliseRequest();
            case 15247:
               return new ArmoryUnlockInfoRequest();
            case 15320:
               return new ClanSendAllMessageCommand();
            case 15373:
               return new DiminishingQuestAcceptQuestResponse();
            case 15435:
               return new RzoneCancelSignUpRequest();
            case 15458:
               return new ContactBaseInfoCommand();
            case 15484:
               return new HallOfFameDataCommand();
            case 15537:
               return new UserMessageNoteUpdateCommand();
            case 15573:
               return new UserMessageInboxListRequest();
            case 15614:
               return new PlanetCommand();
            case 15621:
               return new ExpeditionBuyTicketCommand();
            case 15632:
               return new UserMessageOutboxListCommand();
            case 15651:
               return new SynthesisInventoryCommand();
            case 15706:
               return new BattlePassQuestModule();
            case 15963:
               return new HangarShipRepairModuleCommand();
            case 16014:
               return new AchievementListCommand();
            case 16029:
               return new GalaxyGateBuilderMultiEnergyCommand();
            case 16049:
               return new SeasonPassRefreshCountCommand();
            case 16089:
               return new ReturneeLoginRewardDayInfoCommand();
            case 16096:
               return new SkylabModuleProductivityCommand();
            case 16103:
               return new NotifyNewDiploCommand();
            case 16440:
               return new FoundClanCommand();
            case 16640:
               return new WarGameInitLobbyRequest();
            case 16647:
               return new ContactListEntryAttributeClanRelationModule();
            case 16736:
               return new ExpeditionShipListRequest();
            case 16790:
               return new EmperorSibelonBuffRingCommand();
            case 16953:
               return new TrinityTrialsGateWindowCommand();
            case 17027:
               return new DispatchInstantCompleteRequest();
            case 17210:
               return new ShopItemBuyRequest();
            case 17211:
               return new ExpeditionResetRequest();
            case 17217:
               return new LockAttributeItemRerollCommand();
            case 17270:
               return new SynthesisListCommand();
            case 17403:
               return new DailyLoginClaimTodayCommand();
            case 17419:
               return new TdmResultCommand();
            case 17453:
               return new ConvertResearchPointsCommand();
            case 17529:
               return new ContactListInitializationCommand();
            case 17636:
               return new HangarShipClearConfigCommand();
            case 17648:
               return new ExpeditionRewardCommand();
            case 17829:
               return new Curcubitor2019TimeUpdateCommand();
            case 17842:
               return new TrainingGroundRegistrationStatusCommand();
            case 17891:
               return new LogbookDataListCommand();
            case 17918:
               return new ClanRankInfoCommand();
            case 17926:
               return new UserMessageDeleteCommand();
            case 17938:
               return new HangarShipSellItemCommand();
            case 18130:
               return new UserMessageInboxListCommand();
            case 18132:
               return new SeasonPassRewardClaimAllRequest();
            case 18192:
               return new UserMessageSystemInfoCommand();
            case 18219:
               return new UIWindowUpdateRequest();
            case 18323:
               return new MarkPositionCommand();
            case 18335:
               return new DesignSetUpdateCommand();
            case 18388:
               return new InventoryItemPack();
            case 18458:
               return new CaptchaExplodeCommand();
            case 18518:
               return new LockAttributeItemListCommand();
            case 18565:
               return new UserMessageInfoInfoCommand();
            case 18647:
               return new RankModule();
            case 18709:
               return new ChatAuthenticateUserRequest();
            case 18787:
               return new GroupCloseCommand();
            case 18803:
               return new StartCapsuleCollectCommand();
            case 18874:
               return new HangarShipFavouriteCommand();
            case 18935:
               return new RogueLiteChangeEquipmentRequest();
            case 18936:
               return new ArenaSurvivorsUpdateCommand();
            case 18960:
               return new EventCommand();
            case 18974:
               return new EternalBlacklightChooseOptionRequest();
            case 18999:
               return new ArmoryUnlockInfoCommand();
            case 19062:
               return new UIItemRemoveHighlightCommand();
            case 19063:
               return new RemoveMineCommand();
            case 19090:
               return new HangarShipLoadConfigRequest();
            case 19132:
               return new ClaimUnityClientRewardRequest();
            case 19157:
               return new TrainingArenaSeasonInfoCommand();
            case 19242:
               return new MonthlyDeluxeClaimRequest();
            case 19264:
               return new ReturneeLoginItemRewardModule();
            case 19266:
               return new PlutusPointsUpdateCommand();
            case 19318:
               return new UserMessageNoteDeleteCommand();
            case 19434:
               return new ReplacementTypeModule();
            case 19437:
               return new HintModule();
            case 19521:
               return new TeamDeathMatchDraftConfirmationCommand();
            case 19653:
               return new CommandCenterUpdateDontShowRequest();
            case 19714:
               return new FoundClanRequest();
            case 19867:
               return new RogueLiteInventoryCommand();
            case 19871:
               return new ContactListEntryTypeModule();
            case 19889:
               return new GalaxyGateBuilderMultiplierItemModule();
            case 19963:
               return new DispatchCollectGateRewardRequest();
            case 19983:
               return new InvitationRejectRequest();
            case 20059:
               return new LogbookDataCommand();
            case 20205:
               return new RzoneConfirmationStatusModule();
            case 20226:
               return new ExpeditionShipCommand();
            case 20286:
               return new WorldBossRewardsInfoCommand();
            case 20343:
               return new WorldBossRankingInfoModule();
            case 20425:
               return new AssemblyRecipeStatusModule();
            case 20520:
               return new HangarShipChangeShipModelCommand();
            case 20576:
               return new DispatchSendRetrieverRequest();
            case 20608:
               return new EventReturnOfHeroContributorListCommand();
            case 20921:
               return new DispatchMessageCommand();
            case 20982:
               return new DiminishingQuestRemoveQuestCommand();
            case 21051:
               return new ArmoryUnlockLootShowListCommand();
            case 21088:
               return new UridiumBankInfoCommand();
            case 21168:
               return new GalaxyGateBuilderGateWaveUpdateCommand();
            case 21301:
               return new HangarShipImportConfigRequest();
            case 21485:
               return new EpicFightMessageModule();
            case 21500:
               return new NewQuestsAvailableCommand();
            case 21559:
               return new RzoneLeaveMapRequest();
            case 21619:
               return new UserMessageParentInfoCommand();
            case 21692:
               return new RzoneStatusModule();
            case 21747:
               return new AutopilotInfoRequest();
            case 21778:
               return new TupleThreeModule();
            case 21794:
               return new TrinityTrialsDropLevelCommand();
            case 21806:
               return new HangarShipSellItemRequest();
            case 21835:
               return new TeamDeathMatchExitRequest();
            case 21881:
               return new EternalGateChooseOptionRequest();
            case 21885:
               return new ContactListEntryAttributeOnlineModule();
            case 22099:
               return new WorldBossRewardsTierUpdateCommand();
            case 22225:
               return new TrainingGroundRegistrationUnavailableLowGearScoreCommand();
            case 22281:
               return new CaptainRosterListCommand();
            case 22318:
               return new UnstableModuleModule();
            case 22374:
               return new AssemblyCollectAllRequest();
            case 22604:
               return new RewardTitleModule();
            case 22621:
               return new AuctionBidRequest();
            case 22866:
               return new HangarShipPetView();
            case 23021:
               return new UpLevelSkillTreeRequest();
            case 23079:
               return new ClanBattleStationInfoRequest();
            case 23103:
               return new DeleteMyRankCommand();
            case 23219:
               return new SynthesisInventoryRequest();
            case 23309:
               return new HangarShipEquipmentInventoryItem();
            case 23384:
               return new InventoryItemUpdatedCommand();
            case 23412:
               return new CCCooldownValueModule();
            case 23459:
               return new ArgStackCommand();
            case 23501:
               return new MenuItemToolTipReplacementCommand();
            case 23601:
               return new TrinityTrialsClaimPassRewardRequest();
            case 23633:
               return new MenuItemInitializationCommand();
            case 23774:
               return new ChangeClanTaxRequest();
            case 23923:
               return new HangarShipChangeShipModelRequest();
            case 23930:
               return new HintWindowModule();
            case 23964:
               return new DailyLoginRewardDayRequest();
            case 23966:
               return new TitleFrenzyInfoCommand();
            case 23969:
               return new BoosterEquipmentDetailModule();
            case 24049:
               return new MenuItemStatusCommand();
            case 24113:
               return new FrozenLabyrinthRankModule();
            case 24128:
               return new TieredArenaEventInfoCommand();
            case 24341:
               return new HighlightTypeModule();
            case 24452:
               return new HallOfFameDataListCommand();
            case 24495:
               return new ClanDeleteAllMessageRequest();
            case 24542:
               return new LeaveClanCommand();
            case 24564:
               return new UIButtonTriggerRequest();
            case 24589:
               return new AuctionHistoryCommand();
            case 24604:
               return new GalaxyGateBuilderMultiEnergyRequest();
            case 24773:
               return new ChangeClanLeaderCommand();
            case 24793:
               return new StrikeAndExitScoreCommand();
            case 24808:
               return new EternalGateInfoCommand();
            case 24829:
               return new AuctionQuickBuyRequest();
            case 24874:
               return new TrinityTrialsRewardDescriptionCommand();
            case 24945:
               return new ClanRelationChangedCommand();
            case 25051:
               return new UserMessageSendCommand();
            case 25086:
               return new GetNamFlagCommand();
            case 25175:
               return new ShipDesignPack();
            case 25218:
               return new EternalGateRankModule();
            case 25477:
               return new WarGameScoreUpdateCommand();
            case 25491:
               return new LockAttributeItemRerollRequest();
            case 25633:
               return new ResetSkillTreeCommand();
            case 25698:
               return new BaseStackCommand();
            case 25702:
               return new HangarPetEquipmentMsg();
            case 25740:
               return new DiminishingQuestInitializationCommand();
            case 25741:
               return new ClanRankListRequest();
            case 25806:
               return new ContactListBlockInvitationsModule();
            case 26033:
               return new FactionInfluenceUpdateCommand();
            case 26066:
               return new EventReturnOfHeroStatusCommand();
            case 26180:
               return new SkillTreeListCommand();
            case 26206:
               return new SkylabActionRequest();
            case 26262:
               return new DeleteClanMemberCommand();
            case 26307:
               return new EternalBlacklightCpuInfoCommand();
            case 26390:
               return new SkylabCollectorInfoCommand();
            case 26511:
               return new InternalPilotBioUpdateRequest();
            case 26573:
               return new WorldBossInfoUpdateCommand();
            case 26607:
               return new ChatParamCommand();
            case 26678:
               return new FightActivityModule();
            case 26767:
               return new RewardAchievementModule();
            case 26787:
               return new UserMessageUpdateStatusRequest();
            case 26826:
               return new ClanReportAdminCommand();
            case 26839:
               return new SkylabUnifiedReceiptCommand();
            case 26875:
               return new PlutusScoreEntryModule();
            case 26896:
               return new ContactListEntryAttributeCommand();
            case 26900:
               return new TeamDeathMatchResultScreenCommand();
            case 26931:
               return new ClanTestCommand();
            case 27060:
               return new EternalBlacklightBoosterCommand();
            case 27124:
               return new SoundTriggerModule();
            case 27237:
               return new InternalPilotBioUserProfileCommand();
            case 27276:
               return new GalaxyGateBuilderGateModule();
            case 27320:
               return new TrainingGroundStatusCommand();
            case 27538:
               return new ShipIconModule();
            case 27618:
               return new GalaxyGateBuilderGetGatePartsRequest();
            case 27700:
               return new TrainingArenaPerformanceEntryCommand();
            case 27706:
               return new StopCapsuleCollectCommand();
            case 27710:
               return new NormalTipsCommand();
            case 27718:
               return new ArmoryUnlockLootShowCommand();
            case 27745:
               return new SkylabMainViewCommand();
            case 27750:
               return new ContactListSettingsModule();
            case 27788:
               return new ShopItemBuyCommand();
            case 27806:
               return new BalanceInfoListCommand();
            case 27810:
               return new BattlePassUpdateStatusCommand();
            case 27897:
               return new EventProgressInfoCommand();
            case 27915:
               return new ReturneeLoginBundleInfoCommand();
            case 27999:
               return new PublicWorldBossRaidIntensity();
            case 28017:
               return new VIPMerchantExchangeRequest();
            case 28073:
               return new DispatchSendGateRequest();
            case 28149:
               return new ClanNewDiplomacyRequest();
            case 28159:
               return new MiniClientRewardDayInfoCommand();
            case 28238:
               return new PingMemberRequest();
            case 28266:
               return new HangarShipRepairDroneCommand();
            case 28475:
               return new DispatchBuySlotRequest();
            case 28516:
               return new ClanNewsListRequest();
            case 28522:
               return new VoyagersClaimPassRewardRequest();
            case 28789:
               return new MileageMarketInfoCommand();
            case 28793:
               return new DispatchGetRetrieverListCommand();
            case 28819:
               return new CCAbstractRangeModule();
            case 28835:
               return new HangarShipSaveConfigCommand();
            case 28898:
               return new CCInitRequest();
            case 28987:
               return new ArmoryUnlockSelectGroupRequest();
            case 28994:
               return new UserMessageInitRequest();
            case 29283:
               return new QuantumFluidCoreDataListCommand();
            case 29323:
               return new FrozenLabyrinthKeyInfoCommand();
            case 29408:
               return new TrainingArenaSeasonRewardEntryCommand();
            case 29551:
               return new AgatusEventInfoCommand();
            case 29570:
               return new ClanSendMessageRequest();
            case 29630:
               return new BeaconCommand();
            case 29632:
               return new RzoneUnavailibleStatusModule();
            case 29655:
               return new DispatchGetRewardPackageCommand();
            case 29911:
               return new ClanDeleteRankCommand();
            case 30148:
               return new TrinityTrialsDropLevelOptionalCommand();
            case 30369:
               return new EvoucherHistoryListCommand();
            case 30536:
               return new AssemblyRecipeTypeModule();
            case 30582:
               return new PayloadEscortKeyInfoCommand();
            case 30608:
               return new ReturneeLoginHideUIItemRequest();
            case 30664:
               return new UserMessageNewCommand();
            case 30685:
               return new ClanAllInfoCommand();
            case 30697:
               return new ContactInvitationInfoCommand();
            case 30716:
               return new CommandCenterNewsClickedRequest();
            case 30723:
               return new DelClanRequest();
            case 30847:
               return new GalaxyGateBuilderBuyLifeRequest();
            case 30950:
               return new GroupMemberInitializationCommand();
            case 31119:
               return new GalaxyGateBuilderBuyLifeCommand();
            case 31268:
               return new MenuItemCooldownGroupTimerCommand();
            case 31274:
               return new EternalBlacklightInfoCommand();
            case 31317:
               return new EventUpdateCommand();
            case 31508:
               return new ApplyDeclineRequest();
            case 31546:
               return new HallOfFameRankingPoints();
            case 31556:
               return new SpaceStationCommand();
            case 31718:
               return new UridiumBankClaimCommand();
            case 31883:
               return new Birthday2025GateRewardCommand();
            case 31918:
               return new TrainingArenaPerformanceInfoCommand();
            case 32104:
               return new SlotBarConfigSetRequest();
            case 32135:
               return new EventANewHopeActionCommand();
            case 32320:
               return new EventProgressUpdateCommand();
            case 32321:
               return new EventProgressResetRequest();
            case 32343:
               return new ClanNewsInfoCommand();
            case 32545:
               return new LogBoxInformationRequest();
            case 32620:
               return new BalanceInfoCommand();
            default:
               return null;
         }
      }
   }
}

