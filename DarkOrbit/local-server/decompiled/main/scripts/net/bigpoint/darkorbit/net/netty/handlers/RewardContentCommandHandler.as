package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.RewardContentCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.PvpSummerUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.TieredArenaUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RewardContentCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function RewardContentCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:PvpSummerUIWindowProxy = null;
         var _loc4_:TieredArenaUIWindowProxy = null;
         var _loc5_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:RewardContentCommand = param1.getBody() as RewardContentCommand;
         switch(_loc2_.rewardType)
         {
            case RewardContentCommand.REWARDTYPE_PVP_SUMMER_EVENT_MILESTONE:
               _loc3_ = retrieveProxy(GuiConstants.PVP_SUMMER) as PvpSummerUIWindowProxy;
               if(!_loc3_)
               {
                  _loc5_ = SimpleWindowCreationMap.getById(GuiConstants.PVP_SUMMER);
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc5_);
                  _loc3_ = retrieveProxy(GuiConstants.PVP_SUMMER) as PvpSummerUIWindowProxy;
               }
               _loc3_.updateNextMilestoneRewards(_loc2_);
               break;
            case RewardContentCommand.REWARDTYPE_TIERED_ARENA_EVENT_PARTICIPATION:
               _loc4_ = retrieveProxy(GuiConstants.TIERED_ARENA) as TieredArenaUIWindowProxy;
               if(!_loc4_)
               {
                  _loc5_ = SimpleWindowCreationMap.getById(GuiConstants.TIERED_ARENA);
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc5_);
                  _loc4_ = retrieveProxy(GuiConstants.TIERED_ARENA) as TieredArenaUIWindowProxy;
               }
               _loc4_.updateParticipationRewards(_loc2_);
         }
      }
   }
}

