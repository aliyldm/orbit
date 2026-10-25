package net.bigpoint.darkorbit.net.netty.handlers.rankings
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.com.module.TitleFrenzyRankingInfoCommand;
   import net.bigpoint.darkorbit.com.module.TitleFrenzyRankingInfoModule;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.RankingsUIEventsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.vo.RankingsUIEventsVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TitleFrenzyRankingInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TitleFrenzyRankingInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         var _loc5_:Vector.<Vector.<String>> = null;
         var _loc6_:TitleFrenzyRankingInfoModule = null;
         super.execute(param1);
         var _loc2_:RankingsUIEventsProxy = retrieveProxy(GuiConstants.RANKINGS_EVENTS) as RankingsUIEventsProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.RANKINGS);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.RANKINGS_EVENTS) as RankingsUIEventsProxy;
         }
         var _loc3_:TitleFrenzyRankingInfoCommand = param1.getBody() as TitleFrenzyRankingInfoCommand;
         if(_loc3_)
         {
            if(!_loc3_.isActive || _loc3_.rankingInfoList == null)
            {
               _loc2_.updateEventsInfo(_loc3_.isActive,null);
               return;
            }
            _loc3_.rankingInfoList.sort(this.sortRank);
            _loc5_ = new Vector.<Vector.<String>>(0);
            for each(_loc6_ in _loc3_.rankingInfoList)
            {
               _loc5_.push(this.converter(_loc6_));
            }
            _loc2_.updateEventsInfo(_loc3_.isActive,new RankingsUIEventsVO(_loc5_,this.converter(_loc3_.nextRank),this.converter(_loc3_.myRank),this.converter(_loc3_.prevRank)));
         }
      }
      
      private function sortRank(param1:TitleFrenzyRankingInfoModule, param2:TitleFrenzyRankingInfoModule) : int
      {
         return param1.rank - param2.rank;
      }
      
      private function converter(param1:TitleFrenzyRankingInfoModule) : Vector.<String>
      {
         if(param1 == null || param1.rank == 0)
         {
            return null;
         }
         var _loc2_:Vector.<String> = new Vector.<String>(0);
         _loc2_.push(param1.rank.toString());
         _loc2_.push(param1.username);
         _loc2_.push(TimeFormatter.formatTimeWithZero(param1.score));
         return _loc2_;
      }
   }
}

