package net.bigpoint.darkorbit.net.netty.handlers
{
   import mx.collections.ArrayList;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.CompanyHierarchyInitializationCommand;
   import net.bigpoint.darkorbit.com.module.CompanyHierarchyRankingModule;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.model.proxy.CompanyHierarchyProxy;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.model.vo.RankedClanVO;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CompanyHierarchyInitializationHandler extends BaseHandler
   {
      
      public function CompanyHierarchyInitializationHandler()
      {
         super();
      }
      
      public static function run(param1:CompanyHierarchyInitializationCommand) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:RankedClanVO = null;
         var _loc6_:int = 0;
         var _loc2_:Vector.<ArrayList> = new Vector.<ArrayList>();
         _loc2_.push(new ArrayList());
         _loc2_.push(new ArrayList());
         _loc2_.push(new ArrayList());
         _loc2_.push(new ArrayList());
         addClansToFactionList(param1.mmoRanking,"MMO",_loc2_);
         addClansToFactionList(param1.eicRanking,"EIC",_loc2_);
         addClansToFactionList(param1.vruRanking,"VRU",_loc2_);
         var _loc3_:int = param1.ownRanking.rank;
         if(_loc3_ > 9)
         {
            _loc3_ = 0;
         }
         if(param1.ownRanking.clanId != -1)
         {
            if(_loc2_[param1.ownFaction.faction].length <= 9)
            {
               _loc4_ = false;
               _loc6_ = 0;
               while(_loc6_ < _loc2_[param1.ownFaction.faction].length)
               {
                  _loc5_ = _loc2_[param1.ownFaction.faction].getItemAt(_loc6_) as RankedClanVO;
                  if(_loc5_.clanId == param1.ownRanking.clanId)
                  {
                     _loc4_ = true;
                  }
                  _loc6_++;
               }
               if(!_loc4_ && _loc3_ != 0)
               {
                  _loc2_[param1.ownFaction.faction].addItemAt(new RankedClanVO(param1.ownRanking.rank,InGameCatalog.instance.rankPositions[_loc3_],param1.ownRanking.clanName,param1.ownRanking.leaderName,param1.ownRanking.rankingPoints,param1.ownRanking.clanId,param1.ownRanking.cbsNamesAndLocations),param1.ownRanking.rank - 1);
               }
            }
            _loc2_[param1.ownFaction.faction].addItem(new RankedClanVO(param1.ownRanking.rank,InGameCatalog.instance.rankPositions[_loc3_],param1.ownRanking.clanName,param1.ownRanking.leaderName,param1.ownRanking.rankingPoints,param1.ownRanking.clanId,param1.ownRanking.cbsNamesAndLocations));
         }
         (GameFacade.getInstance().retrieveProxy(CompanyHierarchyProxy.NAME) as CompanyHierarchyProxy).handleRankedClansUpdateFromServer(_loc2_,param1.ownFaction.faction);
      }
      
      private static function addClansToFactionList(param1:Vector.<CompanyHierarchyRankingModule>, param2:String, param3:Vector.<ArrayList>) : void
      {
         var _loc4_:CompanyHierarchyRankingModule = null;
         var _loc5_:String = null;
         for each(_loc4_ in param1)
         {
            _loc5_ = InGameCatalog.instance.rankPositions[_loc4_.rank];
            if(_loc5_ == null)
            {
               _loc5_ = InGameCatalog.instance.rankPositions[0];
            }
            param3[InGameCatalog.instance.factions_names.indexOf(param2)].addItem(new RankedClanVO(_loc4_.rank,_loc5_,_loc4_.clanName,_loc4_.leaderName,_loc4_.rankingPoints,_loc4_.clanId,_loc4_.cbsNamesAndLocations));
         }
      }
   }
}

